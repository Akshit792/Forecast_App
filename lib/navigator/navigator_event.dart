import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:flutter/material.dart';

abstract class NavigatorEvent {}

class NavigateToSignUpScreen extends NavigatorEvent {}

class NavigateToLoginScreen extends NavigatorEvent {}

class NavigateToForecastScreen extends NavigatorEvent {
  final WeatherData weatherData;
  final List<CityDetailsModel> cityList;

  NavigateToForecastScreen({required this.weatherData, required this.cityList});
}

class NavigateToOnBoardingScreen extends NavigatorEvent {}

class NavigateToSignUpSuccessFullScreen extends NavigatorEvent {}

class NavigatorActionPop extends NavigatorEvent {}

class NavigateToForecastDetailsScreen extends NavigatorEvent {
  final String cityId;
  final WeatherData liveWeatherData;

  NavigateToForecastDetailsScreen(
      {required this.cityId, required this.liveWeatherData});
}
