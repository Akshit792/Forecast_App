import 'package:flutter/material.dart';

abstract class ForecastEvent {}

class FetchLiveWeatherForecastEvent extends ForecastEvent {
  final BuildContext context;
  final String cityId;

  FetchLiveWeatherForecastEvent({required this.context, required this.cityId});
}

class LogoutForecastEvent extends ForecastEvent {
  final BuildContext context;

  LogoutForecastEvent({required this.context});
}
