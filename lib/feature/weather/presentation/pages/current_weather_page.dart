
// ignore_for_file: deprecated_member_use

//import 'dart:ffi';
import 'package:d_view/d_view.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/commons/app_constants.dart';
import 'package:weather_forecast/commons/enums.dart';
import 'package:weather_forecast/commons/extension.dart';
import 'package:weather_forecast/feature/weather/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_forecast/feature/weather/presentation/widgets/basic_shadow.dart';
import 'package:extended_image/extended_image.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui show ImageFilter, lerpDouble;

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

//Current Weather page structure
class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  refresh() {
    context.read<CurrentWeatherBloc>().add(OnGetCurrentWeather());
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: background(),
          ),

          //pengaturan shadow
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height/2,
              width: double.infinity,
              child: BasicShadow(topDown: false),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/8,
            width: double.infinity,
            child: BasicShadow(topDown: true),
          ),

          //Header
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 50,
                  right: 20,
                ),
                child: headerAction(),
              ),
              Expanded(
                child: foreground(),
              ),
            ],
          ),
        ],
      ),
    );
    
  }

  Widget foreground() {
    return BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
      builder: (context, state) {
        if (state is CurrentWeatherLoading) return DView.loadingCircle();
        if (state is CurrentWeatherFailure) {
          return Column(
            key: const Key('part_error'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DView.error(data: state.message),
              IconButton.filledTonal(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          );
        }
        if (state is CurrentWeatherLoaded) {
          final weather = state.data;
          return Padding(
            key: const Key('weather_loaded'),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //menampilkan nama kota
                Text(
                  weather.cityName??'',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black12,
                        offset: Offset(2, 2)
                      ),
                    ],
                  ),
                ),

                //menampilkan kondisi cuaca
                Text(
                  '- ${weather.main} -',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2)
                      ),
                    ],
                  ),
                ),

                //menampilkan icon sesuai kondisi cuaca
                ExtendedImage.network(
                  URLs.weatherIcon(weather.icon),
                ),

                //menampilkan deskripsi
                Text(
                  weather.description.capitalize,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black45,
                        offset: Offset(2, 2)
                      ),
                    ],
                  ),
                ),

                //menampilkan tanggal 
                Text(
                  DateFormat('EEEE, d MMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2)
                      ),
                    ],
                  ),
                ),
                // ignore: deprecated_member_use;
                DView.spaceHeight(20),
                Text(
                  '${(weather.temperature-273.15).round()}\u2103',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2)
                      ),
                    ],
                  ),
                ),
                DView.spaceHeight(20),
                GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 60,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  children: [
                    itemStat(
                      icon: Icons.thermostat, 
                      title: 'Temperature', 
                      data: '${weather.temperature}°K',
                    ),
                     itemStat(
                      icon: Icons.air, 
                      title: 'Wind', 
                      data: '${weather.wind}m/s',
                    ),
                     itemStat(
                      icon: Icons.compare_arrows, 
                      title: 'Pressure', 
                      data: '${NumberFormat.currency(
                        decimalDigits: 0,
                        symbol: '',
                      ).format(weather.pressure)}hPa',
                    ),
                     itemStat(
                      icon: Icons.water_drop_outlined, 
                      title: 'Humidity', 
                      data: '${weather.humidity}%',
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget itemStat({
    required IconData icon,
    required String title,
    required String data,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            radius: 18,
            child: Icon(icon),
          ),
          DView.spaceWidth(6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                data,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Widget Header terdiri 3 button
  Widget headerAction() {
    return Row(
      children: [
        buttonAction(
          onTap: () {
            Navigator.pushNamed(
              context, 
              AppRoute.pickPlace.name,
            ).then((backResponse) {
              if (backResponse == null) return;
              if (backResponse == 'refresh') refresh();
            });
          }, 
          title: 'City', 
          icon: Icons.edit,
        ),
        DView.spaceWidth(8),
        buttonAction(
          onTap: () => refresh(), 
          title: 'Refresh', 
          icon: Icons.refresh,
        ),
        DView.spaceWidth(8),
        buttonAction(
          onTap: () {
            Navigator.pushNamed(context, AppRoute.hourlyForecast.name);
          }, 
          title: 'Hourly', 
          icon: Icons.access_time,
        ),
      ],
    );
  }

  //Widget Button yg ada di header
  Widget buttonAction({
    required VoidCallback onTap,
    required String title,
    required IconData icon,
  }) {
    return Expanded(
      child: Material(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                // ignore: deprecated_member_use;
                DView.spaceWidth(4),
                Icon(icon, size: 12, color: Colors.white,),
              ],
            ),
          ),
        ),
      ),
    );
  }




  //Widget basicShadow() => DView.nothing();

  //Widget menampilkan Background by kondisi cuaca
  Widget background() {
    return BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
      builder: (context, state) {
        String assetPath = weatherBG.entries.first.value;
        if(state is CurrentWeatherLoaded){
          assetPath = weatherBG[state.data.description] ?? assetPath;
        }
        return Image.asset(
          assetPath,
          fit: BoxFit.cover,
        );
      },
    );
  }
}

