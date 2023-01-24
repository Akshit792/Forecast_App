import 'dart:convert';

import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:a2d_forecast_app/signup/bloc/signup_event.dart';
import 'package:a2d_forecast_app/signup/bloc/signup_state.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  bool isDataValid = false;
  bool isLoading = false;
  bool? isUserNameValid,
      isEmailAddressValid,
      isCountryNameValid = true,
      isPasswordValid,
      isPhoneNumberValid;

  SignUpBloc() : super(InitialSignUpState()) {
    on<ValidatorSignUpEvent>((event, emit) async {
      try {
        _validateUserData(event.userDetails, event.validateType);
        emit(ValidateSignUpState());
      } catch (e, s) {
        Logger().e('$e Validator Sign Up Event $s');
      }
    });
    on<UserSignUpEvent>((event, emit) async {
      try {
        isLoading = true;
        var forecastRepository =
            RepositoryProvider.of<ForecastRepository>(event.context);

        emit(ValidateSignUpState());
        UserDetailsModel? registeredUserDetails;

        registeredUserDetails =
            await forecastRepository.signUpUser(userDetail: event.userDetails);

        if (registeredUserDetails!.id != null) {
          isLoading = false;
          // ignore: use_build_context_synchronously
          BlocProvider.of<NavigatorBloc>(event.context)
              .add(NavigateToSignUpSuccessFullScreen());
        }
        emit(ValidateSignUpState());
      } on NetworkException catch (e) {
        isLoading = false;
        var errorResponse = jsonDecode(e.responseBody)['message'];
        emit(ErrorSignUpState(errorMessage: errorResponse));
      } catch (e, s) {
        Logger().e('$e User Sign Up Event $s');
      }
    });
  }

  void _validateUserData(
      UserDetailsModel userDetails, SignUpValidator validateType) {
    // User name
    if (validateType == SignUpValidator.name) {
      isUserNameValid =
          (userDetails.name != null && userDetails.name!.isNotEmpty);
    }
    // Email address
    else if (validateType == SignUpValidator.emailAddress) {
      isEmailAddressValid = (userDetails.emailAddress != null &&
          userDetails.emailAddress!.isNotEmpty &&
          RegExp(Constants.emailRegExp).hasMatch(userDetails.emailAddress!));
    }
    // Country
    else if (validateType == SignUpValidator.country) {
      isCountryNameValid =
          (userDetails.country != null && userDetails.country!.isNotEmpty);
    }
    // Phone Number
    else if (validateType == SignUpValidator.phoneNumber) {
      isPhoneNumberValid = (userDetails.phone != null &&
          userDetails.phone!.isNotEmpty &&
          RegExp(Constants.phoneRegExp).hasMatch(userDetails.phone!));
    }
    // Password
    else if (validateType == SignUpValidator.password) {
      isPasswordValid = (userDetails.password != null &&
          userDetails.password!.isNotEmpty &&
          RegExp(Constants.passwordRegExp).hasMatch(userDetails.password!));
    }

    if (isUserNameValid != null &&
        isCountryNameValid != null &&
        isEmailAddressValid != null &&
        isPhoneNumberValid != null &&
        isPasswordValid != null) {
      isDataValid = (isUserNameValid! &&
          isEmailAddressValid! &&
          isCountryNameValid! &&
          isPhoneNumberValid! &&
          isPasswordValid!);
    } else {
      isDataValid = false;
    }
  }
}
