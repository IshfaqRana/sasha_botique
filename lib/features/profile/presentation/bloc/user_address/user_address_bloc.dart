import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sasha_botique/features/profile/domain/usecases/add_user_address.dart';
import 'package:sasha_botique/features/profile/domain/usecases/update_user_address.dart';

import '../../../../../core/network/network_exceptions.dart';
import '../../../domain/entities/user_address.dart';
import '../../../domain/usecases/delete_user_address.dart';
import '../../../domain/usecases/get_user_address.dart';
import '../../../domain/usecases/set_default_user_address.dart';

part 'user_address_event.dart';
part 'user_address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetUserAddress getAddresses;
  final AddUserAddress addAddress;
  final UpdateUserAddress updateAddress;
  final SetDefaultAddress setDefaultAddress;
  final DeleteUserAddress deleteAddress;
  List<UserAddress> addressList = [];

  AddressBloc({
    required this.getAddresses,
    required this.addAddress,
    required this.updateAddress,
    required this.setDefaultAddress,
    required this.deleteAddress,
  }) : super(AddressInitial([])) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
  }

  Future<void> _onGetAddresses(
      GetAddressesEvent event,
      Emitter<AddressState> emit,
      ) async {
    emit(AddressLoading(addressList));
    try{
    final result = await getAddresses();
    addressList = result;
    emit(AddressesLoaded( addresses: result,addressList ));
    } catch (e) {
      emit(AddressError(message: 'Failed to load profile: ${_mapFailureToMessage(e)}',addressList));
    }
  }

  Future<void> _onAddAddress(
      AddAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    emit(AddressLoading(addressList));
    try{
    final result = await addAddress(event.address);
    addressList = result;
    emit(AddressesLoaded( addresses: result,addressList));
    } catch (e) {
      emit(AddressError(message: 'Failed to add profile: ${_mapFailureToMessage(e)}',addressList));
    }
  }

  Future<void> _onUpdateAddress(
      UpdateAddressEvent event,
      Emitter<AddressState> emit,
      ) async {

    emit(AddressLoading(addressList));
    try{
    final result = await updateAddress(event.id, event.address);

    // print('AddressBloc._onSetDefaultAddress: Before Updating at ${event.id} >>>>>>>>>');
    int index = int.parse(event.id);

    addressList.removeAt(index);
    addressList.insert(index, result.first);

    emit(AddressesLoaded( addresses: result,addressList));
    } catch (e) {
      emit(AddressError(message: 'Failed to update profile: ${_mapFailureToMessage(e)}',addressList));
    }
  }

  Future<void> _onSetDefaultAddress(
      SetDefaultAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    emit(AddressLoading(addressList));
    try{
    final result = await setDefaultAddress(event.id,event.address);
    // print('AddressBloc._onSetDefaultAddress: Before Updating at ${event.id} >>>>>>>>>');
    //   addressList.forEach((item) {
    //   // print(item.country);
    //   print(item.city);
    //   print(item.isDefault);
    // });
    int index = int.parse(event.id);
    addressList.removeAt(index);
    addressList.insert(index, result.first);
    // print('AddressBloc._onSetDefaultAddress: After Updating at $index >>>>>>>>>');
    // addressList.forEach((item) {
    //   // print(item.country);
    //   print(item.city);
    //   print(item.isDefault);
    // });
    emit(AddressesLoaded( addresses: result,addressList));
    } catch (e) {
      emit(AddressError(message: 'Failed to update profile: ${_mapFailureToMessage(e)}',addressList));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    emit(AddressLoading(addressList));
    try{
    final result = await deleteAddress(event.id);
    addressList = result;
    emit(AddressesLoaded( addresses: result,addressList));
    } catch (e) {
      emit(AddressError(message: 'Failed to update profile: ${_mapFailureToMessage(e)}',addressList));
    }
  }

  String _mapFailureToMessage( exception) {
    switch (exception) {
      case NotFoundException _:
        return exception.message;
      case ServerException _:
        return 'Server Error: Please try again later';
      case NetworkException _:
        return 'Network Error: Please check your internet connection';
      case UnauthorizedException _:
        return exception.message;
      default:
        return exception?.toString() ?? 'Something went wrong. Please try again';
    }
  }
}