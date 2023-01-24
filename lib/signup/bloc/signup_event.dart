import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent {}

class ValidatorSignUpEvent extends SignUpEvent {
  final UserDetailsModel userDetails;
  final SignUpValidator validateType;

  ValidatorSignUpEvent({
    required this.userDetails,
    required this.validateType,
  });
}

class UserSignUpEvent extends SignUpEvent {
  final BuildContext context;
  final UserDetailsModel userDetails;

  UserSignUpEvent({
    required this.userDetails,
    required this.context,
  });
}
