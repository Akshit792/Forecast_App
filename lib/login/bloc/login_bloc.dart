import 'dart:convert';
import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/login/bloc/login_event.dart';
import 'package:a2d_forecast_app/login/bloc/login_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool isDataValid = false;
  bool isLoading = false;
  bool? isEmailAddressValid;
  Map<String, dynamic> savedLoginCredentails = {};
  final storage = const FlutterSecureStorage();
  List<CityDetailsModel> cityList = [];

  LoginBloc() : super(InitialLoginState()) {
    on<ValidatorLoginEvent>((event, emit) {
      try {
        _validateUserData(event.loginCredentials, event.validateType);

        emit(ValidateLoginState());
      } catch (e, s) {
        Logger().e('$e Validator Login State $s');
      }
    });
    on<UserLoginEvent>((event, emit) async {
      try {
        isLoading = true;
        var forecastRepository =
            RepositoryProvider.of<ForecastRepository>(event.context);

        emit(ValidateLoginState());

        var response = await forecastRepository.loginUser(
            loginCredentials: event.loginCredentials);

        if (response is Map) {
          bool isResponseValid = response.containsKey('msg') &&
              response['msg'] == 'login successfull';

          if (isResponseValid) {
            await storage.write(key: 'auth_data', value: jsonEncode(response));

            if (event.rememberMe) {
              add(RememberMeLoginEvent(
                saveOrRetrieveOrDelete: 'save',
                context: event.context,
                loginCredentials: UserDetailsModel(
                  emailAddress: event.loginCredentials.emailAddress,
                  password: event.loginCredentials.password,
                ),
                rememberMe: event.rememberMe,
              ));
            } else {
              add(RememberMeLoginEvent(
                  saveOrRetrieveOrDelete: 'delete', context: event.context));
            }

            isLoading = false;

            cityList = await forecastRepository.fetchCityList();

            // ignore: use_build_context_synchronously
            BlocProvider.of<NavigatorBloc>(event.context)
                .add(NavigateToForecastScreen(
              weatherData: WeatherData.fromJson(response["liveWeather"]),
              cityList: cityList,
            ));
          }
        }
      } on NetworkException catch (e) {
        isLoading = false;
        var errorResponse = jsonDecode(e.responseBody)['msg'];
        emit(ErrorLoginState(errorMessage: errorResponse));
      } catch (e, s) {
        Logger().e('$e User Login State $s');
      }
    });

    on<RememberMeLoginEvent>((event, emit) async {
      try {
        // Save data in the local storage
        if (event.saveOrRetrieveOrDelete == 'save') {
          await storage.write(
              key: 'login_credentials',
              value: jsonEncode({
                'email': event.loginCredentials!.emailAddress,
                'password': event.loginCredentials!.password,
                'remember_me': event.rememberMe,
              }));
        }
        // Retrieve data from the local storage
        if (event.saveOrRetrieveOrDelete == 'retrieve') {
          var response = await storage.read(key: 'login_credentials');
          if (response != null) {
            savedLoginCredentails = jsonDecode(response);
          }
          emit(CheckDataLoginState());
        }
        // Delete data from the local storage
        if (event.saveOrRetrieveOrDelete == 'delete') {
          await storage.delete(key: 'login_credentials');
        }
      } catch (e, s) {
        Logger().e('$e Remember Me Login Event $s');
      }
    });
  }

  void _validateUserData(
      UserDetailsModel userDetails, SignUpValidator validateType) {
    if (validateType == SignUpValidator.emailAddress) {
      isEmailAddressValid = (userDetails.emailAddress != null &&
          userDetails.emailAddress!.isNotEmpty &&
          RegExp(Constants.emailRegExp).hasMatch(userDetails.emailAddress!));
    }

    if (isEmailAddressValid != null) {
      isDataValid = isEmailAddressValid! &&
          (userDetails.password != null && userDetails.password!.isNotEmpty);
    } else {
      isDataValid = false;
    }
  }
}
