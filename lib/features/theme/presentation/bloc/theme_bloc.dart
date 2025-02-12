import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sasha_botique/features/theme/domain/repositories/theme_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc(this.themeRepository) : super(ThemeInitial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final themeMode = await themeRepository.getThemeMode();
    //as of now we are working over light theme
    emit(ThemeLoaded(ThemeMode.light));
  }

  Future<void> _onChangeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) async {
    await themeRepository.setThemeMode(event.themeMode);
    emit(ThemeLoaded(event.themeMode));
  }
}
