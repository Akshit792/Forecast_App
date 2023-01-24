import 'package:flutter/material.dart';

abstract class ForecastDetailsState {}

class InitialForecastDetailsState extends ForecastDetailsState {}

class LoadingForecastState extends ForecastDetailsState {}

class LoadedForecastState extends ForecastDetailsState {}

class ErroForecastDetailsState extends ForecastDetailsState {
  final String? errorMessage;

  ErroForecastDetailsState({this.errorMessage});
}
