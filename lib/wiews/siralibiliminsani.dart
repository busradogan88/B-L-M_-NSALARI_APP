import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'biliminsani.dart';

class Siralibiliminsani extends StatelessWidget {
  final String kategori;
  const Siralibiliminsani({super.key, required this.kategori});

  // Türkçe karakterleri normalize edip Firestore doc id üret
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
    return b
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s_-]'), '')
        .replaceAll(RegExp(r'[\s-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final kategoriId = _slugify(kategori).replaceAll('_', '');
    final query = FirebaseFirestore.instance
        .collection('kategoriler')
        .doc(kategoriId)
        .collection('bilim_insanlari')
        .orderBy('isim');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "$kategori Bilim İnsanları",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Bu kategori için bilim insanı bulunamadı.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data();
                final isim = (data['isim'] ?? '').toString();
                final docPath = doc.reference.path;
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.deepPurple),
                    title: Text(
                      isim,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Biliminsani(
                            title: isim,
                            kategori: kategori,
                            docPath: docPath,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

