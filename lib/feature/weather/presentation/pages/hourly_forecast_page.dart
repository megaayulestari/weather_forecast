import 'package:d_view/d_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/api/urls.dart';
import 'package:weather_forecast/commons/app_constants.dart';
import 'package:weather_forecast/feature/weather/domain/entities/weather_entity.dart';
import 'package:weather_forecast/feature/weather/presentation/bloc/hourly_forecast/hourly_forecast_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class HourlyForecastPage extends StatefulWidget {
  const HourlyForecastPage({super.key});

  @override
  State<HourlyForecastPage> createState() => _HourlyForecastPageState();
}

class _HourlyForecastPageState extends State<HourlyForecastPage> {
  refresh() {
    context.read<HourlyForecastBloc>().add(OnGetHourlyForecast());
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
          // Positioned.fill(
          //   child: Material(
          //     color: Colors.black.withOpacity(0.7),
          //   ),
          // ),
          foreground(),
        ],
      ),
    );
  }

  Widget background() {
    return Image.asset(
      weatherBG['shower rain']!,
      fit: BoxFit.cover,
    );
  }

  Widget foreground() {
    return Column(
      children: [
        AppBar(
          title: const Text('Hourly Forecast'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          forceMaterialTransparency: true,
        ),
        Expanded(
          child: BlocBuilder<HourlyForecastBloc, HourlyForecastState>(
            builder: (context, state){
              if (state is HourlyForecastLoading) return DView.loadingCircle();
              if (state is HourlyForecastFailure) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.white60,

                      ),
                    ),
                    // ignore: deprecated_member_use
                    DView.spaceHeight(8),
                    IconButton.filledTonal(
                      onPressed: () {
                        refresh();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                );
              }
              if (state is HourlyForecastLoaded) {
                final list = state.data;
                return GroupedListView<WeatherEntity, String>(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  elements: list,
                  groupBy: (element) => 
                      DateFormat('yyyy-MM-dd').format(element.dateTime),
                  groupHeaderBuilder: (element) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 16,
                        ),
                        child: Text(
                          DateFormat('EEE, d MMM yyyy').format(element.dateTime),
                        ),
                      ),
                    );
                  },
                  //  stickyHeaderBackgroundColor: ,
                  // itemComparator: (item1, item2) => 
                  //   item1['name'].compareTo(item2['name']), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, // optional

                  itemBuilder: (context, weather) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          ExtendedImage.network(
                            URLs.weatherIcon(weather.icon),
                            height: 80,
                            width: 80,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(weather.dateTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  weather.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(weather.temperature-273.15).round()}\u2103',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  
                //   itemBuilder: (context, weather) => ListTile(
                //     title: Text(
                //       DateFormat('HH:mm').format(weather.dateTime),
                //       style: const TextStyle(
                //         fontSize: 16,
                //         color: Colors.white,

                //       ),
                //     ),
                    // trailing: Text(
                    //   '${(weather.temperature-273.15).round()}\u2103',
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                //   ),
               );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}