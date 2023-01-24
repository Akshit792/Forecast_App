import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherData {
  final int? temperature;
  final int? maxTemperature;
  final int? minTemperature;
  final String? condition;
  final int? windSpeed;
  final int? humidity;
  final String? cityId;
  final String? date;
  final String? time;

  WeatherData({
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.cityId,
    required this.date,
    required this.time,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
