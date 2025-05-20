part of 'user_profile_bloc.dart';

abstract class ProfileState {
  final User user;
  ProfileState(this.user);
}

class ProfileInitial extends ProfileState {
  ProfileInitial(super.user);
}

class ProfileLoading extends ProfileState {
  ProfileLoading(super.user);
}

class ProfileLoaded extends ProfileState {


  ProfileLoaded(super.user);
}
class DeleteUserSuccess extends ProfileState {


  DeleteUserSuccess(super.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message,super.user);
}

class ProfileUpdated extends ProfileState {
  ProfileUpdated(super.user);
}

class ProfilePictureUpdated extends ProfileState {
  ProfilePictureUpdated(super.user);

}

class PasswordChanged extends ProfileState {
  PasswordChanged(super.user);
}