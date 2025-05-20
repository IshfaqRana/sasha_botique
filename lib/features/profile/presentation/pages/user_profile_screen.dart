import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/payment/presentation/pages/payment_methods_screen.dart';
import 'package:sasha_botique/features/profile/presentation/pages/user_address_screen.dart';
import 'package:sasha_botique/shared/widgets/cached_network_image.dart';
import 'package:sasha_botique/shared/widgets/loading_overlay.dart';
import 'dart:io';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_address/user_address_bloc.dart';
import '../bloc/user_profile/user_profile_bloc.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/profile_edit_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  late final ProfileBloc profileBloc;
  late final AddressBloc addressBloc;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    profileBloc = getIt<ProfileBloc>();
    addressBloc = getIt<AddressBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile',style: context.titleMedium,),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          listener: (context, state) {
            if (state is ProfileLoading ) {
              setState(() {
                isLoading = true;
              });
            }
            if(state is ProfileLoaded){
              setState(() {
                isLoading =false;
              });
            }
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              setState(() {
                isLoading =false;
              });
            } else if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully')),
              );
              setState(() {
                isLoading =false;
              });
            } else if (state is ProfilePictureUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile picture updated successfully')),
              );
              setState(() {
                isLoading =false;
              });
            } else if (state is PasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password changed successfully')),
              );
              setState(() {
                isLoading =false;
              });
            }
          },
          builder: (context, state) {

              final user = state.user;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileImageSection(context, user.profileImageUrl),
                      const SizedBox(height: 24),

                      _buildInfoItem(
                        context: context,
                        // label: user.title + ' ' + user.firstName + ' ' + user.lastName,
                        label: '${user.firstName} ${user.lastName}',
                        iconData: Icons.person,
                        onTap: () => _showNameUpdateDialog(context, user.title, user.firstName, user.lastName,user),
                      ),

                      _buildInfoItem(
                        context: context,
                        label: user.username,
                        iconData: Icons.person_outline,
                        onTap: () =>
                            _showUpdateDialog(
                              context,
                              'Update Username',
                              user.username,
                                  (value) {
                                    profileBloc.add(
                                  UpdateUserProfileEvent(
                                    title: user.title,
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    username: value,
                                    email: user.email,
                                    mobileNo: user.mobileNo,
                                  ),
                                );
                              },
                            ),
                      ),

                      _buildInfoItem(
                        context: context,
                        label: user.email,
                        iconData: Icons.email,
                        onTap: () =>
                            _showUpdateDialog(
                              context,
                              'Update Email',
                              user.email,
                                  (value) {
                                    profileBloc.add(
                                  UpdateUserProfileEvent(
                                    title: user.title,
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    username: user.username,
                                    email: value,
                                    mobileNo: user.mobileNo,
                                  ),
                                );
                              },
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                      ),

                      _buildInfoItem(
                        context: context,
                        label: user.mobileNo,
                        iconData: Icons.phone,
                        onTap: () =>
                            _showUpdateDialog(
                              context,
                              'Update Mobile Number',
                              user.mobileNo,
                                  (value) {
                                    profileBloc.add(
                                  UpdateUserProfileEvent(
                                    title: user.title,
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    username: user.username,
                                    email: user.email,
                                    mobileNo: value,
                                  ),
                                );
                              },
                              textInputType: TextInputType.phone,
                            ),
                      ),

                      _buildInfoItem(
                        context: context,
                        label: '********',
                        iconData: Icons.lock,
                        onTap: () => _showPasswordChangeDialog(context),
                      ),

                      const SizedBox(height: 16),
                      //
                      _buildDeliveryAddressTile(context),

                      const SizedBox(height: 16),
                      _buildPaymentMethodTile(context),

                      const SizedBox(height: 16),

                      _buildLogoutButton(context),
                      const SizedBox(height: 16),_deleteAccount(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );

          },
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context, String? profileImageUrl) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.amber,
              width: 3.0,
            ),
          ),
          child: ClipOval(
            child: profileImageUrl != null && profileImageUrl.isNotEmpty
                ? CustomCachedNetworkShimmer(
               imageUrl: profileImageUrl,
              // fit: BoxFit.cover,
              height: 120,
              width: 120,
            )
                : Icon(
              Icons.person,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       shape: BoxShape.circle,
        //       border: Border.all(color: Colors.grey.shade300),
        //     ),
        //     child: IconButton(
        //       icon: Icon(Icons.edit, size: 20),
        //       onPressed: () => _showImageSourceDialog(context),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required String label,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: Colors.grey.shade700),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.grey.shade600),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildDeliveryAddressTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: Colors.grey.shade700),
        title: Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddressScreen()));

        },
      ),
    );
  }
  Widget _buildPaymentMethodTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.payment, color: Colors.grey.shade700),
        title: Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => PaymentMethodsScreen()));

        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red.shade400),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red.shade400,
          ),
        ),
        onTap: () {
          getIt<AuthBloc>().add(LogoutEvent());
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);

        },
      ),
    );
  }
  Widget _deleteAccount(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red.shade400),
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red.shade400,
          ),
        ),
        onTap: () => showDeleteAccountDialog(context),
      ),
    );
  }
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                profileBloc.add(DeleteUserEvent());
                // getIt<AuthBloc>().add(LogoutEvent());
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);

              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Update Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      profileBloc.add(
                        UpdateProfilePictureEvent(image.path),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      profileBloc.add(
                        UpdateProfilePictureEvent(photo.path),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context,) {
    showDialog(
        context: context,
        builder: (context) {
          return PasswordChangeDialog(onSave: (value){},);
        }
    );
  }  void _showUpdateDialog(BuildContext context, String title, String field, Function(String) onSave, {TextInputType textInputType = TextInputType.text,String? Function(String?)? validator}) {
    showDialog(
        context: context,
        builder: (context) {
          return ProfileEditDialog(title: title,initialValue: field,onSave: onSave,validator: validator,keyboardType: textInputType,);
        }
    );
  }
  void _showNameUpdateDialog(BuildContext context, String title, String firstName, String lastName,User user) {
    showDialog(
        context: context,
        builder: (context) {
      String currentTitle = title;
      TextEditingController firstNameController = TextEditingController(text: firstName);
      TextEditingController lastNameController = TextEditingController(text: lastName);

      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Name'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title selection
                    // DropdownButtonFormField<String>(
                    //   value: currentTitle,
                    //   decoration: InputDecoration(
                    //     labelText: 'Title',
                    //     border: OutlineInputBorder(),
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //   ),
                    //   items: ['Mr.', 'Mrs', 'Ms', 'Dr', 'Prof'].map((title) {
                    //     return DropdownMenuItem(
                    //       value: title,
                    //       child: Text(title),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         currentTitle = value;
                    //       });
                    //     }
                    //   },
                    // ),
                    SizedBox(height: 16),
                    // First name
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: "Name",),
                    ),
                    SizedBox(height: 16),
                    // First name
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: "Last Name",),
                    ),
                  ]),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty) {
                      profileBloc.add(
                        UpdateUserProfileEvent(
                          title: user.title,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          username: user.username,
                          email: user.email,
                          mobileNo: user.mobileNo,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          });
  });
    }
}