import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'buluslar.dart';

class Biliminsani extends StatelessWidget {
  final String title;        // Örn: "Ali Kuşçu"
  final String kategori;     // Örn: "Astronomi"
  final String? docPath;     // Firestore belge yolu
  final String? docId;       // Belge ID'si

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

  String _slugify(String s) {
    const map = {
      'Ç': 'C', 'ç': 'c',
      'Ğ': 'G', 'ğ': 'g',
      'İ': 'I', 'I': 'I', 'ı': 'i', 'i': 'i',
      'Ö': 'O', 'ö': 'o',
      'Ş': 'S', 'ş': 's',
      'Ü': 'U', 'ü': 'u',
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
    final parts = slug.split('_').where((p) => p.isNotEmpty && p.length > 1).toList();
    slug = parts.join('_');
    return slug;
  }

  Future<DocumentReference<Map<String, dynamic>>?> _resolveDocRef() async {
    final db = FirebaseFirestore.instance;

    if (docPath != null && docPath!.isNotEmpty) {
      final p = docPath!.startsWith('/') ? docPath!.substring(1) : docPath!;
      return db.doc(p);
    }

    final kategoriId = _slugify(kategori).replaceAll('_', '');

    if (docId != null && docId!.isNotEmpty) {
      final r = db
          .collection('kategoriler')
          .doc(kategoriId)
          .collection('bilim_insanlari')
          .doc(docId);
      if ((await r.get()).exists) return r;
    }

    final guessId = _slugify(title);
    final r2 = db
        .collection('kategoriler')
        .doc(kategoriId)
        .collection('bilim_insanlari')
        .doc(guessId);
    if ((await r2.get()).exists) return r2;

    if (kategori.isNotEmpty) {
      final q = await db
          .collection('kategoriler')
          .doc(kategoriId)
          .collection('bilim_insanlari')
          .where('isim', isEqualTo: title)
          .limit(1)
          .get();
      if (q.docs.isNotEmpty) return q.docs.first.reference;
    }

    var cg = await db
        .collectionGroup('bilim_insanlari')
        .where('isim', isEqualTo: title)
        .limit(1)
        .get();
    if (cg.docs.isNotEmpty) return cg.docs.first.reference;

    final altTitle = title.replaceAll('-', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (altTitle != title && altTitle.isNotEmpty) {
      cg = await db
          .collectionGroup('bilim_insanlari')
          .where('isim', isEqualTo: altTitle)
          .limit(1)
          .get();
      if (cg.docs.isNotEmpty) return cg.docs.first.reference;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentReference<Map<String, dynamic>>?>(
      future: _resolveDocRef(),
      builder: (context, refSnap) {
        if (refSnap.connectionState == ConnectionState.waiting) {
          return _shell(
            contextTitle: title,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final ref = refSnap.data;
        if (ref == null) {
          return _shell(
            contextTitle: title,
            child: const Center(child: Text('Belge bulunamadı.')),
          );
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: ref.snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return _shell(
                contextTitle: title,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (!snap.hasData || !(snap.data?.exists ?? false)) {
              return _shell(
                contextTitle: title,
                child: const Center(child: Text('Belge bulunamadı.')),
              );
            }

            final data = snap.data!.data()!;
            final isim = (data['isim'] ?? title).toString();
            final bio = (data['biyografi'] ?? '').toString();
            final kat = (data['kategori'] ?? kategori).toString();

            return _shell(
              contextTitle: isim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [_g1, _g2],
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
                        color: _accent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _accent.withOpacity(0.25), width: 1),
                      ),
                      child: Text(
                        bio.isEmpty ? 'Biyografi bulunamadı.' : bio,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, height: 1.45),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // 🔽 Aşağıdaki iki buton
                    Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: _g1,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Buluşları Görüntüle'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BilimInsaniBuluslar(
                kategoriKey: ref.parent?.parent?.id ?? _slugify(kat).replaceAll('_', ''),
                bilimInsaniKey: ref.id,
                bilimInsaniAdi: isim,
              ),
            ),
          );
        },
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton.icon( // ⬅️ OUTLINED yerine ELEVATED
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: _g2,              // farklı bir ton istersen _g2
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.volume_up),
        label: const Text('Sesli Dinle'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sesli okuma özelliği yakında eklenecek!'),
            ),
          );
        },
      ),
    ),
  ],
)

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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_g1, _g2],
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
