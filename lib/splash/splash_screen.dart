import 'package:a2d_forecast_app/splash/bloc/splash_bloc.dart';
import 'package:a2d_forecast_app/splash/bloc/splash_event.dart';
import 'package:a2d_forecast_app/splash/bloc/splash_state.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        if (state is InitialSplashState) {
          BlocProvider.of<SplashBloc>(context)
              .add(CheckUserLogedInStatusAccountsEvent(context: context));
        }
        if (state is UserIsLogedInSplashState) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigateToForecastScreen(
              weatherData: BlocProvider.of<SplashBloc>(context).liveWeather!,
              cityList: BlocProvider.of<SplashBloc>(context).cityList,
            ),
          );
        }
        if (state is UserNotLogedInSplashState) {
          BlocProvider.of<NavigatorBloc>(context)
              .add(NavigateToOnBoardingScreen());
        }
        if (state is ErrorSplashState) {
          BlocProvider.of<NavigatorBloc>(context).add(NavigateToLoginScreen());
        }
        return Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: const SizedBox(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage('asset/images/splash_screen_icon.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (state is LoadingSplashState)
                Container(
                  height: double.infinity,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(73, 168, 239, 1),
                      strokeWidth: 2.7,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
