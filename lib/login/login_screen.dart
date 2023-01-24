import 'package:a2d_forecast_app/common/constants.dart';
import 'package:a2d_forecast_app/common/models/user_details_model.dart';
import 'package:a2d_forecast_app/common/widgets/custom_textfield.dart';
import 'package:a2d_forecast_app/common/widgets/gradient_text.dart';
import 'package:a2d_forecast_app/common/widgets/validator_text.dart';
import 'package:a2d_forecast_app/login/bloc/login_bloc.dart';
import 'package:a2d_forecast_app/login/bloc/login_event.dart';
import 'package:a2d_forecast_app/login/bloc/login_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserDetailsModel loginCredentials = UserDetailsModel();
  bool obscureText = true;
  bool rememberMe = false;

  @override
  void initState() {
    // Retrieve the saved login credentials from the local storage
    BlocProvider.of<LoginBloc>(context).add(RememberMeLoginEvent(
      saveOrRetrieveOrDelete: 'retrieve',
      context: context,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          current is ValidateLoginState ||
          current is CheckDataLoginState ||
          current is ErrorLoginState,
      builder: (context, state) {
        var loginBloc = BlocProvider.of<LoginBloc>(context);
        bool isDataValid = loginBloc.isDataValid;

        if (state is CheckDataLoginState) {
          if (loginBloc.savedLoginCredentails.isNotEmpty) {
            // Auto assign the saved credentials to the field
            loginCredentials =
                UserDetailsModel.fromJson(loginBloc.savedLoginCredentails);
            rememberMe =
                loginBloc.savedLoginCredentails['remember_me'] ?? false;
            _validateForm(SignUpValidator.emailAddress);
          }
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo image
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
                  // Login error validator
                  (state is ErrorLoginState)
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
                  // Email address field
                  CustomTextField(
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    text: loginCredentials.emailAddress ?? '',
                    onChanged: (emailAddress) {
                      loginCredentials.emailAddress = emailAddress;
                      _validateForm(SignUpValidator.emailAddress);
                    },
                  ),
                  // Email address validator
                  (loginBloc.isEmailAddressValid != null &&
                          !loginBloc.isEmailAddressValid!)
                      ? const ValidatorText(
                          text: 'Please enter a valid email address')
                      : const SizedBox(
                          height: 25,
                        ),
                  // Password field
                  CustomTextField(
                    hintText: 'Password',
                    textInputType: TextInputType.text,
                    text: loginCredentials.password ?? '',
                    obscureText: obscureText,
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: obscureText
                          ? const Color.fromRGBO(128, 128, 128, 1)
                          : const Color.fromRGBO(71, 191, 223, 1),
                    ),
                    onChanged: (password) {
                      loginCredentials.password = password;
                      _validateForm(SignUpValidator.password);
                    },
                    onTap: () {
                      obscureText = !obscureText;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Remember me
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Remember me checkbox
                      Checkbox(
                          side: const BorderSide(
                            width: 1,
                            color: Color.fromRGBO(128, 128, 128, 1),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          value: rememberMe,
                          onChanged: (_) {
                            rememberMe = !rememberMe;
                            setState(() {});
                          }),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Login button
                  InkWell(
                    onTap: () {
                      if (isDataValid) {
                        loginBloc.add(UserLoginEvent(
                          context: context,
                          loginCredentials: loginCredentials,
                          rememberMe: rememberMe,
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
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
                      child: loginBloc.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Inter'),
                            ),
                    ),
                  ),
                  // User signup text and signup button
                  Container(
                    padding: const EdgeInsets.only(top: 370, bottom: 50),
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<NavigatorBloc>(context)
                                .add(NavigateToSignUpScreen());
                          },
                          child: const GradientText(
                            'Signup',
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _validateForm(SignUpValidator validateType) {
    BlocProvider.of<LoginBloc>(context).add(ValidatorLoginEvent(
        loginCredentials: loginCredentials, validateType: validateType));
  }
}
