import 'package:a2d_forecast_app/navigator/navigator_bloc.dart';
import 'package:a2d_forecast_app/navigator/navigator_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpSuccessfullScreen extends StatefulWidget {
  const SignUpSuccessfullScreen({super.key});

  @override
  State<SignUpSuccessfullScreen> createState() =>
      _SignUpSuccessfullScreenState();
}

class _SignUpSuccessfullScreenState extends State<SignUpSuccessfullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 85,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 70),
            child: const Image(image: AssetImage('asset/images/A2d_logo.png')),
          ),
          Container(
            height: 300,
            width: 300,
            alignment: Alignment.center,
            child: const Image(
              image: AssetImage('asset/images/login_successfull_image.png'),
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigateToLoginScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Back to Login',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
