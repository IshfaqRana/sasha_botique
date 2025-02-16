import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login.dart';
import '../../../auth/presentation/pages/welcome_screen.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';
import '../widgets/splash_logo.dart';
import '../../../products/presentation/pages/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(getIt<AuthBloc>()..add(CheckAuthStatusEvent()))..add(LoadSplash()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            if (state.isAuthenticated) {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) =>  HomeScreen()), (Route<dynamic> route) => false);

            } else {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) =>  WelcomeScreen()),(Route<dynamic> route) => false);

            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned(top: -10,bottom: -10,left: -10,right: -10, child: SplashLogo()),

            ],
          ),
        ),
      ),
    );
  }
}