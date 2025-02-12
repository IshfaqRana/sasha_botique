import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../core/router/navigation_service.dart';
import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (state is Unauthenticated) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Get started with SASHA.',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Already have an account?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>  LoginScreen())),
                          child: const Text('Log in'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Your Name',
                      controller: _firstNameController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email address',
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
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'By joining I agree to receive emails from Geeta.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'REGISTER',

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            id: DateTime.now().toString(),
                            email: _emailController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            address: _addressController.text,
                            country: _selectedCountry!,
                            state: _selectedState!,
                            city: _cityController.text,
                            phone: _phoneController.text,
                            postCode: _postCodeController.text,
                          );

                          context.read<AuthBloc>().add(
                                SignupEvent(user, _passwordController.text),
                              );
                        }
                      },
                      isLoading: context.watch<AuthBloc>().state is AuthLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // child: SingleChildScrollView(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Form(
        //     key: _formKey,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //
        //         const SizedBox(height: 16),
        //         const Text(
        //           'USER ACCOUNT',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //         const SizedBox(height: 16),
        //         TextFormField(
        //           controller: _emailController,
        //           decoration: const InputDecoration(
        //             labelText: 'Email *',
        //             border: OutlineInputBorder(),
        //           ),
        //           validator: (value) {
        //             if (value == null || value.isEmpty) {
        //               return 'Please enter your email';
        //             }
        //             if (!value.contains('@')) {
        //               return 'Please enter a valid email';
        //             }
        //             return null;
        //           },
        //         ),
        //         const SizedBox(height: 16),
        //         Row(
        //           children: [
        //             Expanded(
        //               child: TextFormField(
        //                 controller: _passwordController,
        //                 obscureText: _obscurePassword,
        //                 decoration: InputDecoration(
        //                   labelText: 'Password *',
        //                   border: const OutlineInputBorder(),
        //                   suffixIcon: IconButton(
        //                     icon: Icon(
        //                       _obscurePassword
        //                           ? Icons.visibility_off
        //                           : Icons.visibility,
        //                     ),
        //                     onPressed: () {
        //                       setState(() {
        //                         _obscurePassword = !_obscurePassword;
        //                       });
        //                     },
        //                   ),
        //                 ),
        //                 validator: (value) {
        //                   if (value == null || value.isEmpty) {
        //                     return 'Please enter a password';
        //                   }
        //                   if (value.length < 6) {
        //                     return 'Password must be at least 6 characters';
        //                   }
        //                   return null;
        //                 },
        //               ),
        //             ),
        //             const SizedBox(width: 16),
        //             Expanded(
        //               child: TextFormField(
        //                 controller: _confirmPasswordController,
        //                 obscureText: _obscureConfirmPassword,
        //                 decoration: InputDecoration(
        //                   labelText: 'Repeat Password *',
        //                   border: const OutlineInputBorder(),
        //                   suffixIcon: IconButton(
        //                     icon: Icon(
        //                       _obscureConfirmPassword
        //                           ? Icons.visibility_off
        //                           : Icons.visibility,
        //                     ),
        //                     onPressed: () {
        //                       setState(() {
        //                         _obscureConfirmPassword = !_obscureConfirmPassword;
        //                       });
        //                     },
        //                   ),
        //                 ),
        //                 validator: (value) {
        //                   if (value != _passwordController.text) {
        //                     return 'Passwords do not match';
        //                   }
        //                   return null;
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 24),
        //         const Text(
        //           'CONTACT INFORMATION',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //         const SizedBox(height: 16),
        //         Row(
        //           children: [
        //             Expanded(
        //               child: TextFormField(
        //                 controller: _firstNameController,
        //                 decoration: const InputDecoration(
        //                   labelText: 'First Name *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 validator: (value) =>
        //                 value?.isEmpty == true ? 'Required' : null,
        //               ),
        //             ),
        //             const SizedBox(width: 16),
        //             Expanded(
        //               child: TextFormField(
        //                 controller: _lastNameController,
        //                 decoration: const InputDecoration(
        //                   labelText: 'Last Name *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 validator: (value) =>
        //                 value?.isEmpty == true ? 'Required' : null,
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 16),
        //         TextFormField(
        //           controller: _addressController,
        //           maxLines: 3,
        //           decoration: const InputDecoration(
        //             labelText: 'Address *',
        //             border: OutlineInputBorder(),
        //           ),
        //           validator: (value) =>
        //           value?.isEmpty == true ? 'Required' : null,
        //         ),
        //         const SizedBox(height: 16),
        //         Row(
        //           children: [
        //             Expanded(
        //               child: DropdownButtonFormField<String>(
        //                 value: _selectedCountry,
        //                 decoration: const InputDecoration(
        //                   labelText: 'Country *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 items: _countries.map((String country) {
        //                   return DropdownMenuItem(
        //                     value: country,
        //                     child: Text(country),
        //                   );
        //                 }).toList(),
        //                 onChanged: (String? newValue) {
        //                   setState(() {
        //                     _selectedCountry = newValue;
        //                     _selectedState = null;
        //                   });
        //                 },
        //                 validator: (value) =>
        //                 value == null ? 'Please select a country' : null,
        //               ),
        //             ),
        //             const SizedBox(width: 16),
        //             Expanded(
        //               child: DropdownButtonFormField<String>(
        //                 value: _selectedState,
        //                 decoration: const InputDecoration(
        //                   labelText: 'State/Province *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 items: _selectedCountry == null
        //                     ? []
        //                     : _statesByCountry[_selectedCountry]!
        //                     .map((String state) {
        //                   return DropdownMenuItem(
        //                     value: state,
        //                     child: Text(state),
        //                   );
        //                 }).toList(),
        //                 onChanged: (String? newValue) {
        //                   setState(() {
        //                     _selectedState = newValue;
        //                   });
        //                 },
        //                 validator: (value) =>
        //                 value == null ? 'Please select a state' : null,
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 16),
        //         Row(
        //           children: [
        //             Expanded(
        //               flex: 2,
        //               child: TextFormField(
        //                 controller: _cityController,
        //                 decoration: const InputDecoration(
        //                   labelText: 'City *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 validator: (value) =>
        //                 value?.isEmpty == true ? 'Required' : null,
        //               ),
        //             ),
        //             const SizedBox(width: 16),
        //             Expanded(
        //               child: TextFormField(
        //                 controller: _postCodeController,
        //                 decoration: const InputDecoration(
        //                   labelText: 'Post/Zip Code *',
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 validator: (value) =>
        //                 value?.isEmpty == true ? 'Required' : null,
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 16),
        //         TextFormField(
        //           controller: _phoneController,
        //           decoration: const InputDecoration(
        //             labelText: 'Phone *',
        //             border: OutlineInputBorder(),
        //           ),
        //           validator: (value) =>
        //           value?.isEmpty == true ? 'Required' : null,
        //         ),
        //         const SizedBox(height: 16),
        //         Row(
        //           children: [
        //             Checkbox(
        //               value: _agreedToTerms,
        //               onChanged: (bool? value) {
        //                 setState(() {
        //                   _agreedToTerms = value ?? false;
        //                 });
        //               },
        //             ),
        //             const Text('I agree with the terms and conditions.'),
        //           ],
        //         ),
        //         const SizedBox(height: 24),
        //         SizedBox(
        //           width: double.infinity,
        //           height: 48,
        //           child: ElevatedButton(
        //             onPressed: _agreedToTerms
        //                 ? () {
        //               if (_formKey.currentState!.validate()) {
        //                 final user = User(
        //                   id: DateTime.now().toString(),
        //                   email: _emailController.text,
        //                   firstName: _firstNameController.text,
        //                   lastName: _lastNameController.text,
        //                   address: _addressController.text,
        //                   country: _selectedCountry!,
        //                   state: _selectedState!,
        //                   city: _cityController.text,
        //                   phone: _phoneController.text,
        //                   postCode: _postCodeController.text,
        //                 );
        //
        //                 context.read<AuthBloc>().add(
        //                   SignupEvent(user, _passwordController.text),
        //                 );
        //               }
        //             }
        //                 : null,
        //             child: BlocBuilder<AuthBloc, AuthState>(
        //               builder: (context, state) {
        //                 if (state is AuthLoading) {
        //                   return const CircularProgressIndicator(
        //                     color: Colors.white,
        //                   );
        //                 }
        //                 return const Text('CREATE ACCOUNT');
        //               },
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 5,),
        //         Center(
        //           child: TextButton(
        //             onPressed: () =>  Navigator.push(
        //                 context, MaterialPageRoute(builder: (context) =>  LoginScreen())),
        //             child: const Text('Already Registered? Log In'),
        //           ),
        //         ),
        //         SizedBox(height: 10,),
        //       ],
        //     ),
        //   ),
        // ),
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
