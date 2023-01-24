import 'package:a2d_forecast_app/common/widgets/gradient_text.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Grdient background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(71, 191, 223, 1),
                Color.fromRGBO(74, 145, 255, 1)
              ],
            )),
          ),
          // Background ui elements (world image)
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'asset/images/world_onboarding.png',
                    ))),
          ),
          introCardWidget(),
        ],
      ),
    );
  }

  Widget introCardWidget() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 32,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 23.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 35,
            ),
            const Text(
              'Expore global map of wind, weather, and ocean conditions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Planing your trip become more easier with ideate weather app. you can instantly see the whole word weather within few second',
              style: TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(107, 106, 113, 1),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            // Get started button
            InkWell(
              onTap: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigateToSignUpScreen());
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 19,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(71, 191, 223, 1),
                        Color.fromRGBO(74, 145, 255, 1)
                      ],
                    )),
                child: const Text(
                  'Get started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Log in button
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Already have an account ?',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigateToLoginScreen());
                    },
                    child: const GradientText(
                      'Log in',
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(71, 191, 223, 1),
                          Color.fromRGBO(74, 145, 255, 1)
                        ],
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
