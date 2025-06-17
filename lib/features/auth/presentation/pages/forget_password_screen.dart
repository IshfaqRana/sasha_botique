import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/background_design.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = getIt<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
            children: [
              BackgroundDesign(
                height: 380,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: context.colors.whiteColor,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: context.colors.whiteColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email address below. We\'ll send you a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.whiteColor),
                      ),
                      const SizedBox(height: 200),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            CustomTextField(
                              label: 'Email address',
                              controller: _emailController,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 32),
                            BlocConsumer<AuthBloc, AuthState>(
                              // bloc: authBloc,
                              listener: (context, state) {
                                if (state is PasswordResetEmailSent) {
                          
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password reset email sent!')),
                                  );
                                  // Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: _emailController.text)));
                          
                                } else if (state is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  text: 'SUBMIT',
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        ForgotPasswordEvent(_emailController.text),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ],),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

  }
}
