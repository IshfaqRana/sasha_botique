part of 'user_address_bloc.dart';

abstract class AddressState extends Equatable {
  final List<UserAddress> addressList;
  AddressState(this.addressList);

  @override
  List<Object> get props => [addressList];
}

class AddressInitial extends AddressState {
  AddressInitial(super.addressList);
}

class AddressLoading extends AddressState {
  AddressLoading(super.addressList);
}

class AddressesLoaded extends AddressState {
  final List<UserAddress> addresses;

   AddressesLoaded(super.addressList,  {required this.addresses,});

  @override
  List<Object> get props => [addresses,addressList];
}

class AddressError extends AddressState {
  final String message;

  AddressError(super.addressList, {required this.message});

  @override
  List<Object> get props => [message,addressList];
}