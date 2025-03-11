part of 'user_address_bloc.dart';
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}
class GetAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final UserAddress address;

  const AddAddressEvent({required this.address});

  @override
  List<Object> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final String id;
  final UserAddress address;

  const UpdateAddressEvent({required this.address,required this.id});

  @override
  List<Object> get props => [address];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String id;
  final UserAddress address;

  const SetDefaultAddressEvent({required this.address,required this.id});

  @override
  List<Object> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;

  const DeleteAddressEvent({required this.id});

  @override
  List<Object> get props => [id];
}