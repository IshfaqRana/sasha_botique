import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/utils/phone_validation.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../products/presentation/pages/home_screen.dart';
import '../../../profile/domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/validation_error_widget.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  List<String> _validationErrors = [];

  // Dummy data for dropdowns
  final List<String> _countries = ['USA', 'UK', 'Canada', 'Australia'];
  final Map<String, List<String>> _statesByCountry = {
    'USA': ['California', 'New York', 'Texas'],
    'UK': ['England', 'Scotland', 'Wales'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia'],
    'Australia': ['New South Wales', 'Victoria', 'Queensland'],
    'Pakistan': ['Punjab', 'Sindh', 'Balochistan', 'KPK', 'Kashmir', 'GB'],
  };

  @override
  void initState() {
    super.initState();
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
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                setState(() {
                  _validationErrors = [];
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
              } else if (state is AuthError) {
                setState(() {
                  _validationErrors = (state.validationErrors != null && state.validationErrors!.isNotEmpty)
                      ? state.validationErrors!
                      : [state.message];
                });
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
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        // Welcome text
                        Text(
                          'Get\'s started with SASHA.',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: context.colors.whiteColor,
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: screenHeight * 0.008),
                        Row(
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: context.colors.whiteColor.withValues(alpha: 0.9),
                                    fontSize: screenWidth * 0.035,
                                  ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen())),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  color: context.colors.whiteColor,
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Signup form card
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
                          child: signupForm(context),
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

  Widget signupForm(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: screenHeight * 0.024),
              CustomTextField(
                label: 'First Name',
                controller: _firstNameController,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Last Name',
                controller: _lastNameController,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Username *',
                controller: _userNameController,
                prefixIcon: const Icon(Icons.person_2),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                prefixIcon: const Icon(Icons.phone),
                controller: _phoneController,
                label: 'Phone *',
                keyboardType: TextInputType.phone,
                inputFormatters: PhoneValidation.getUkMobileFormatters(),
                validator: (value) => PhoneValidation.getValidationError(value ?? ''),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email address *',
                controller: _emailController,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              // const SizedBox(height: 24),
              // Row(
              //   children: [
              //     Checkbox(
              //       value: _agreedToTerms,
              //       onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
              //     ),
              //     Expanded(
              //       child: Text(
              //         'By joining I agree to receive emails from Geeta.',
              //         style: Theme.of(context).textTheme.bodySmall,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              ValidationErrorWidget(errors: _validationErrors),
              const SizedBox(height: 8),
              CustomButton(
                text: 'REGISTER',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Clear validation errors before submitting
                    setState(() {
                      _validationErrors = [];
                    });

                    final user = User(
                      // id: DateTime.now().toString(),
                      email: _emailController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      username: _userNameController.text,

                      mobileNo: _phoneController.text, title: 'Mr.',
                    );

                    context.read<AuthBloc>().add(
                          SignupEvent(user, _passwordController.text),
                        );
                  }
                },
                isLoading: context.watch<AuthBloc>().state is AuthLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
