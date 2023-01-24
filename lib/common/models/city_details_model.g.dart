// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityDetailsModel _$CityDetailsModelFromJson(Map<String, dynamic> json) =>
    CityDetailsModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      maxTemperature: json['maxTemperature'] as int?,
      minTemperature: json['minTemperature'] as int?,
    );

Map<String, dynamic> _$CityDetailsModelToJson(CityDetailsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'state': instance.state,
      'country': instance.country,
      'maxTemperature': instance.maxTemperature,
      'minTemperature': instance.minTemperature,
    };
