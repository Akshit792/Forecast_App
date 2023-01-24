import 'dart:convert';

import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/splash/bloc/splash_event.dart';
import 'package:a2d_forecast_app/splash/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  WeatherData? liveWeather;
  List<CityDetailsModel> cityList = [];

  SplashBloc() : super(InitialSplashState()) {
    on<CheckUserLogedInStatusAccountsEvent>((event, emit) async {
      try {
        emit(LoadingSplashState());
        const storage = FlutterSecureStorage();
        var response = await storage.read(key: 'auth_data');
        if (response != null) {
          Map<String, dynamic> authData = jsonDecode(response);

          liveWeather = WeatherData.fromJson(authData["liveWeather"]);
          cityList =
              // ignore: use_build_context_synchronously
              await RepositoryProvider.of<ForecastRepository>(event.context)
                  .fetchCityList();
          emit(UserIsLogedInSplashState());
        } else {
          emit(UserNotLogedInSplashState());
        }
      } on NetworkException catch (e) {
        emit(ErrorSplashState());
      } catch (e, s) {
        Logger().e('$e Check user logged in state $s');
      }
    });
  }
}
