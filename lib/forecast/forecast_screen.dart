import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/forecast/bloc/forecast_bloc.dart';
import 'package:a2d_forecast_app/forecast/bloc/forecast_event.dart';
import 'package:a2d_forecast_app/forecast/bloc/forecast_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  WeatherData? liveWeather;
  String? cityId;
  CityDetailsModel? currentCity;
  List<CityDetailsModel> cityList = [];
  bool isSearchDialogActive = false;

  @override
  void didChangeDependencies() {
    _updateData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is InitialForecastState || state is LoadedForecastState) {
          if (state is InitialForecastState) {
            _fetchLiveWeather();
          }
          _updateData();
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
                _buildWeatherDetails(),
                // blur background
                if (isSearchDialogActive)
                  InkWell(
                    onTap: () {
                      isSearchDialogActive = !isSearchDialogActive;
                      setState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      color: const Color.fromRGBO(0, 0, 0, 0.35),
                    ),
                  ),
                _buildWeatherAppBar(),
              ],
            ),
          );
        }
        // error state
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            'An error occured..',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // weather type image
          Container(
            height: liveWeather!.condition!.toLowerCase() == 'partly_cloudy'
                ? 150
                : 160,
            margin: EdgeInsets.only(
                top: liveWeather!.condition!.toLowerCase() == 'partly_cloudy'
                    ? 100
                    : 70,
                bottom: liveWeather!.condition!.toLowerCase() == 'rainy'
                    ? 20
                    : liveWeather!.condition!.toLowerCase() == 'thunder'
                        ? 10
                        : 0),
            child: Image.asset(
                '${Constants.weatherImagesMap[liveWeather!.condition!.toLowerCase()]}',
                fit: BoxFit.contain),
          ),
          // Weather details widget
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              color: const Color.fromRGBO(255, 255, 255, 0.3),
            ),
            child: Column(
              children: [
                // Date
                if (liveWeather!.date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      getDate(liveWeather!.date!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                // Temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildElevatedText(
                        text: '${liveWeather!.temperature}', fontSize: 100),
                    _buildElevatedText(text: '°', fontSize: 80),
                  ],
                ),
                // Weather condition
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                    '${liveWeather!.condition}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
                // All weather details
                _buildWeatherTile(
                    DateFormat('hh:mm a').format(DateTime.now()), 'Time'),
                _buildWeatherTile(liveWeather!.temperature, 'Temperature'),
                _buildWeatherTile(
                    liveWeather!.maxTemperature, 'MaxTemperature'),
                _buildWeatherTile(
                    liveWeather!.minTemperature, 'MinTemperature'),
                _buildWeatherTile(liveWeather!.condition, 'Condition'),
                _buildWeatherTile(liveWeather!.windSpeed, 'WindSpeed'),
                _buildWeatherTile(liveWeather!.humidity, 'Humidity'),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          // Forecast report button
          InkWell(
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                  NavigateToForecastDetailsScreen(
                      cityId: cityId!, liveWeatherData: liveWeather!));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              margin: const EdgeInsets.symmetric(vertical: 40),
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Forecast report',
                    style: TextStyle(fontFamily: 'Overpass', fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAppBar() {
    List<CityDetailsModel> searchCityList = cityList;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            // App bar
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Map pin image
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Image(
                    height: 24,
                    image: AssetImage('asset/images/map.png'),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                // Select city button
                InkWell(
                  onTap: () {
                    isSearchDialogActive = !isSearchDialogActive;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${currentCity!.name}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                // Logout button
                IconButton(
                  onPressed: () {
                    _buildLogOutAlertDialog(context);
                  },
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Color.fromRGBO(255, 109, 109, 1),
                  ),
                ),
              ],
            ),
            // Search dialog
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSearchDialogActive ? double.maxFinite : 0,
              height: isSearchDialogActive ? 400 : 0,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                child: StatefulBuilder(builder: (context, changeState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // City search bar
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(
                              left: 12, top: 15, right: 12, bottom: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            onChanged: (searchQuery) {
                              searchCityList = _searchCity(searchQuery);
                              changeState(() {});
                            },
                            decoration: InputDecoration(
                              prefixIcon: InkWell(
                                onTap: () {
                                  isSearchDialogActive = false;
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color.fromRGBO(68, 78, 114, 1),
                                  size: 25,
                                ),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.mic,
                                  color: Color.fromRGBO(68, 78, 114, 1),
                                  size: 30,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24, top: 15, bottom: 15),
                              hintText: 'Search here',
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(68, 78, 114, 1),
                                fontSize: 17,
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // All cities list
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchCityList.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                cityId = searchCityList[index].id;
                                isSearchDialogActive = false;

                                _fetchLiveWeather();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const ImageIcon(
                                      AssetImage('asset/images/map.png'),
                                      color: Color.fromRGBO(68, 78, 114, 1),
                                      size: 25,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${searchCityList[index].name}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(68, 78, 114, 1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    (searchCityList[index].maxTemperature ==
                                                null ||
                                            searchCityList[index]
                                                    .minTemperature ==
                                                null)
                                        ? const SizedBox(
                                            width: 0,
                                          )
                                        : Text(
                                            '${searchCityList[index].maxTemperature}/${searchCityList[index].minTemperature}'),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildLogOutAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Material(
            color: Colors.transparent,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Turn off icon
                      Container(
                          height: 120,
                          width: 120,
                          margin: const EdgeInsets.only(top: 25, bottom: 20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 214, 214, 1),
                          ),
                          child: const ImageIcon(
                            AssetImage('asset/images/Turn off.png'),
                            color: Color.fromRGBO(255, 109, 109, 1),
                          )),
                      const Text(
                        'Log out',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Are you sure you want to logout from app',
                          style: TextStyle(
                              color: Color.fromRGBO(107, 106, 113, 1)),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // logout button
                          InkWell(
                            onTap: () {
                              BlocProvider.of<ForecastBloc>(context)
                                  .add(LogoutForecastEvent(context: context));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.07,
                                  vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 109, 109, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          // Cancel button
                          InkWell(
                            onTap: () {
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigatorActionPop());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.07,
                                  vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(241, 239, 239, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildElevatedText({required String text, required double fontSize}) {
    return Stack(
      children: [
        // Drop shadow
        Text(
          text,
          style: TextStyle(
              color: Colors.transparent,
              fontSize: fontSize,
              fontFamily: 'Overpass',
              shadows: const [
                BoxShadow(
                    offset: Offset(-4, 8),
                    blurRadius: 50,
                    spreadRadius: 4,
                    color: Color.fromRGBO(0, 0, 0, 0.4))
              ]),
        ),
        // Text
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontFamily: 'Overpass',
          ),
        ),
        // Inner shadow
        Text(
          text,
          style: TextStyle(
              color: Colors.transparent,
              fontSize: fontSize,
              fontFamily: 'Overpass',
              shadows: const [
                Shadow(
                  offset: Offset(-4, 4),
                  blurRadius: 4,
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                )
              ]),
        ),
      ],
    );
  }

  Widget _buildWeatherTile(dynamic weatherData, String weatherType) {
    // Check the weatherData unit
    String unit = weatherType == 'Condition' || weatherType == 'Time'
        ? ''
        : weatherType == 'Humidity'
            ? ' %'
            : weatherType == 'WindSpeed'
                ? ' Km/h'
                : '°C';

    if (weatherData != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Image
            const Image(
                height: 22, image: AssetImage('asset/images/humidity.png')),
            const SizedBox(
              width: 20,
            ),
            // Weather detail type
            Text(
              weatherType,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Weather detail unit
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$weatherData$unit',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  List<CityDetailsModel> _searchCity(String searchQuery) {
    List<CityDetailsModel> filteredResults = [];
    for (CityDetailsModel cityDetails in cityList) {
      if (cityDetails.name!.toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredResults.add(cityDetails);
      }
    }
    return filteredResults;
  }

  void _fetchLiveWeather() {
    BlocProvider.of<ForecastBloc>(context)
        .add(FetchLiveWeatherForecastEvent(context: context, cityId: cityId!));
  }

  void _updateData() {
    var forecastBloc = BlocProvider.of<ForecastBloc>(context);
    liveWeather = forecastBloc.liveWeather;
    cityId = liveWeather!.cityId;
    cityList = forecastBloc.cityList;
    currentCity = cityList
        .firstWhere((cityDetails) => cityDetails.id == liveWeather!.cityId);
  }

  String getDate(String date) {
    String formattedDate = '';
    formattedDate =
        '${int.parse(date.split('/')[0])} ${DateFormat('MMMM').format(DateTime(int.parse(date.split('/')[2]), int.parse(date.split('/')[1]), int.parse(date.split('/')[0]))).toString()}';

    return formattedDate;
  }
}
