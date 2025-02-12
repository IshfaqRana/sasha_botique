import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(
              ChangeThemeEvent(
                state.themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              ),
            );
          },
          tooltip: state.themeMode == ThemeMode.dark
              ? 'Switch to light theme'
              : 'Switch to dark theme',
        );
      },
    );
  }
}
