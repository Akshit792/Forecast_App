// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'user_details_model.g.dart';

@JsonSerializable()
class UserDetailsModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'email')
  String? emailAddress;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'password')
  String? password;
  @JsonKey(name: 'country')
  String? country;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  UserDetailsModel({
    this.name,
    this.emailAddress,
    this.phone,
    this.password,
    this.country,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsModelToJson(this);
}
