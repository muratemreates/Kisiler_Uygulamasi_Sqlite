import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/data/repo/kisilerdao_repository.dart';
import 'package:kisiler_uygulamasi/ui/views/anasayfa.dart';

class AnaSayfaCubit extends Cubit<List<Kisiler>> {
  AnaSayfaCubit() : super(<Kisiler>[]);

  var krepo = KisilerDaoRepository();
  Future<void> kisileriYukle() async {
    var list = await krepo.kisileriYukle();
    emit(list);
  }

  Future<void> ara(String aramKelimesi) async {
    var list = await krepo.ara(aramKelimesi);
    emit(list);
  }

  Future<void> sil(int kisiId) async {
    await krepo.sil(kisiId);
    await kisileriYukle();
  }
}
