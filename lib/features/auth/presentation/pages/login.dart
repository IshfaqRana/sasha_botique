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
import '../widgets/background_design.dart';
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
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) =>  HomeScreen()),(Route<dynamic> route) => false);

          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            BackgroundDesign(),
            Positioned(
                child: SizedBox(
                  // height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: IconButton(
                        icon:  Icon(Icons.arrow_back,color: context.colors.whiteColor,size: 30,),
                        onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>  WelcomeScreen())),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: context.colors.whiteColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          'Yay! You\'re back! Thanks for shopping with us. We have excited deals and promotions going on, grab your pick now!',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.whiteColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'LOG IN',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: context.colors.whiteColor),
                      ),
                    ),
                    const SizedBox(height: 100),
                                  ],
                                ),
                  ),
                )),
            loginForm(context),
          ],
        ),
      ),
    );
  }

  Positioned loginForm(BuildContext context) {
    return Positioned(
            child: Padding(
        padding: const EdgeInsets.only(
        left: 24.0,
        right: 24,
        top: 454,
    ),
    child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 40),
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
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>  ForgotPasswordScreen()));
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not registered yet?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  SignupScreen()));

                          },
                          child: const Text('Create an Account'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    ),
            ),
          );
  }
}