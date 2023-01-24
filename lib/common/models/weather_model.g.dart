// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      temperature: json['temperature'] as int?,
      maxTemperature: json['maxTemperature'] as int?,
      minTemperature: json['minTemperature'] as int?,
      condition: json['condition'] as String?,
      windSpeed: json['windSpeed'] as int?,
      humidity: json['humidity'] as int?,
      cityId: json['cityId'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'maxTemperature': instance.maxTemperature,
      'minTemperature': instance.minTemperature,
      'condition': instance.condition,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
      'cityId': instance.cityId,
      'date': instance.date,
      'time': instance.time,
    };
