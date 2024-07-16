// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/feature/pick_place/presentation/cubit/city_cubit.dart';

//membuat statefull widget untuk halaman pick place
class PickPlacePage extends StatefulWidget {
  const PickPlacePage({super.key});

  @override
  State<PickPlacePage> createState() => _PickPlacePageState();
}

class _PickPlacePageState extends State<PickPlacePage> {
  final edtCity = TextEditingController();
  @override
  void initState() {
    edtCity.text = context.read<CityCubit>().init(); //ambil nilai dari state management
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //membuat button Back (awal)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context), 
        label: const Text('Back'),
        icon: const Icon(Icons.arrow_back),
      ), 
      //membuat button Back (akhir)

      body: Stack(
        children: [

          //set background halaman pick place(awal)
          Positioned.fill( 
            child: Image.asset(
              'assets/pick_place.jpg',
              fit: BoxFit.cover,
            ),
          ), 
          //set background halaman pick place(akhir)

          Positioned(
            top: MediaQuery.of(context).size.height / 4, //jarak atas 1/4 dari tinggi maksimum
            left: 30, //jarak ke kiri
            right: 30, //jarak ke kanan

            //layout kolom berisi judul dan textfield untuk input cityname
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //widget stateless teks untuk judul halaman (awal)
                Text(
                    'Set Up\nyour location',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
                //judul halaman (akhir)

                DView.spaceHeight(24), //jarak tulisan set up dengan text input city
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.only(left: 30),
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        //widget statefull textfield
                        child: TextField(
                          controller: edtCity,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none, //menghilangkan border
                            hintText: 'Type city name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //efek untuk untuk memunculkan button hanya ketika ada perubahan di input/ pas ngetik
                          onChanged: (value) {
                            context.read<CityCubit>().listenChange(value);
                          },

                        ),
                      ),
                      DView.spaceWidth(30), //jarak text ke button

                      //membuat widget stateless button (awal)
                      BlocBuilder<CityCubit, String>(
                        builder: (context, state) {
                          if (state == '') return DView.nothing(); //noting berisi sizedbox kosong
                           return IconButton.filledTonal( //kalau nilai state ada maka ditampilkan icon buttonnya
                            onPressed: () {
                              context.read<CityCubit>().saveCity();
                              FocusManager.instance.primaryFocus?.unfocus(); //ketika klik button, keyboard akan menghilang
                              Navigator.pop(context, 'refresh');
                            },
                            icon: const Icon(Icons.check),
                          );
                        },
                      )
                      //membuat widget stateless button (akhir)

                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}