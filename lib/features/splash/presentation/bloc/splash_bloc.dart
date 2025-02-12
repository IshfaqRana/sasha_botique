import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthBloc authBloc;

  SplashBloc(this.authBloc) : super(SplashInitial()) {
    on<LoadSplash>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay

      final authState = authBloc.state;

      if (authState is Authenticated) {
        emit(SplashLoaded(isAuthenticated: true));
      } else {
        emit(SplashLoaded(isAuthenticated: false));
      }
    });
  }
}