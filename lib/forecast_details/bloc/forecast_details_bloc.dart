import 'dart:convert';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_event.dart';
import 'package:a2d_forecast_app/forecast_details/bloc/forecast_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ForecastDetailsBloc
    extends Bloc<ForecastDetailsEvent, ForecastDetailsState> {
  String cityId;
  WeatherData liveWeather;
  List<WeatherData> smallForecastList = [];
  Map<String, dynamic> otherForecastList = {};

  ForecastDetailsBloc({required this.cityId, required this.liveWeather})
      : super(InitialForecastDetailsState()) {
    on<FetchForecastDetailsEvent>((event, emit) async {
      try {
        emit(LoadingForecastState());
        var forecastRepository =
            RepositoryProvider.of<ForecastRepository>(event.context);

        smallForecastList =
            await forecastRepository.fetchSmallForecast(cityId: cityId);
        otherForecastList =
            await forecastRepository.fetchOtherForecast(cityId: cityId);

        emit(LoadedForecastState());
      } on NetworkException catch (e) {
        var errorMessage = jsonDecode(e.responseBody);
        emit(ErroForecastDetailsState(errorMessage: errorMessage['msg']));
      } catch (e, s) {
        Logger().e('$e Fetch Forecast Details Event $s');
      }
    });
  }
}
