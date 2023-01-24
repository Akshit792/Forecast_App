import 'dart:io';

import 'package:a2d_forecast_app/splash/bloc/splash_bloc.dart';
import 'package:a2d_forecast_app/common/services/api_client.dart';
import 'package:a2d_forecast_app/common/models/context_holder.dart';
import 'package:a2d_forecast_app/common/repository/forecast_repository.dart';
import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(RepositoryProvider(
    create: (context) => ForecastRepository(
        forecastApiClient: ApiClient(httpClient: http.Client())),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigatorBloc>(
          create: (BuildContext context) =>
              NavigatorBloc(navigatorKey: ContextHolder.key),
        ),
        BlocProvider<SplashBloc>(
          create: (BuildContext context) => SplashBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Inter',
          primarySwatch: Colors.blue,
        ),
        navigatorKey: ContextHolder.key,
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
