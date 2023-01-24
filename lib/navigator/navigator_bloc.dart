import 'package:a2d_forecast_app/forecast/bloc/forecast_bloc.dart';
import 'package:a2d_forecast_app/forecast/forecast_screen.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_bloc.dart';
import 'package:a2d_forecast_app/forecast_details/forecast_details_screen.dart';
import 'package:a2d_forecast_app/login/bloc/login_bloc.dart';
import 'package:a2d_forecast_app/login/login_screen.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:a2d_forecast_app/navigator/navigator_state.dart';
import 'package:a2d_forecast_app/onboarding/onboarding_screen.dart';
import 'package:a2d_forecast_app/signup/bloc/singnup_bloc.dart';
import 'package:a2d_forecast_app/signup/signup_screen.dart';
import 'package:a2d_forecast_app/signup/signup_successfull_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorStates> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({required this.navigatorKey}) : super(InitialNavigatorState()) {
    on<NavigateToSignUpScreen>((event, emit) async {
      await _navigatePushReplacemnet(BlocProvider(
        create: (context) => SignUpBloc(),
        child: const SignUpScreen(),
      ));
    });
    on<NavigateToLoginScreen>((event, emit) async {
      await _navigatePushReplacemnet(BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginScreen(),
      ));
    });
    on<NavigateToForecastScreen>((event, emit) async {
      await _navigatePushReplacemnet(BlocProvider(
        create: (context) => ForecastBloc(
            liveWeather: event.weatherData, cityList: event.cityList),
        child: const ForecastScreen(),
      ));
    });
    on<NavigateToOnBoardingScreen>((event, emit) async {
      await _navigatePushReplacemnet(const OnBoardingScreen());
    });
    on<NavigateToSignUpSuccessFullScreen>((event, emit) {
      _navigatePushReplacemnet(BlocProvider(
        create: (context) => SignUpBloc(),
        child: const SignUpSuccessfullScreen(),
      ));
    });
    on<NavigatorActionPop>((event, emit) {
      _navigatePop();
    });
    on<NavigateToForecastDetailsScreen>((event, emit) async {
      await _navigatePush(BlocProvider(
        create: (context) => ForecastDetailsBloc(
          cityId: event.cityId,
          liveWeather: event.liveWeatherData,
        ),
        child: const ForecastDetailsScreen(),
      ));
    });
  }

  _navigatePush(Widget widget) async {
    await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  _navigatePushReplacemnet(Widget widget) async {
    await navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ), (route) => false);
  }

  _navigatePop() async {
    navigatorKey.currentState!.pop();
  }
}
