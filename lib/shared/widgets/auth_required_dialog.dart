import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login.dart';

class AuthRequiredDialog extends StatelessWidget {
  final String title;
  final String message;

  const AuthRequiredDialog({
    Key? key,
    this.title = 'Login Required',
    this.message = 'You need to login to access this feature.',
  }) : super(key: key);

  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AuthRequiredDialog(
        title: title ?? 'Login Required',
        message: message ?? 'You need to login to access this feature.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AuthRequiredMixin {
  /// Checks if user is authenticated. If not, shows login dialog.
  /// Returns true if authenticated, false otherwise.
  static Future<bool> checkAuthAndPrompt(
    BuildContext context, {
    String? title,
    String? message,
  }) async {
    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated) {
      return true;
    }

    await AuthRequiredDialog.show(
      context,
      title: title,
      message: message,
    );

    return false;
  }
}