import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/country_details_model.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:a2d_forecast_app/common/widgets/custom_textfield.dart';
import 'package:a2d_forecast_app/common/widgets/gradient_text.dart';
import 'package:a2d_forecast_app/common/widgets/validator_text.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:a2d_forecast_app/signup/bloc/signup_event.dart';
import 'package:a2d_forecast_app/signup/bloc/signup_state.dart';
import 'package:a2d_forecast_app/signup/bloc/singnup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserDetailsModel userDetails = UserDetailsModel();
  List<CountryDetailsModel> countryDetails = [];
  bool obscureText = true;
  bool isDataValid = false;

  @override
  void initState() {
    countryDetails = getCountryDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          current is ValidateSignUpState || current is ErrorSignUpState,
      builder: (context, state) {
        if (state is InitialSignUpState) {
          CountryDetailsModel defaultCountry = countryDetails.firstWhere(
              (countryDetails) => countryDetails.countryName == 'India');
          userDetails.phone = '+${defaultCountry.code}-';
          userDetails.country = defaultCountry.countryName;
        }

        var signUpBloc = BlocProvider.of<SignUpBloc>(context);
        isDataValid = BlocProvider.of<SignUpBloc>(context).isDataValid;

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // Company logo
                  Container(
                    height: 85,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 70, bottom: 10),
                    child: const Image(
                        image: AssetImage('asset/images/A2d_logo.png')),
                  ),
                  const Text(
                    'Enter the email address and password',
                    style: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Error Message
                  (state is ErrorSignUpState)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 22.5),
                          child: Text(
                            state.errorMessage,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : const SizedBox(
                          height: 45,
                        ),
                  // User name
                  CustomTextField(
                    hintText: 'Full Name',
                    textInputType: TextInputType.text,
                    text: userDetails.name ?? '',
                    onChanged: (name) {
                      userDetails.name = name;
                      _validateForm(SignUpValidator.name);
                    },
                  ),
                  // User name validator
                  (signUpBloc.isUserNameValid != null &&
                          !signUpBloc.isUserNameValid!)
                      ? const ValidatorText(
                          text: 'Please enter a valid user name')
                      : const SizedBox(
                          height: 25,
                        ),
                  // Phone number
                  CustomTextField(
                    hintText: 'Phone Number',
                    textInputType: TextInputType.phone,
                    text: userDetails.phone ?? '',
                    onChanged: (phoneNumber) {
                      userDetails.phone = phoneNumber;
                      _validateForm(SignUpValidator.phoneNumber);
                    },
                  ),
                  // Phone number validator
                  (signUpBloc.isPhoneNumberValid != null &&
                          !signUpBloc.isPhoneNumberValid!)
                      ? const ValidatorText(
                          text: 'Please enter a valid phone number.')
                      : const SizedBox(
                          height: 25,
                        ),
                  // country name
                  CustomTextField(
                    hintText: 'Country',
                    textInputType: TextInputType.phone,
                    text: userDetails.country ?? '',
                    gestureDetector: () {
                      showSelectCountryModelBottomSheet();
                    },
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(128, 128, 128, 1),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Email address
                  CustomTextField(
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    text: userDetails.emailAddress ?? '',
                    onChanged: (emailAddress) {
                      userDetails.emailAddress = emailAddress;
                      _validateForm(SignUpValidator.emailAddress);
                    },
                  ),
                  // Email address validator
                  (signUpBloc.isEmailAddressValid != null &&
                          !signUpBloc.isEmailAddressValid!)
                      ? const ValidatorText(
                          text: 'Please enter a valid email address')
                      : const SizedBox(
                          height: 25,
                        ),
                  // Password
                  CustomTextField(
                    hintText: 'Password',
                    textInputType: TextInputType.text,
                    text: userDetails.password ?? '',
                    obscureText: obscureText,
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: obscureText
                          ? const Color.fromRGBO(128, 128, 128, 1)
                          : const Color.fromRGBO(71, 191, 223, 1),
                    ),
                    onChanged: (password) {
                      userDetails.password = password;
                      _validateForm(SignUpValidator.password);
                    },
                    onTap: () {
                      obscureText = !obscureText;
                      setState(() {});
                    },
                  ),
                  // Password validator
                  (signUpBloc.isPasswordValid != null &&
                          !signUpBloc.isPasswordValid!)
                      ? const ValidatorText(
                          text:
                              'Password must be at least 8 characters should contain at least one Upper case, lower case, digit, special character. ')
                      : const SizedBox(
                          height: 25,
                        ),
                  // SignUp button
                  InkWell(
                    onTap: () {
                      if (isDataValid) {
                        BlocProvider.of<SignUpBloc>(context).add(
                            UserSignUpEvent(
                                userDetails: userDetails, context: context));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: signUpBloc.isPasswordValid != null &&
                                  signUpBloc.isPasswordValid!
                              ? 10
                              : 0),
                      decoration: BoxDecoration(
                          gradient: isDataValid
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(71, 191, 223, 1),
                                    Color.fromRGBO(74, 145, 255, 1)
                                  ],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(15),
                          color: !isDataValid
                              ? const Color.fromRGBO(217, 217, 217, 1)
                              : null),
                      child: signUpBloc.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                              'Signup',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Inter'),
                            ),
                    ),
                  ),
                  // Login text and button
                  Padding(
                    padding: const EdgeInsets.only(top: 200, bottom: 50),
                    child: Wrap(
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        // Navigate to login page button
                        InkWell(
                          onTap: () {
                            BlocProvider.of<NavigatorBloc>(context)
                                .add(NavigateToLoginScreen());
                          },
                          child: const GradientText(
                            'Login',
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(71, 191, 223, 1),
                                Color.fromRGBO(74, 145, 255, 1)
                              ],
                            ),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showSelectCountryModelBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: GradientText(
                  'Select Country',
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(71, 191, 223, 1),
                      Color.fromRGBO(74, 145, 255, 1)
                    ],
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter'),
                ),
              ),
              // All country list
              Expanded(
                child: ListView.builder(
                    itemCount: countryDetails.length,
                    itemBuilder: (context, index) {
                      return buildCountryTile(countryDetails[index]);
                    }),
              )
            ],
          );
        });
  }

  Widget buildCountryTile(CountryDetailsModel countryDetail) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: InkWell(
        onTap: () {
          userDetails.country = countryDetail.countryName;
          if (userDetails.phone != null && userDetails.phone!.isNotEmpty) {
            userDetails.phone =
                '+${countryDetail.code}-${userDetails.phone!.split('-')[1]}';
          } else {
            userDetails.phone = '+${countryDetail.code}-';
          }
          _validateForm(SignUpValidator.country);
          BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
        },
        child: Container(
          padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: userDetails.country != null &&
                        userDetails.country == countryDetail.countryName
                    ? Colors.black
                    : const Color.fromRGBO(217, 217, 217, 1),
              )),
          child: Text(
            countryDetail.countryName,
            style: TextStyle(
                color: userDetails.country != null &&
                        userDetails.country == countryDetail.countryName
                    ? Colors.black
                    : const Color.fromRGBO(128, 128, 128, 1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter'),
          ),
        ),
      ),
    );
  }

  List<CountryDetailsModel> get getCountryDetails {
    List<CountryDetailsModel> countryDetails = [];
    for (var countryDetail in Constants.countryList) {
      countryDetails.add(CountryDetailsModel.fromJson(countryDetail));
    }

    return countryDetails;
  }

  _validateForm(SignUpValidator validateType) {
    BlocProvider.of<SignUpBloc>(context).add(ValidatorSignUpEvent(
        userDetails: userDetails, validateType: validateType));
  }
}
