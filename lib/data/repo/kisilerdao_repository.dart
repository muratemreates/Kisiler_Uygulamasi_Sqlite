import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/sqlite/veritabani_yardimcisi.dart';

class KisilerDaoRepository {
  Future<void> kaydet(String kisi_ad, String kisi_tel) async {
    var db =
        await VeriTabaniYardimcisi.veritabaniErisim(); // veritabanına eriştik
    var yeniKisi = Map<String,
        dynamic>(); // oluşturulacak kişiyi tabloya göre şekillendiriyoruz String Sütun adı dynamic ise girilen bilgi

    yeniKisi["kisi_ad"] = kisi_ad;
    yeniKisi["kisi_tel"] = kisi_tel;
    await db.insert("kisiler",
        yeniKisi); //insert() ile oluşturulan kişiyi istediğimiz tabloya ekliyoruz
  }

  Future<void> guncelle(int kisi_id, String kisi_ad, String kisi_tel) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();
    var guncelKisi = Map<String, dynamic>();
    guncelKisi["kisi_ad"] = kisi_ad;
    guncelKisi["kisi_tel"] = kisi_tel;
    await db.update(
        "kisiler", guncelKisi, // update kısmında where koşulu uygulammaız gerek
        where:"kisi_id = ?", // kısmında kisi_id = ? soru işareti kısmını whereArgs ksında primary olan keyi bildiriyoruz.
        whereArgs:[kisi_id]); // tablodaki primary key olan kisi_id yazdık soru işareti yerine orası gelecek
  }

  Future<void> sil(int kisiId) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();
    await db.delete("kisiler",where: "kisi_id = ?", whereArgs: [kisiId] );
  }

  Future<List<Kisiler>> kisileriYukle() async {
    var db =
        await VeriTabaniYardimcisi.veritabaniErisim(); // veritabanına eriştik

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM kisiler"); // tabloya select sorgusu attık // String sütün adı temsil ederken dynamic satırdaki bilgiyi çeker

    return List.generate(maps.length, (index) {
      // hashmap i liste çeviriyoruz
      var satir = maps[
          index]; // kisiler tablosunda ki her bir satıra satir adında atma yaptık
      return Kisiler(
          kisi_id: satir["kisi_id"],
          kisi_Ad: satir["kisi_ad"],
          kisi_tel: satir["kisi_tel"]); // Bilgileri Aktardık
    });
  }

  Future<List<Kisiler>> ara(String aramKelimesi) async {
    var db =
        await VeriTabaniYardimcisi.veritabaniErisim(); // veritabanına eriştik

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM kisiler WHERE kisi_ad like '%$aramKelimesi%'"); // tabloya select sorgusu attık // String sütün adı temsil ederken dynamic satırdaki bilgiyi çeker
                              // Where koşulu ile aramaKelimesi olarka girilen kelimeyi listeye çevirir
    return List.generate(maps.length, (index) {
      // hashmap i liste çeviriyoruz
      var satir = maps[
          index]; // kisiler tablosunda ki her bir satıra satir adında atma yaptık
      return Kisiler(
          kisi_id: satir["kisi_id"],
          kisi_Ad: satir["kisi_ad"],
          kisi_tel: satir["kisi_tel"]); // Bilgileri Aktardık
    });
  }
}
