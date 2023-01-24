import 'package:flutter/material.dart';

abstract class SplashEvent {}

class CheckUserLogedInStatusAccountsEvent extends SplashEvent {
  final BuildContext context;

  CheckUserLogedInStatusAccountsEvent({required this.context});
}
