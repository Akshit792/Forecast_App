// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'country_details_model.g.dart';

@JsonSerializable()
class CountryDetailsModel {
  @JsonKey(name: 'country')
  final String countryName;
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'iso')
  final String regionCode;

  CountryDetailsModel(
      {required this.countryName,
      required this.code,
      required this.regionCode});

  factory CountryDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CountryDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDetailsModelToJson(this);
}
