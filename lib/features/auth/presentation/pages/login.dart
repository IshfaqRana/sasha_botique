import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/auth/presentation/pages/signup.dart';
import 'package:sasha_botique/features/auth/presentation/pages/welcome_screen.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../products/presentation/pages/home_screen.dart';
import '../../../theme/presentation/theme/theme_helper.dart';
import '../bloc/auth_bloc.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
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
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Welcome text
                      Text(
                        'Welcome Back!',
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
                        width: screenWidth * 0.75,
                        child: Text(
                          'We\'re thrilled to see you again. Explore fresh looks and limited offers just for you.now',
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
                      // Login form card
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
                                'LOG IN',
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
                                prefixIcon: Icon(Icons.email),
                                label: 'Email address',
                                controller: _emailController,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              CustomTextField(
                                prefixIcon: Icon(Icons.lock_outline),
                                label: 'Password',
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordScreen()));
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return CustomButton(
                                    text: 'LOG IN',
                                    isLoading: state is AuthLoading,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              LoginEvent(
                                                _emailController.text,
                                                _passwordController.text,
                                              ),
                                            );
                                      }
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Not registered yet?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignupScreen()));
                                    },
                                    child: const Text('Create an Account'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Browse as guest button outside the card
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: context.colors.whiteColor,
                          ),
                          label: Text(
                            'Browse as Guest',
                            style: TextStyle(
                              color: context.colors.whiteColor,
                            ),
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
      ),
    );
  }

  // (legacy loginForm removed in Sliver refactor)
}
