// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'city_details_model.g.dart';

@JsonSerializable()
class CityDetailsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? state;
  final String? country;
  final int? maxTemperature;
  final int? minTemperature;

  CityDetailsModel({
    this.id,
    this.name,
    this.state,
    this.country,
    this.maxTemperature,
    this.minTemperature,
  });

  factory CityDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CityDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityDetailsModelToJson(this);
}
