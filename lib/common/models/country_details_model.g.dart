// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryDetailsModel _$CountryDetailsModelFromJson(Map<String, dynamic> json) =>
    CountryDetailsModel(
      countryName: json['country'] as String,
      code: json['code'] as String,
      regionCode: json['iso'] as String,
    );

Map<String, dynamic> _$CountryDetailsModelToJson(
        CountryDetailsModel instance) =>
    <String, dynamic>{
      'country': instance.countryName,
      'code': instance.code,
      'iso': instance.regionCode,
    };
