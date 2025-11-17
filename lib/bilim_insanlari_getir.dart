import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/wiews/biliminsani.dart'; // klasör ismini 'wiews' kullandıysan böyle bırak

class BilimInsanlariSayfasi extends StatelessWidget {
  const BilimInsanlariSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Firestore'dan tüm bilim insanlarını collectionGroup ile çek
    final future = FirebaseFirestore.instance
        .collectionGroup('bilim_insanlari')
        .get();

    return Scaffold(
      appBar: AppBar(title: const Text('Bilim İnsanları')),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Hiç veri bulunamadı.'));
          }

          // 🔹 Alfabetik sıraya koy
          docs.sort((a, b) => (a['isim'] ?? '')
              .toString()
              .compareTo((b['isim'] ?? '').toString()));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final isim = (doc['isim'] ?? '').toString();
              final kategori = (doc['kategori'] ?? '').toString();
              final path = doc.reference.path; // 🔥 belge yolu

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(isim,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    kategori.isEmpty ? 'Kategori Yok' : kategori,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // 🔹 Detay sayfasına tam belge yolunu gönderiyoruz
                    debugPrint('➡️ Seçilen belge yolu: $path');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Biliminsani(
                          title: isim,
                          kategori: kategori,
                          docPath: path, // ✅ belge yolu gönderildi
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
    );
  }
}
