import 'package:a2d_forecast_app/common/models/city_details_model.dart';
import 'package:a2d_forecast_app/common/models/weather_model.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';

class ForecastRepository {
  final ApiClient forecastApiClient;

  Future<UserDetailsModel?> signUpUser(
      {required UserDetailsModel userDetail}) async {
    UserDetailsModel? userDetails;
    var response = await forecastApiClient.createResource('create-user', {
      "name": userDetail.name,
      "email": userDetail.emailAddress,
      "phone": userDetail.phone!.split('-')[1].trim(),
      "password": userDetail.password,
      "country": userDetail.country,
    });
    if (response.containsKey('status') &&
        response['status'] == true &&
        response.containsKey('msg') &&
        response['msg'] == 'profile created') {
      userDetails = UserDetailsModel.fromJson(response['DATA']);
    }

    return userDetails;
  }

  Future<dynamic> loginUser(
      {required UserDetailsModel loginCredentials}) async {
    var response = await forecastApiClient.createResource('login', {
      "email": loginCredentials.emailAddress,
      "password": loginCredentials.password,
    });
    return response;
  }

  Future<WeatherData> getLiveWeather({required String cityId}) async {
    var response = await forecastApiClient.getResource(
      'live-weather/$cityId',
    );

    return WeatherData.fromJson(response["data"]);
  }

  Future<List<CityDetailsModel>> fetchCityList() async {
    List<CityDetailsModel> cityList = [];
    for (int page = 1; page < 20000; page++) {
      var response = await forecastApiClient.getResource('city-list',
          queryParams: {'page': '$page', 'limit': '5'});

      if (response.containsKey('list') && response['list'].length > 0) {
        response['list'].forEach((cityDetails) {
          cityList.add(CityDetailsModel.fromJson(cityDetails));
        });
      } else {
        break;
      }
    }
    return cityList;
  }

  Future<List<WeatherData>> fetchSmallForecast({required String cityId}) async {
    List<WeatherData> weatherData = [];
    var response =
        await forecastApiClient.getResource('view-small-forecast/$cityId');
    if (response.containsKey('DATA') && response['DATA'].length > 0) {
      for (var forecastData in response['DATA']) {
        weatherData.add(WeatherData.fromJson(forecastData));
      }
    }
    return weatherData;
  }

  Future<Map<String, dynamic>> fetchOtherForecast(
      {required String cityId}) async {
    var response =
        await forecastApiClient.getResource('view-other-forecast/$cityId');

    return response['DATA'];
  }

  ForecastRepository({required this.forecastApiClient});
}
