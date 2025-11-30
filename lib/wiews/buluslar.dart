import 'package:flutter/material.dart';
import 'bulusaciklama.dart';
import 'bulus_model.dart';
import 'firestore_bulus_servisi.dart';

class BilimInsaniBuluslar extends StatelessWidget {
  final String kategoriKey;   // örn: "astronomi"
  final String bilimInsaniKey; // örn: "ali kuscu" (doc.id)
  final String bilimInsaniAdi; // ekranda görünen isim: "Ali Kuşçu"

  const BilimInsaniBuluslar({
    super.key,
    required this.kategoriKey,
    required this.bilimInsaniKey,
    required this.bilimInsaniAdi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$bilimInsaniAdi Buluşları"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Bulus>>(
          future: FirestoreBulusServisi.bilimInsaniBuluslariniGetir(
            kategoriKey,
            bilimInsaniKey,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Bir hata oluştu: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final liste = snapshot.data ?? [];

            if (liste.isEmpty) {
              return const Center(
                child: Text(
                  "Bu bilim insanı için henüz buluş eklenmemiş.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: liste.length,
              itemBuilder: (context, index) {
                final bulus = liste[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading:
                        const Icon(Icons.lightbulb, color: Colors.deepPurple),
                    title: Text(
                      bulus.ad,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BulusAciklama(
                            ad: bulus.ad,
                            aciklama: bulus.aciklama,
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
