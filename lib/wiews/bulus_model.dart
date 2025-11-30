import 'package:cloud_firestore/cloud_firestore.dart';

class Bulus {
  final String id;
  final String ad;
  final String aciklama;

  Bulus({
    required this.id,
    required this.ad,
    required this.aciklama,
  });

  factory Bulus.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bulus(
      id: doc.id,
      ad: data['ad'] ?? '',
      aciklama: data['aciklama'] ?? '',
    );
  }
}
