import 'package:flutter/material.dart';
import '../service/tts_service.dart';

class BulusAciklama extends StatefulWidget {
  final String ad;
  final String aciklama;
  final String? img;

  const BulusAciklama({
    super.key,
    required this.ad,
    required this.aciklama,
    this.img,
  });

  @override
  State<BulusAciklama> createState() => _BulusAciklamaState();
}

class _BulusAciklamaState extends State<BulusAciklama> {
  final tts = TtsService.instance;

  @override
  void initState() {
    super.initState();
    tts.init();
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

  @override
  Widget build(BuildContext context) {
    const Color g1 = Color(0xFF7F00FF);
    const Color g2 = Color(0xFFE100FF);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ad, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: g2,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [g1, g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.img != null && widget.img!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.img!,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (widget.img != null && widget.img!.isNotEmpty)
                    const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.aciklama.isEmpty
                          ? 'Bu bulus icin aciklama henuz eklenmemis.'
                          : widget.aciklama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ValueListenableBuilder<bool>(
                    valueListenable: tts.isSpeaking,
                    builder: (context, speaking, _) {
                      return ElevatedButton(
                        onPressed: widget.aciklama.trim().isEmpty
                            ? null
                            : () async {
                                if (speaking) {
                                  await tts.stop();
                                } else {
                                await tts.speakNow(widget.aciklama);

                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(speaking ? Icons.stop : Icons.volume_up),
                            const SizedBox(width: 10),
                            Text(
                              speaking ? 'Durdur' : 'Sesli Dinle',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
