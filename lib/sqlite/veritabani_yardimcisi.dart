import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeriTabaniYardimcisi {
  static final String veriTabaniAdi = "rehber.sqlite"; // veritabanı adı yazılır

  static Future<Database> veritabaniErisim() async { // veritabanına erişiyoruz
    String veritabaniYolu = join(await getDatabasesPath(), veriTabaniAdi); //veri tabanı yolunu tanıtıyoruz 

    if (await databaseExists(veritabaniYolu)) { // bu isimde veri tabanı varsa uyari gönder kopyalama yapma
      print("Veritabanı zaten  var Kopyalamaya gerek yok");
    } 
    else { // bu isimde veri tabanı yok ise veritabanını kopyala 
      ByteData data = await rootBundle.load("veritabani/$veriTabaniAdi");// burada proje dosaymızda veritabanı klasörü altında veritabanı adına erişir
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);// veri tabanına eriştikten sonra veritabanındaki verileri okuma kısmı List'e çeviriyoruz
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);// veritabanını kopyalıyor
      print("Veritabanı kopyalandı");// kopyalama işlemi uyarı verdik
    }
    return openDatabase(veritabaniYolu); // veritabanına ulaşıyoruz
  }
}
