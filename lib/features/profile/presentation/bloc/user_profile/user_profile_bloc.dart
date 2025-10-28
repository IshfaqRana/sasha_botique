import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/features/profile/domain/usecases/delete_user.dart';
import 'package:sasha_botique/features/profile/domain/usecases/get_user_address.dart';
import 'package:sasha_botique/features/profile/domain/usecases/update_user_address.dart';

import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/update_user_profile.dart';
import '../../../domain/usecases/update_profile_picture.dart';
import '../../../domain/usecases/change_password.dart';
import '../../../domain/entities/user.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

String link =
    "https://img.freepik.com/premium-vector/vector-flat-illustration-grayscale-avatar-user-profile-person-icon-profile-picture-business-profile-woman-suitable-social-media-profiles-icons-screensavers-as-templatex9_719432-1328.jpg?semt=ais_hybrid";

  User initialUser = User(title: "Mr", firstName: "John", lastName: "Doe", username: "john", email: "john@gmail.com", mobileNo: "+92347715667",profileImageUrl: link);

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final UpdateProfilePicture updateProfilePicture;
  final ChangePassword changePassword;
  final DeleteUser deleteUser;

  User user = initialUser;
  ProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.updateProfilePicture,
    required this.changePassword,
    required this.deleteUser,

  }) : super(ProfileInitial(initialUser)) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteUserEvent>(_deleteUserEvent);
  }

  Future<void> _onGetUserProfile(
      GetUserProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading(user));
    try {
      final fetchedUser = await getUserProfile();
      user = fetchedUser;
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}',user));
    }
  }
  Future<void> _deleteUserEvent(
      DeleteUserEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading(user));
    try {
      await deleteUser();

      emit(DeleteUserSuccess(user));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}',user));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading(user));
    try {
      final _user = User(
        title: event.title,
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
        email: event.email,
        mobileNo: event.mobileNo,
      );

      final updatedUser = await updateUserProfile(_user);

      if (updatedUser.firstName != "") {

        user = updatedUser;
        emit(ProfileUpdated(updatedUser));
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileError('Failed to update profile',user));
      }
    } catch (e) {
      emit(ProfileError('Error updating profile: ${e.toString()}',user));
    }
  }

  Future<void> _onUpdateProfilePicture(
      UpdateProfilePictureEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading(user));
    try {
      final updatedUser = await updateProfilePicture(event.filePath);

      if (updatedUser.firstName != "") {

        user = updatedUser;
        emit(ProfilePictureUpdated(updatedUser));
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileError('Failed to update profile picture',user));
      }
    } catch (e) {
      emit(ProfileError('Error updating profile picture: ${e.toString()}',user));
    }
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading(user));
    try {
      final updatedUser = await changePassword(event.currentPassword, event.newPassword);

      if (updatedUser.firstName != "") {
        // Password change successful - don't update user data, just emit success
        emit(PasswordChanged(user));
        // Keep the current user data intact
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('Failed to change password',user));
      }
    } catch (e) {
      emit(ProfileError('Error changing password: ${e.toString()}',user));
    }
  }
}
