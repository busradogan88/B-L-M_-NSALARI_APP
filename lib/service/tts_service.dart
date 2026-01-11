import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  // ✅ Sabit voice
  static const String _voiceNamePrimary = 'tr-TR-Wavenet-B';
  static const String _voiceNameFallback = 'tr-TR-Standard-B';
  static const String _languageCode = 'tr-TR';

  /// ✅ --dart-define ile gelen Google Cloud TTS key
  static const String _apiKey =
      String.fromEnvironment('CLOUD_TTS_KEY', defaultValue: "");

  // ✅ Hız/ton
  static const double _speakingRate = 1.12;
  static const double _pitch = 0.0;
  static const int _sampleRateHz = 16000;

  /// HTTP timeout
  static const Duration _httpTimeout = Duration(seconds: 12);

  final ValueNotifier<bool> isSpeaking = ValueNotifier<bool>(false);

  /// UI'da kullanıcıya hata göstermek istersen:
  /// sayfadan: tts.lastErrorMessage.value dinleyebilirsin
  final ValueNotifier<String?> lastErrorMessage = ValueNotifier<String?>(null);

  final AudioPlayer _player = AudioPlayer();

  bool _inited = false;
  bool _stopRequested = false;
  int _token = 0;

  Future<void> init() async {
    if (_inited) return;
    _inited = true;

    // Player bitince speaking kapansın
    _player.playerStateStream.listen((state) {
      final processing = state.processingState;

      // completed/idle -> konuşma bitti
      if ((processing == ProcessingState.completed ||
              processing == ProcessingState.idle) &&
          isSpeaking.value) {
        isSpeaking.value = false;
      }
    }, onError: (e) {
      isSpeaking.value = false;
      lastErrorMessage.value = "Ses oynatıcı hatası: $e";
      debugPrint("just_audio hata: $e");
    });
  }

  Future<void> stop() async {
    _stopRequested = true;
    _token++; // devam eden istekleri iptal et
    try {
      await _player.stop();
    } catch (_) {}
    isSpeaking.value = false;
  }

  /// ✅ Butona basınca hemen oku
  Future<void> speakNow(String text) async {
    final clean = _prepare(text);
    if (clean.isEmpty) return;

    // ✅ her denemede stop flag'ini sıfırla (çok önemli)
    _stopRequested = false;
    lastErrorMessage.value = null;

    // ✅ Key yoksa direkt anlaşılır hata
    if (_apiKey.trim().isEmpty) {
      const msg =
          "CLOUD_TTS_KEY yok. Run/Debug → Additional run args kısmına "
          "--dart-define=CLOUD_TTS_KEY=... ekle.";
      lastErrorMessage.value = msg;
      debugPrint(msg);
      isSpeaking.value = false;
      return;
    }

    await init();
    await stop(); // eski sesi kes
    _stopRequested = false;

    final myToken = ++_token;
    isSpeaking.value = true;

    try {
      // ✅ Metni böl (Cloud sınırı)
      final parts = _splitForCloud(clean, maxLen: 3200);
      if (parts.isEmpty) {
        isSpeaking.value = false;
        return;
      }

      final pcmAll = BytesBuilder(copy: false);

      // ✅ cümle arası kısa boşluk
      final silenceBytes = _silencePcmBytes(_sampleRateHz, millis: 12);

      for (final p in parts) {
        if (_stopRequested || myToken != _token) break;

        // ✅ primary -> fallback
        Uint8List pcm;
        try {
          pcm = await _synthesizeLinear16(p, voiceName: _voiceNamePrimary);
        } catch (_) {
          pcm = await _synthesizeLinear16(p, voiceName: _voiceNameFallback);
        }

        if (_stopRequested || myToken != _token) break;

        pcmAll.add(pcm);
        pcmAll.add(silenceBytes);
      }

      if (_stopRequested || myToken != _token) return;

      final wavBytes = _buildWav(pcmAll.toBytes(), sampleRate: _sampleRateHz);

      // ✅ Web’de dosya yazma yok (just_audio web'de file path sıkıntı)
      if (kIsWeb) {
        lastErrorMessage.value =
            "Web’de dosyaya yazmadan oynatma gerekir. (Mobilde sorun yok)";
        isSpeaking.value = false;
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/cloud_tts_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      await file.writeAsBytes(wavBytes, flush: true);

      if (_stopRequested || myToken != _token) return;

      await _player.setFilePath(file.path);
      await _player.play();
    } on TimeoutException {
      lastErrorMessage.value = "TTS zaman aşımı. İnternet yavaş olabilir.";
      debugPrint("Cloud TTS timeout");
      isSpeaking.value = false;
    } catch (e) {
      lastErrorMessage.value = _prettyError(e);
      debugPrint('Cloud TTS hata: $e');
      isSpeaking.value = false;
    } finally {
      if (_stopRequested) isSpeaking.value = false;
    }
  }

  String _prepare(String t) => t.replaceAll(RegExp(r'\s+'), ' ').trim();

  List<String> _splitForCloud(String text, {required int maxLen}) {
    final base = text
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (base.isEmpty) return const [];

    final out = <String>[];
    final buf = StringBuffer();

    void flush() {
      final s = buf.toString().trim();
      if (s.isNotEmpty) out.add(s);
      buf.clear();
    }

    for (final s in base) {
      if (s.length > maxLen) {
        final sub = s
            .split(RegExp(r',\s+'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty);
        for (final ss in sub) {
          if (buf.isEmpty) {
            buf.write(ss);
          } else if (buf.length + 1 + ss.length <= maxLen) {
            buf.write(' ');
            buf.write(ss);
          } else {
            flush();
            buf.write(ss);
          }
        }
        continue;
      }

      if (buf.isEmpty) {
        buf.write(s);
      } else if (buf.length + 1 + s.length <= maxLen) {
        buf.write(' ');
        buf.write(s);
      } else {
        flush();
        buf.write(s);
      }
    }

    flush();
    return out;
  }

  Future<Uint8List> _synthesizeLinear16(String text,
      {required String voiceName}) async {
    final uri = Uri.parse(
      'https://texttospeech.googleapis.com/v1/text:synthesize?key=$_apiKey',
    );

    final body = {
      "input": {"text": text},
      "voice": {"languageCode": _languageCode, "name": voiceName},
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "speakingRate": _speakingRate,
        "pitch": _pitch,
        "sampleRateHertz": _sampleRateHz,
      }
    };

    final res = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(_httpTimeout);

    if (res.statusCode != 200) {
      // Google bazen json hata döndürür
      throw Exception('TTS ${res.statusCode}: ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return base64Decode(json["audioContent"] as String);
  }

  String _prettyError(Object e) {
    final s = e.toString();

    if (s.contains('401') || s.contains('403')) {
      return "TTS yetki hatası (401/403). API key yanlış olabilir veya TTS API etkin değil.";
    }
    if (s.contains('429')) {
      return "TTS kota/sıklık limiti (429). Biraz bekleyip tekrar dene.";
    }
    if (s.contains('PERMISSION_DENIED')) {
      return "TTS izin hatası. Google Cloud’da Text-to-Speech API açık mı kontrol et.";
    }
    return "Cloud TTS hata: $s";
  }

  Uint8List _silencePcmBytes(int sampleRate, {required int millis}) {
    final samples = (sampleRate * millis / 1000.0).round();
    return Uint8List(samples * 2); // 16-bit mono
  }

  Uint8List _buildWav(Uint8List pcm, {required int sampleRate}) {
    const int channels = 1;
    const int bitsPerSample = 16;
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);

    final dataLen = pcm.length;
    final riffLen = 36 + dataLen;

    final b = BytesBuilder(copy: false);

    void writeStr(String s) => b.add(ascii.encode(s));
    void write32(int v) =>
        b.add(Uint8List(4)..buffer.asByteData().setUint32(0, v, Endian.little));
    void write16(int v) =>
        b.add(Uint8List(2)..buffer.asByteData().setUint16(0, v, Endian.little));

    writeStr('RIFF');
    write32(riffLen);
    writeStr('WAVE');

    writeStr('fmt ');
    write32(16);
    write16(1); // PCM
    write16(channels);
    write32(sampleRate);
    write32(byteRate);
    write16(blockAlign);
    write16(bitsPerSample);

    writeStr('data');
    write32(dataLen);
    b.add(pcm);

    return b.toBytes();
  }
}
