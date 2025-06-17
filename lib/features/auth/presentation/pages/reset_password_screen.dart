import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart'; // For custom styles

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({Key? key,required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late AuthBloc authBloc;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  int _remainingResendTime = 60;
  bool _canResendOtp = false;

  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    authBloc = getIt<AuthBloc>();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingResendTime--;
        if (_remainingResendTime <= 0) {
          _canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (_canResendOtp) {
      // Implement OTP resend logic
      setState(() {
        _remainingResendTime = 60;
        _canResendOtp = false;
      });
      _startResendTimer();
    }
  }

  void _resetPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    authBloc.add(
      ResetPasswordEvent(
        otp: _otpController.text,
        newPassword: _passwordController.text,
          email: widget.email,
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset successfully')),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
              
                  OtpTextField(
                    numberOfFields: 4,
                    borderColor: Color(0xFF512DA8),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      // Update the OTP controller's text with the full OTP
                      // _otpController.text = code; // This will replace the OTP text with the full value each time
                    },
                    onSubmit: (String code) {
                      // This can be used when you want to handle the OTP submission after all fields are filled
                      print('OTP Entered: $code');
                      _otpController.text = code;
                    },
                  ),
                  const SizedBox(height: 40),
                  if (!_canResendOtp)
                    Center(child: Text('Resend OTP in $_remainingResendTime seconds')),
                  const SizedBox(height: 40),
                  _buildResendButton(),
                  const SizedBox(height: 100),
                  CustomTextField(
                    label: 'New Password',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  CustomTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    text: 'Reset Password',
                    onPressed: _resetPassword,
                    isLoading: state is AuthLoading,
                  ),
                  const SizedBox(height: 16),
              
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResendButton() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          text: "Didn't receive the code? ",
          children: [
            TextSpan(
              text: "Resend",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _canResendOtp ? Colors.blue : Colors.grey,
              ),
              recognizer: TapGestureRecognizer()..onTap = _resendOtp,
            ),
          ],
        ),
      ),
    );
  }
}
