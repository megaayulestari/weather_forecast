import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_forecast/commons/enums.dart';
import 'package:weather_forecast/feature/pick_place/presentation/cubit/city_cubit.dart';
import 'package:weather_forecast/feature/pick_place/presentation/pages/pick_place_page.dart';
import 'package:weather_forecast/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initlocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<CityCubit>()), //daftarin provider cubit
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, //nonaktifkan debug
        theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts
                .poppinsTextTheme(), //tema text ambil dari google poppin
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              //indikator loading
              color: Colors.white,
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => const PickPlacePage(),
          AppRoute.pickPlace.name: (context) => const Scaffold(),
          AppRoute.hourlyForecast.name: (context) => const Scaffold(),
        },
      ),
    );
  }
}
