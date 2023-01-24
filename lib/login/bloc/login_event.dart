import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent {}

class ValidatorLoginEvent extends LoginEvent {
  final UserDetailsModel loginCredentials;
  final SignUpValidator validateType;

  ValidatorLoginEvent({
    required this.loginCredentials,
    required this.validateType,
  });
}

class UserLoginEvent extends LoginEvent {
  final UserDetailsModel loginCredentials;
  final BuildContext context;
  final bool rememberMe;

  UserLoginEvent({
    required this.context,
    required this.loginCredentials,
    required this.rememberMe,
  });
}

class RememberMeLoginEvent extends LoginEvent {
  final BuildContext context;
  final String saveOrRetrieveOrDelete;
  final UserDetailsModel? loginCredentials;
  final bool? rememberMe;

  RememberMeLoginEvent({
    required this.saveOrRetrieveOrDelete,
    required this.context,
    this.rememberMe,
    this.loginCredentials,
  });
}
