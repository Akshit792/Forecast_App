import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_bloc.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_event.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ForecastDetailsScreen extends StatefulWidget {
  const ForecastDetailsScreen({super.key});

  @override
  State<ForecastDetailsScreen> createState() => _ForecastDetailsScreenState();
}

class _ForecastDetailsScreenState extends State<ForecastDetailsScreen> {
  List<WeatherData> smallForecastList = [];
  Map<String, dynamic> otherForecastList = {};
  WeatherData? liveWeatherData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastDetailsBloc, ForecastDetailsState>(
      builder: (context, state) {
        var forecastDetailsBloc = BlocProvider.of<ForecastDetailsBloc>(context);
        if (state is InitialForecastDetailsState) {
          forecastDetailsBloc.add(FetchForecastDetailsEvent(context: context));
        }
        if (state is LoadedForecastState) {
          smallForecastList = forecastDetailsBloc.smallForecastList;
          otherForecastList = forecastDetailsBloc.otherForecastList;
          liveWeatherData = forecastDetailsBloc.liveWeather;
        }
        return Scaffold(
          body: Stack(
            children: [
              // Gradient background
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(71, 191, 223, 1),
                    Color.fromRGBO(74, 145, 255, 1)
                  ],
                )),
              ),
              // background ui elements
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'asset/images/forecast_screen_background.png',
                        ))),
              ),
              state is LoadedForecastState
                  ? _buildForecastScreen()
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          )),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForecastScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // back button
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 0),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                },
                child: Row(
                  children: const [
                    SizedBox(
                      width: 25,
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Colors.white,
                    ),
                    Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            // current date
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    '${DateFormat('MMM').format(DateTime(int.parse(liveWeatherData!.date!.split('/')[2]), int.parse(liveWeatherData!.date!.split('/')[1]), int.parse(liveWeatherData!.date!.split('/')[0]))).toString()}, ${int.parse(liveWeatherData!.date!.split('/')[0])}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            // small forecasts
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: smallForecastList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: smallForecastList[index]
                                      .condition!
                                      .toLowerCase() ==
                                  'partly cloudy'
                              ? 8
                              : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            index == 2 ? Border.all(color: Colors.white) : null,
                        color: index == 2
                            ? const Color.fromRGBO(255, 255, 255, 0.2)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${smallForecastList[index].temperature}°C',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: smallForecastList[index]
                                        .condition!
                                        .toLowerCase() ==
                                    'partly cloudy'
                                ? 30
                                : 20,
                          ),
                          Image(
                              height: smallForecastList[index]
                                          .condition!
                                          .toLowerCase() ==
                                      'partly cloudy'
                                  ? 45
                                  : 50,
                              image: AssetImage(Constants.weatherImagesMap[
                                  smallForecastList[index]
                                      .condition!
                                      .toLowerCase()])),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${smallForecastList[index].time}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            // Other forecast title bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Next Forecast',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  ImageIcon(
                    AssetImage('asset/images/calender.png'),
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            _buildNextForecasts(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextForecasts() {
    List<dynamic> dataList = [];
    for (var data in otherForecastList.values.toList()) {
      if (data is Map) {
        dataList.add(data);
      }
    }
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          String date =
              '${DateFormat('MMM').format(DateTime(int.parse(liveWeatherData!.date!.split('/')[2]), int.parse(liveWeatherData!.date!.split('/')[1]), int.parse(liveWeatherData!.date!.split('/')[0]))).toString()}, ${int.parse(liveWeatherData!.date!.split('/')[0]) + index + 1}';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                // date of the forecast
                Text(
                  date,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                // temperature condition image
                Expanded(
                    child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Image(
                      image: AssetImage(Constants.weatherImagesMap[
                          dataList[index]['condition'].toLowerCase()])),
                )),
                // temperature value
                Text(
                  '${dataList[index]['temperature']}°',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                const SizedBox(
                  width: 25,
                ),
              ],
            ),
          );
        });
  }

  String getFormattedDate({required S}) {
    return '';
  }
}
