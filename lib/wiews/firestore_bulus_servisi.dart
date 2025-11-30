import 'package:cloud_firestore/cloud_firestore.dart';
import 'bulus_model.dart';

class FirestoreBulusServisi {
  // kategoriler/{kategoriKey}/bilim_insanlari/{bilimInsaniKey}/buluslar
  static Future<List<Bulus>> bilimInsaniBuluslariniGetir(
    String kategoriKey,
    String bilimInsaniKey,
  ) async {
    final ref = FirebaseFirestore.instance
        .collection('kategoriler')
        .doc(kategoriKey)
        .collection('bilim_insanlari')
        .doc(bilimInsaniKey)
        .collection('buluslar');

    final snap = await ref.get();
    return snap.docs.map((d) => Bulus.fromFirestore(d)).toList();
  }
}
