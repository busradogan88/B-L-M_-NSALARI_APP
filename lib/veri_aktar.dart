import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> veriAktar() async {
  final db = FirebaseFirestore.instance;
  print("Firestore veri aktarimi basliyor...");

  // 1) Bilim insanlari listesi
  final Map<String, List<Map<String, String>>> kategoriler = {
    "fizik": [
      {
        "id": "cahit_arf",
        "isim": "Cahit Arf",
        "biyografi":
            "Cahit Arf, Turk matematikcisidir. Arf halkalari ve Arf degismeziyle taninir.",
      },
      {
        "id": "ibn_sina",
        "isim": "Ibn Sina",
        "biyografi":
            "Ibn Sina, tip ve felsefe alaninda buyuk katkilar yapmis bir bilim insanidir.",
      },
    ],

    "astronomi": [
      {
        "id": "ali_kuscu",
        "isim": "Ali Kuscu",
        "biyografi":
            "Ali Kuscu, Osmanli doneminde astronomi ve matematik alaninda onemli calismalar yapti.",
      },
      {
        "id": "ebul_vefa",
        "isim": "Ebul Vefa",
        "biyografi":
            "Ebul Vefa el-Buzcani, trigonometri ve astronomiye onemli katkilar yapti.",
      },
      {
        "id": "battani",
        "isim": "Battani",
        "biyografi":
            "Muhammed el-Battani, Gunes yilinin uzunlugunu dogrulukla olcen onemli bir astronomdur.",
      },
      {
        "id": "beyruni",
        "isim": "Beyruni",
        "biyografi":
            "Ebu Reyhan el-Beyruni, astronomi, matematik ve cografyada oncu calismalariyla bilinir.",
      },
      {
        "id": "fergani",
        "isim": "Fergani",
        "biyografi":
            "Ahmed el-Fergani, gok cisimlerinin hareketleri uzerine eserleriyle Orta Cag'da etki birakti.",
      },
    ],

    "tip": [
      {
        "id": "ibni_hatip",
        "isim": "Ibni Hatip",
        "biyografi":
            "Lisanuddin Ibni Hatip, tip ve salg in hastaliklar uzerine gozlemleriyle taninan bir bilgin ve devlet adami.",
      },
      {
        "id": "ali_bin_abbas",
        "isim": "Ali bin Abbas",
        "biyografi":
            "Ali bin Abbas el-Mecusi, 'el-Kamil fit-Tibb' adli tip ansiklopedisiyle taninir.",
      },
      {
        "id": "ebul_kasim_zehravi",
        "isim": "Ebul-Kasim el-Zehravi",
        "biyografi":
            "El-Zehravi (Abulcasis), modern cerrahinin onculerinden; cerrahi aletler ve teknikler gelistirdi.",
      },
      {
        "id": "ammar_ibni_cesar",
        "isim": "Ammar ibni Cesar",
        "biyografi":
            "Ammar ibn Ali el-Mawsili, goz hastaliklari ve katarakt cerrahisindeki katkilarıyla bilinir.",
      },
    ],

    "grafik": [
      {
        "id": "idrisi",
        "isim": "Idrisi",
        "biyografi":
            "Muhammed el-Idrisi, ayrintili dunya haritalari ve cografi cizimleriyle taninan Orta Cag bilginidir.",
      },
    ],

    "kinematik": [
      {
        "id": "giyaseddin_cemsit",
        "isim": "Giyaseddin Cemsit",
        "biyografi":
            "Giyaseddin Cemsit el-Kasi, sayisal yontemler ve hassas hesaplamalarla bilinen bir matematikcidir.",
      },
      {
        "id": "ibni_heysem",
        "isim": "Ibni Heysem",
        "biyografi":
            "Ibni Heysem (Alhazen), optik ve deneysel yontemleriyle mekaniğin ve kinematigin gelisimine katkı sagladi.",
      },
    ],
  };

  // 1-b) Her bilim insanina ait bulus listesi (3'er adet)
  final Map<String, Map<String, List<Map<String, String>>>> bulusVerileri = {
    "fizik": {
      "cahit_arf": [
        {
          "id": "arf_degismezi",
          "ad": "Arf Degismezi",
          "aciklama": "Cebirsel esitliklerin siniflanmasinda kullanilan degerleme yaklasimi",
        },
        {
          "id": "arf_halkalari",
          "ad": "Arf Halkalari",
          "aciklama": "Tekil noktalarin incelenmesinde onemli halka teorisi katkisi",
        },
        {
          "id": "arf_kapatilmasi",
          "ad": "Arf Kapatilmasi",
          "aciklama": "Cebirsel kapatma adimlarina yonelik yontem",
        },
      ],
      "ibn_sina": [
        {
          "id": "kanun_fit_tip",
          "ad": "El-Kanun fit-Tibb",
          "aciklama": "Yuzyillarca temel referans olan tip ansiklopedisi",
        },
        {
          "id": "hastalik_siniflama",
          "ad": "Hastalik Siniflama",
          "aciklama": "Semptom temelli tibbi siniflama onerileri",
        },
        {
          "id": "ilac_deneyleri",
          "ad": "Ilac Deneyleri",
          "aciklama": "Gozlem ve deney temelli tedavi yaklasimlari",
        },
      ],
    },
    "astronomi": {
      "ali_kuscu": [
        {
          "id": "fethiye",
          "ad": "Fethiye Risalesi",
          "aciklama": "Gok cisimlerinin hareketlerine dair metin",
        },
        {
          "id": "dunya_donusu",
          "ad": "Dunyanin Donusu",
          "aciklama": "Dunyanin hareketsiz olmadigini savunan risale",
        },
        {
          "id": "zic_i_ulugh_bey",
          "ad": "Zic-i Ulugh Bey Serhi",
          "aciklama": "Ulug Bey zici uzerine aciklamalar",
        },
      ],
      "ebul_vefa": [
        {
          "id": "sinus_kurali",
          "ad": "Sinus Kurali",
          "aciklama": "Trigonometriye onemli katkilar",
        },
        {
          "id": "gok_olcumleri",
          "ad": "Gok Olcumleri",
          "aciklama": "Yildiz konumlarinin hassas hesaplari",
        },
        {
          "id": "kure_trigonometri",
          "ad": "Kure Trigonometrisi",
          "aciklama": "Kure uzerinde trigonometrik islemler",
        },
      ],
      "battani": [
        {
          "id": "gunes_yili",
          "ad": "Gunes Yili Hesabi",
          "aciklama": "Gunes yilinin dogrulukla olculmesi",
        },
        {
          "id": "ay_yorungesi",
          "ad": "Ay Yorungesi",
          "aciklama": "Ayin hareketleri uzerine gozlemler",
        },
        {
          "id": "zic_tablosu",
          "ad": "Zic Tablolari",
          "aciklama": "Hesaplama tablolari gelistirmesi",
        },
      ],
      "beyruni": [
        {
          "id": "yerin_yaricapi",
          "ad": "Yerin Yaricapi",
          "aciklama": "Daglardan olcerek yer capi hesabi",
        },
        {
          "id": "el_kanunul_mesudi",
          "ad": "El-Kanunul-Mesudi",
          "aciklama": "Astronomi ansiklopedisi",
        },
        {
          "id": "astroloji_elestirisi",
          "ad": "Astroloji Elestirisi",
          "aciklama": "Astrolojinin bilimsel yontemden ayrilmasi",
        },
      ],
      "fergani": [
        {
          "id": "felek_hareketleri",
          "ad": "Felek Hareketleri",
          "aciklama": "Gok cisimlerinin hareketleri uzerine kitap",
        },
        {
          "id": "meridyen_olcumu",
          "ad": "Meridyen Olcumu",
          "aciklama": "Yer cevresinin hesaplanmasi",
        },
        {
          "id": "astronomi_giris",
          "ad": "Astronomiye Giris",
          "aciklama": "Astronomi uzerine populer anlatilar",
        },
      ],
    },
    "tip": {
      "ibni_hatip": [
        {
          "id": "bulasici_hastalik",
          "ad": "Bulasici Hastalik Gozlemi",
          "aciklama": "Hastaliklarin yayilimina dair erken gozlemler",
        },
        {
          "id": "karantina",
          "ad": "Karantina Onerileri",
          "aciklama": "Salginda izolasyon uygulamalari",
        },
        {
          "id": "hijyen_kurallari",
          "ad": "Hijyen Kurallari",
          "aciklama": "Temizlik ve havalandirma tavsiyeleri",
        },
      ],
      "ali_bin_abbas": [
        {
          "id": "el_kamil_fit_tibb",
          "ad": "El-Kamil fit-Tibb",
          "aciklama": "Kapsamli tip ansiklopedisi",
        },
        {
          "id": "cerrahi_aciklama",
          "ad": "Cerrahi Aciklamalar",
          "aciklama": "Cerrahi yontemler ve aletler",
        },
        {
          "id": "farmakoloji_notlari",
          "ad": "Farmakoloji Notlari",
          "aciklama": "Bitkisel tedavilere dair bilgiler",
        },
      ],
      "ebul_kasim_zehravi": [
        {
          "id": "tasrif",
          "ad": "Et-Tasrif",
          "aciklama": "30 ciltlik tip ansiklopedisi ve cerrahi bolumu",
        },
        {
          "id": "cerrahi_aletler",
          "ad": "Cerrahi Aletler",
          "aciklama": "Cok sayida cerrahi alet tasarimi",
        },
        {
          "id": "koterizasyon",
          "ad": "Koterizasyon Teknikleri",
          "aciklama": "Kanama durdurma ve yara bakimi",
        },
      ],
      "ammar_ibni_cesar": [
        {
          "id": "katarakt_ameliyati",
          "ad": "Katarakt Ameliyati",
          "aciklama": "Katarakt icin erken cerrahi yontem",
        },
        {
          "id": "gorme_cihazi",
          "ad": "Gorme Cihazi",
          "aciklama": "Goz muayenesinde kullanilan basit alet",
        },
        {
          "id": "goz_damlasi",
          "ad": "Goz Damla Formulleri",
          "aciklama": "Goz rahatsizliklari icin receteler",
        },
      ],
    },
    "grafik": {
      "idrisi": [
        {
          "id": "tabula_rogeriana",
          "ad": "Tabula Rogeriana",
          "aciklama": "Ayrintili dunya haritasi",
        },
        {
          "id": "cografi_cizimler",
          "ad": "Cografi Cizimler",
          "aciklama": "Bolge bolge cizim ve betimlemeler",
        },
        {
          "id": "projeksiyon_teknigi",
          "ad": "Projeksiyon Teknigi",
          "aciklama": "Harita projeksiyon yontemleri",
        },
      ],
    },
    "kinematik": {
      "giyaseddin_cemsit": [
        {
          "id": "sinus_yaklastirmasi",
          "ad": "Sinus Yaklastirmasi",
          "aciklama": "Trigonometrik hesaplara katkilar",
        },
        {
          "id": "hassas_hesaplama",
          "ad": "Hassas Hesaplama Tablolari",
          "aciklama": "Hassas sayisal yontemler",
        },
        {
          "id": "gorme_cihazi",
          "ad": "Gozlem Cihazi",
          "aciklama": "Astronomik gozlem icin cihaz tasarimi",
        },
      ],
      "ibni_heysem": [
        {
          "id": "kamera_obscura",
          "ad": "Kamera Obscura",
          "aciklama": "Optik deney ve goruntuleme aciklamasi",
        },
        {
          "id": "isik_kirilmasi",
          "ad": "Isigin Kirilmasi",
          "aciklama": "Kirilma kanunlarina dair bulgular",
        },
        {
          "id": "goruntuleme_teorisi",
          "ad": "Goruntuleme Teorisi",
          "aciklama": "Goz ve gorme algisina dair teori",
        },
      ],
    },
  };

  // 2) Bilim insanlarini yaz (merge: true -> sadece ekle/guncelle)
  for (final entry in kategoriler.entries) {
    final kategori = entry.key;
    final insanlar = entry.value;
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

  // 3) Buluslari yaz (her bilim insani icin 3'er adet)
  for (final katEntry in bulusVerileri.entries) {
    final kategori = katEntry.key;
    final insanlar = katEntry.value;

    for (final insanEntry in insanlar.entries) {
      final bilimInsaniKey = insanEntry.key;
      final buluslar = insanEntry.value;
      final batch = db.batch();

      for (final bulus in buluslar) {
        final ref = db
            .collection('kategoriler')
            .doc(kategori)
            .collection('bilim_insanlari')
            .doc(bilimInsaniKey)
            .collection('buluslar')
            .doc(bulus['id']);

        batch.set(ref, {
          'ad': bulus['ad'] ?? '',
          'aciklama': bulus['aciklama'] ?? '',
        }, SetOptions(merge: true));
      }

      await batch.commit();
    }
  }

  print("Tum kategoriler Firestore'a basariyla yuklendi!");
}
