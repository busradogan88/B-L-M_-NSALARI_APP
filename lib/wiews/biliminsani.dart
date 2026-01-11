import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'buluslar.dart';
import '/service/tts_service.dart';

class Biliminsani extends StatefulWidget {
  final String title;
  final String kategori;
  final String? docPath;
  final String? docId;

  const Biliminsani({
    super.key,
    required this.title,
    required this.kategori,
    this.docPath,
    this.docId,
  });

  static const Color _g1 = Color(0xFF7F00FF);
  static const Color _g2 = Color(0xFFE100FF);
  static const Color _accent = Color(0xFF6A0DAD);

  @override
  State<Biliminsani> createState() => _BiliminsaniState();
}

class _BiliminsaniState extends State<Biliminsani> {
  final tts = TtsService.instance;

  // ✅ Buton yazısı için: ilk kez mi dinletildi?
  bool _hasPlayedOnce = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await tts.init();
    });
  }

  @override
  void deactivate() {
    tts.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  String _slugify(String s) {
    const map = {
      '\u00c7': 'C',
      '\u00e7': 'c',
      '\u011e': 'G',
      '\u011f': 'g',
      '\u0130': 'I',
      '\u0131': 'i',
      '\u00d6': 'O',
      '\u00f6': 'o',
      '\u015e': 'S',
      '\u015f': 's',
      '\u00dc': 'U',
      '\u00fc': 'u',
    };

    final b = StringBuffer();
    for (final r in s.runes) {
      final c = String.fromCharCode(r);
      b.write(map[c] ?? c);
    }

    var slug = b
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s_-]'), '')
        .replaceAll(RegExp(r'[\s-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    final parts =
        slug.split('_').where((p) => p.isNotEmpty && p.length > 1).toList();
    slug = parts.join('_');
    return slug;
  }

  Future<DocumentReference<Map<String, dynamic>>?> _resolveDocRef() async {
    final db = FirebaseFirestore.instance;

    if (widget.docPath != null && widget.docPath!.isNotEmpty) {
      final p = widget.docPath!.startsWith('/')
          ? widget.docPath!.substring(1)
          : widget.docPath!;
      return db.doc(p);
    }

    final kategoriId = _slugify(widget.kategori).replaceAll('_', '');

    if (widget.docId != null && widget.docId!.isNotEmpty) {
      final r = db
          .collection('kategoriler')
          .doc(kategoriId)
          .collection('bilim_insanlari')
          .doc(widget.docId);
      if ((await r.get()).exists) return r;
    }

    final guessId = _slugify(widget.title);
    final r2 = db
        .collection('kategoriler')
        .doc(kategoriId)
        .collection('bilim_insanlari')
        .doc(guessId);
    if ((await r2.get()).exists) return r2;

    if (widget.kategori.isNotEmpty) {
      final q = await db
          .collection('kategoriler')
          .doc(kategoriId)
          .collection('bilim_insanlari')
          .where('isim', isEqualTo: widget.title)
          .limit(1)
          .get();
      if (q.docs.isNotEmpty) return q.docs.first.reference;
    }

    var cg = await db
        .collectionGroup('bilim_insanlari')
        .where('isim', isEqualTo: widget.title)
        .limit(1)
        .get();
    if (cg.docs.isNotEmpty) return cg.docs.first.reference;

    final altTitle =
        widget.title.replaceAll('-', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (altTitle != widget.title && altTitle.isNotEmpty) {
      cg = await db
          .collectionGroup('bilim_insanlari')
          .where('isim', isEqualTo: altTitle)
          .limit(1)
          .get();
      if (cg.docs.isNotEmpty) return cg.docs.first.reference;
    }

    return null;
  }

  /// ✅ TTS hata mesajını gösterecek kutu
  Widget _ttsErrorBox() {
    final ValueListenable<String?> notifier =
        (tts as dynamic).lastErrorMessage ?? (tts as dynamic).lastError;

    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, msg, _) {
        if (msg == null || msg.trim().isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.red, height: 1.35),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _speakOrStop(String bio, bool speaking) async {
    if (speaking) {
      await tts.stop();
      // ✅ Durdurunca artık "Devam Et" görünsün
      if (mounted) setState(() => _hasPlayedOnce = true);
      return;
    }

    await tts.init();

    // ✅ Konuşmayı başlatınca "Durdur" gelsin, sonrasında durdurulunca "Devam Et"
    if (mounted) setState(() => _hasPlayedOnce = true);

    try {
      await (tts as dynamic).speakNow(bio);
    } catch (_) {
      await (tts as dynamic).speakKidsMode(bio);
    }

    // Hata varsa SnackBar
    try {
      final msg = (tts as dynamic).lastErrorMessage?.value ??
          (tts as dynamic).lastError?.value;
      if (!mounted) return;
      if (msg != null && msg.toString().trim().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.toString())),
        );
      }
    } catch (_) {}
  }

  String _sesButonYazisi(bool speaking) {
    if (speaking) return "Durdur";
    if (_hasPlayedOnce) return "Devam Et";
    return "Sesli Dinle";
  }

  IconData _sesButonIkonu(bool speaking) {
    if (speaking) return Icons.stop;
    if (_hasPlayedOnce) return Icons.play_arrow;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentReference<Map<String, dynamic>>?>(
      future: _resolveDocRef(),
      builder: (context, refSnap) {
        if (refSnap.connectionState == ConnectionState.waiting) {
          return _shell(
            contextTitle: widget.title,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final ref = refSnap.data;
        if (ref == null) {
          return _shell(
            contextTitle: widget.title,
            child: const Center(child: Text('Belge bulunamadi.')),
          );
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: ref.snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return _shell(
                contextTitle: widget.title,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (!snap.hasData || !(snap.data?.exists ?? false)) {
              return _shell(
                contextTitle: widget.title,
                child: const Center(child: Text('Belge bulunamadi.')),
              );
            }

            final data = snap.data!.data()!;
            final isim = (data['isim'] ?? widget.title).toString();
            final bio = (data['biyografi'] ?? '').toString();
            final kat = (data['kategori'] ?? widget.kategori).toString();

            return _shell(
              contextTitle: isim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Biliminsani._g1, Biliminsani._g2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Text(
                        kat.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isim,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Biliminsani._accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Biliminsani._accent.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        bio.trim().isEmpty ? 'Biyografi bulunamadi.' : bio,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, height: 1.45),
                      ),
                    ),

                    // ✅ TTS hata kutusu
                    _ttsErrorBox(),

                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Biliminsani._g1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.lightbulb_outline),
                            label: const Text('Buluslari Goruntule'),
                            onPressed: () async {
                              await tts.stop();
                              if (!context.mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BilimInsaniBuluslar(
                                    kategoriKey: ref.parent.parent?.id ??
                                        _slugify(kat).replaceAll('_', ''),
                                    bilimInsaniKey: ref.id,
                                    bilimInsaniAdi: isim,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // ✅ SES BUTONU (Sesli Dinle / Durdur / Devam Et)
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: tts.isSpeaking,
                            builder: (context, speaking, _) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Biliminsani._g2,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: Icon(_sesButonIkonu(speaking)),
                                label: Text(_sesButonYazisi(speaking)),
                                onPressed: bio.trim().isEmpty
                                    ? null
                                    : () => _speakOrStop(bio, speaking),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _shell({required String contextTitle, required Widget child}) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          contextTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Biliminsani._g1, Biliminsani._g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
