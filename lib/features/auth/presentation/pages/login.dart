// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
// import 'package:sasha_botique/features/auth/presentation/pages/signup.dart';
// import 'package:sasha_botique/features/home/presentation/pages/home_screen.dart';
//
// import '../../../../core/router/navigation_service.dart';
// import '../bloc/auth_bloc.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is Authenticated) {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) =>  HomeScreen()));
//
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Login with your account',
//                   style: context.headlineMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Enter your e-mail address and password to log in.',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 32),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       // Handle forgot password
//                     },
//                     child: const Text('Forgot password?'),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         context.read<AuthBloc>().add(
//                           LoginEvent(
//                             _emailController.text,
//                             _passwordController.text,
//                           ),
//                         );
//                       }
//                     },
//                     child: BlocBuilder<AuthBloc, AuthState>(
//                       builder: (context, state) {
//                         if (state is AuthLoading) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4.0),
//                             child: const CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                           );
//                         }
//                         return const Text('SIGN IN');
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't have an account?"),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context, MaterialPageRoute(builder: (context) =>  SignupScreen()));
//
//                       },
//                       child: const Text('Sign up'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/auth/presentation/pages/signup.dart';
import 'package:sasha_botique/features/auth/presentation/pages/welcome_screen.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../home/presentation/pages/home_screen.dart';
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>  WelcomeScreen())),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yay! You\'re back! Thanks for shopping with us. We have excited deals and promotions going on, grab your pick now!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
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
      ),
    );
  }
}