import 'package:flutter/material.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'navigation_service.dart';

class RouteGuards {
  final AuthBloc authBloc;

  RouteGuards(this.authBloc);

  Future<bool> authGuard(BuildContext context) async {
    final state = authBloc.state;
    if (state is Authenticated) {
      return true;
    }
    NavigationService().replaceTo('/login');
    return false;
  }

  Future<bool> unauthGuard(BuildContext context) async {
    final state = authBloc.state;
    if (state is Unauthenticated) {
      return true;
    }
    NavigationService().replaceTo('/home');
    return false;
  }
}