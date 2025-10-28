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
import '../widgets/background_design.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: context.colors.blackWhite,
        //   leading: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        //     child: GestureDetector(
        //         onTap: () {
        //           Navigator.pop(context);
        //         },
        //         child: FaIcon(FontAwesomeIcons.chevronLeft)),
        //   ),
        // ),
        body: BlocListener<AuthBloc, AuthState>(
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
                // If there are validation errors, use them; otherwise create a list with the general error message
                _validationErrors = (state.validationErrors != null && state.validationErrors!.isNotEmpty)
                    ? state.validationErrors!
                    : [state.message];
              });
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Header section
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 312,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.blackWhite,
                      ),
                      child: Stack(
                        children: [
                          BackgroundDesign(width: 414, height: 352),
                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: context.colors.whiteColor,
                                        size: 30,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Get\'s started with SASHA.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              color: context.colors.whiteColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Already have an account?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: context.colors.whiteColor),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen())),
                                          child: Text(
                                            'Log in',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color:
                                                        context.colors.whiteColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Register',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              color: context.colors.whiteColor),
                                    ),
                                  ),
                                  const SizedBox(height: 20), // Add some bottom spacing
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form section
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: signupForm(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signupForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
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
        ),
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
