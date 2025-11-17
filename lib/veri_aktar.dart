import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> veriAktar() async {
  final db = FirebaseFirestore.instance;
  print("🚀 Firestore veri aktarımı başlatılıyor...");

  // 1) EKLENECEK TÜM VERİLER
  final Map<String, List<Map<String, String>>> kategoriler = {
    // --- Mevcutlar ---
    "fizik": [
      {
        "id": "cahit_arf",
        "isim": "Cahit Arf",
        "biyografi": "Cahit Arf, Türk matematikçisidir. Arf halkaları ve Arf değişmeziyle tanınır."
      },
      {
        "id": "ibn_sina",
        "isim": "İbn Sina",
        "biyografi": "İbn Sina, tıp ve felsefe alanında büyük katkılar yapmış bir bilim insanıdır."
      },
    ],

    "astronomi": [
      {
        "id": "ali_kuscu",
        "isim": "Ali Kuşçu",
        "biyografi": "Ali Kuşçu, Osmanlı döneminde astronomi ve matematik alanında önemli çalışmalar yapmıştır."
      },
      // --- İSTEK: Astronomi ekleri ---
      {
        "id": "ebul_vefa",
        "isim": "Ebu’l Vefa",
        "biyografi": "Ebu’l Vefa el-Buzcani, trigonometri ve astronomiye önemli katkılar yapmıştır."
      },
      {
        "id": "battani",
        "isim": "Battani",
        "biyografi": "Muhammed el-Battani, Güneş yılının uzunluğunu yüksek doğrulukla ölçen önemli bir astronomdur."
      },
      {
        "id": "beyruni",
        "isim": "Beyruni",
        "biyografi": "Ebu Reyhan el-Bîrûnî, astronomi, matematik ve coğrafyada öncü çalışmalarıyla bilinir."
      },
      {
        "id": "fergani",
        "isim": "Fergani",
        "biyografi": "Ahmed el-Fergani, gök cisimlerinin hareketleri üzerine yazdığı eserlerle Orta Çağ’da etki bırakmıştır."
      },
    ],

    // --- İSTEK: TIP kategorisi (yeni) ---
    "tip": [
      {
        "id": "ibni_hatip",
        "isim": "İbni Hatip",
        "biyografi": "Lisanu’d-Din İbni Hatip, tıp ve salgın hastalıklar üzerine gözlemleriyle tanınan bir bilgin ve devlet adamıdır."
      },
      {
        "id": "ali_bin_abbas",
        "isim": "Ali bin Abbas",
        "biyografi": "Ali bin Abbas el-Mecusi, 'el-Kamil fi’s-Sınaa' adlı tıp ansiklopedisiyle tanınır."
      },
      {
        "id": "ebul_kasim_zehravi",
        "isim": "Ebu’l-Kasım el-Zehravi",
        "biyografi": "El-Zehravi (Abulcasis), modern cerrahinin öncülerinden; cerrahi aletler ve teknikler geliştirmiştir."
      },
      {
        "id": "ammar_ibni_cesar",
        "isim": "Ammar ibni Cesar",
        "biyografi": "Ammar ibn Ali el-Mawsili, özellikle göz hastalıkları ve katarakt cerrahisiyle ilgili katkılarıyla bilinir."
      },
    ],

    // --- İSTEK: GRAFİK (harita/çizim) kategorisi (yeni) ---
    "grafik": [
      {
        "id": "idrisi",
        "isim": "İdrisi",
        "biyografi": "Muhammed el-İdrisi, ayrıntılı dünya haritaları ve coğrafi çizimleriyle tanınan Orta Çağ bilginidir."
      },
    ],

    // --- İSTEK: KİNEMATİK kategorisi (yeni) ---
    "kinematik": [
      {
        "id": "giyaseddin_cemsit",
        "isim": "Gıyaseddin Cemşit",
        "biyografi": "Gıyaseddin Cemşit el-Kaşi, sayısal yöntemler ve hassas hesaplamalarla bilinen bir matematikçidir."
      },
      {
        "id": "ibni_heysem",
        "isim": "İbni Heysem",
        "biyografi": "İbn el-Heysem (Alhazen), optik ve deneysel yöntemleriyle mekaniğin ve kinematiğin gelişimine katkı sağlamıştır."
      },
    ],
  };

  // 2) YAZMA (merge: true → sadece ekler/günceller)
  for (final entry in kategoriler.entries) {
    final kategori = entry.key;            // örn: "tip"
    final insanlar = entry.value;          // ilgili liste
    final batch = db.batch();

    for (final insan in insanlar) {
      final ref = db
          .collection('kategoriler')
          .doc(kategori)
          .collection('bilim_insanlari')
          .doc(insan['id']);

      batch.set(ref, {
        'isim': insan['isim']!,
        'kategori': kategori,
        'biyografi': insan['biyografi']!,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  print("✅ Tüm kategoriler Firestore'a başarıyla yüklendi!");
}
