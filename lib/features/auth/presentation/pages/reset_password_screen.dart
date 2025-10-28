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

  // Progressive timer intervals like WhatsApp: 60s → 120s → 300s → 1800s
  final List<int> _timerIntervals = [60, 120, 300, 1800];
  int _currentIntervalIndex = 0;
  int _remainingResendTime = 60;
  bool _canResendOtp = false;
  bool _isResendingOtp = false;

  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    authBloc = getIt<AuthBloc>();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResendOtp = false;
    _remainingResendTime = _timerIntervals[_currentIntervalIndex];

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingResendTime--;
          if (_remainingResendTime <= 0) {
            _canResendOtp = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _resendOtp() {
    if (_canResendOtp && !_isResendingOtp) {
      setState(() {
        _isResendingOtp = true;
      });

      // Call the API to resend OTP
      authBloc.add(ResendOTPEvent(widget.email));
    }
  }

  void _handleResendSuccess() {
    // Move to next interval for progressive delay
    if (_currentIntervalIndex < _timerIntervals.length - 1) {
      _currentIntervalIndex++;
    }

    setState(() {
      _isResendingOtp = false;
    });

    _startResendTimer();
  }

  String _formatTime(int seconds) {
    if (seconds >= 60) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
      }
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
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
    _resendTimer?.cancel();
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
          } else if (state is OTPResentSuccessfully) {
            _handleResendSuccess();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP has been resent to your email'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            // Handle resend error
            if (_isResendingOtp) {
              setState(() {
                _isResendingOtp = false;
              });
            }
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
                    focusedBorderColor: Color(0xFF512DA8),
                    showFieldAsBox: true,
                    fieldWidth: MediaQuery.of(context).size.width * 0.15,
                    fieldHeight: 56.0,
                    borderWidth: 2.0,
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    onCodeChanged: (String code) {
                      // Handle code change
                    },
                    onSubmit: (String code) {
                      _otpController.text = code;
                    },
                  ),
                  const SizedBox(height: 40),
                  if (!_canResendOtp)
                    Center(
                      child: Text(
                        'Resend OTP in ${_formatTime(_remainingResendTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
      child: _isResendingOtp
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sending...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : RichText(
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
                      decoration: _canResendOtp ? TextDecoration.underline : null,
                    ),
                    recognizer: _canResendOtp && !_isResendingOtp
                        ? (TapGestureRecognizer()..onTap = _resendOtp)
                        : null,
                  ),
                ],
              ),
            ),
    );
  }
}
