import 'package:flutter/material.dart';

abstract class ForecastDetailsEvent {}

class FetchForecastDetailsEvent extends ForecastDetailsEvent {
  final BuildContext context;

  FetchForecastDetailsEvent({required this.context});
}
