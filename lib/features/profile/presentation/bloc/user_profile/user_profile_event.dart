part of 'user_profile_bloc.dart';

abstract class ProfileEvent {}

class GetUserProfileEvent extends ProfileEvent {}
class DeleteUserEvent extends ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final String title;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String mobileNo;

  UpdateUserProfileEvent({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobileNo,
  });
}

class UpdateProfilePictureEvent extends ProfileEvent {
  final String filePath;

  UpdateProfilePictureEvent(this.filePath);
}

class ChangePasswordEvent extends ProfileEvent {
  final String newPassword;

  ChangePasswordEvent(this.newPassword);
}
