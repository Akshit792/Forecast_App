import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/forecast/bloc/forecast_event.dart';
import 'package:a2d_forecast_app/forecast/bloc/forecast_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  WeatherData? liveWeather;
  List<CityDetailsModel> cityList;

  ForecastBloc({required this.liveWeather, required this.cityList})
      : super(InitialForecastState()) {
    on<FetchLiveWeatherForecastEvent>((event, emit) async {
      try {
        var forecastRepository =
            RepositoryProvider.of<ForecastRepository>(event.context);

        liveWeather =
            await forecastRepository.getLiveWeather(cityId: event.cityId);

        emit(LoadedForecastState());
      } on NetworkException catch (e) {
        emit(ErrorLiveWeatherState());
      } catch (e, s) {
        emit(ErrorLiveWeatherState());
        Logger().e('$e Fetch Live Weather Forecast Event $s');
      }
    });
    on<LogoutForecastEvent>((event, emit) async {
      try {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'auth_data');
        var response = await storage.read(key: 'auth_data');
        if (response == null) {
          // ignore: use_build_context_synchronously
          BlocProvider.of<NavigatorBloc>(event.context)
              .add(NavigatorActionPop());
          // ignore: use_build_context_synchronously
          BlocProvider.of<NavigatorBloc>(event.context)
              .add(NavigateToLoginScreen());
        }
      } catch (e, s) {
        Logger().e('$e Logout Forecast Event $s');
      }
    });
  }
}
