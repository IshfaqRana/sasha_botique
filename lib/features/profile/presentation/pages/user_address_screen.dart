// lib/features/address/presentation/pages/address_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/shared/widgets/loading_overlay.dart';
import '../../domain/entities/user_address.dart';
import '../bloc/user_address/user_address_bloc.dart';
import '../widgets/address_bottom_sheet.dart';
import '../widgets/address_item.dart';


class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late final AddressBloc addressBloc;
  bool isLoading = false;
  bool initialLoading = true;


  @override
  void initState() {
    super.initState();
    addressBloc = getIt<AddressBloc>();

    // addressBloc.add(GetAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      bloc: addressBloc,
      listener: (context, state){
        // if (state is AddressLoading ) {
        //   setState(() {
        //     isLoading = true;
        //   });
        // }
        // if(state is AddressLoading){
        //   setState(() {
        //     isLoading =false;
        //   });
        // }
        if(initialLoading) {
          if (state is AddressesLoaded) {
            addressBloc.add(GetAddressesEvent());
          }
          if (state is AddressError || state is AddressInitial) {
            addressBloc.add(GetAddressesEvent());
          }
          setState(() {
            initialLoading = false;
          });
        }
      },
      builder: (context, state) {

        List<UserAddress> addresses = state.addressList;

        return LoadingOverlay(
      isLoading: state is AddressLoading,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.black,
          // foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Delivery Addresses',style: context.titleMedium,),
        ),
        body:
            // if (state is AddressLoading) {
            //   return const Center(child: CircularProgressIndicator(color: Colors.blue));
            // } else
            //   if (state is AddressError) {
            //   return Center(child: Padding(
            //     padding: const EdgeInsets.all(32.0),
            //     child: Text(state.message),
            //   ));
            // } else
            //   if (state is AddressesLoaded) {
               addresses.isEmpty ? const Center(child: Text('No addresses found')): _buildAddressList(context, addresses),
            // }
            // return const Center(child: Text('No addresses found'));

        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _showAddressBottomSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20.0),
              // ),
            ),
            child: const Text(
              'ADD ADDRESSES',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildAddressList(BuildContext context, List<UserAddress> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: addresses.length,
      itemBuilder: (context, index) => AddressListItem(
        address: addresses[index],
        onEdit: () => _showAddressBottomSheet(context, addresses[index],index),
        onDelete: () => _confirmDeleteAddress(context, index.toString()),

        onSetDefault: () {
          UserAddress userAddress = addresses[index];
          bool defaultVal  = userAddress.isDefault ?? false;
          UserAddress updated = UserAddress(state: userAddress.state,street: userAddress.street,city: userAddress.city,country: userAddress.country,postalCode: userAddress.postalCode,isDefault: !defaultVal);
          addressBloc.add(
          SetDefaultAddressEvent(address: updated, id: index.toString()));
    },
        ),
      );

  }

  void _showAddressBottomSheet(BuildContext context, [UserAddress? address, int id = 0]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressFormBottomSheet(
        existingAddress: address,
        onSubmit: (UserAddress newAddress) {
          if (address == null) {
            addressBloc.add(AddAddressEvent(address: newAddress));
          } else {
            addressBloc.add(UpdateAddressEvent(id: id.toString(),address: newAddress));
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDeleteAddress(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              addressBloc.add(DeleteAddressEvent(id: id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}