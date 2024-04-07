import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:kisiler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kisiler_uygulamasi/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapildiMi = false;

  Future<void> ara(String aramKelimesi) async {
    print("Kişi Arama : $aramKelimesi");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AnaSayfaCubit>().kisileriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapildiMi
            ? TextField(
                decoration: const InputDecoration(hintText: "Ara"),
                onChanged: (value) => context.read<AnaSayfaCubit>().ara(value),
              )
            : const Text("Kişiler"),
        actions: [
          aramaYapildiMi
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapildiMi = false;
                    });
                    context.read<AnaSayfaCubit>().kisileriYukle();
                  },
                  icon: const Icon(Icons.clear),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapildiMi = true;
                    });
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
        ],
      ),
      body: BlocBuilder<AnaSayfaCubit, List<Kisiler>>(
        builder: (context, kisilerListesi) {
          if (kisilerListesi.isNotEmpty) {
            return ListView.builder(
              itemCount: kisilerListesi.length,
              itemBuilder: (context, index) {
                var kisi = kisilerListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetaySayfa(kisi: kisi))).then(
                        (value) =>
                            context.read<AnaSayfaCubit>().kisileriYukle());
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                kisi.kisi_Ad,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                kisi.kisi_tel,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("${kisi.kisi_Ad}  silinsin mi"),
                                  action: SnackBarAction(
                                      label: "Evet",
                                      onPressed: () {
                                        context
                                            .read<AnaSayfaCubit>()
                                            .sil(kisi.kisi_id);
                                      }),
                                ));
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const KayitSayfa()))
            .then((value) {
          print("Anasayfaya dönüldü");
          context.read<AnaSayfaCubit>().kisileriYukle();
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
