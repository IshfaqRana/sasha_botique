import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                lightWhiteColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative images positioned throughout the background
              // Top section
              Positioned(
                right: screenWidth * 0.1,
                top: screenHeight * 0.08,
                child: Opacity(
                  opacity: 0.3,
                  child: SizedBox(
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.45,
                    child: Image.asset(
                      "assets/images/design.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: screenWidth * 0.07,
                top: screenHeight * 0.03,
                child: Opacity(
                  opacity: 0.35,
                  child: SizedBox(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.38,
                    child: Image.asset(
                      "assets/images/login_girl.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Middle section
              Positioned(
                left: -screenWidth * 0.1,
                top: screenHeight * 0.35,
                child: Opacity(
                  opacity: 0.2,
                  child: SizedBox(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.4,
                    child: Image.asset(
                      "assets/images/design.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Bottom section
              Positioned(
                right: -screenWidth * 0.05,
                bottom: screenHeight * 0.05,
                child: Opacity(
                  opacity: 0.25,
                  child: SizedBox(
                    height: screenHeight * 0.28,
                    width: screenWidth * 0.4,
                    child: Image.asset(
                      "assets/images/design.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.05,
                bottom: -screenHeight * 0.02,
                child: Opacity(
                  opacity: 0.2,
                  child: SizedBox(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.3,
                    child: Image.asset(
                      "assets/images/login_girl.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Scrollable content
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: context.colors.whiteColor,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Title text
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: context.colors.whiteColor,
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: screenHeight * 0.012),
                      SizedBox(
                        width: screenWidth * 0.85,
                        child: Text(
                          'Enter your email address below. We\'ll send you a link to reset your password.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: context.colors.whiteColor.withValues(alpha: 0.9),
                                fontSize: screenWidth * 0.038,
                                height: 1.4,
                              ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.045),
                      // Form card
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RESET PASSWORD',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: screenHeight * 0.028),
                              CustomTextField(
                                label: 'Email address',
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenHeight * 0.035),
                              BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is PasswordResetEmailSent) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Password reset email sent!')),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResetPasswordScreen(
                                            email: _emailController.text),
                                      ),
                                    );
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
