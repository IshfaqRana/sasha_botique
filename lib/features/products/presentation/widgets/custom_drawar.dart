import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sasha_botique/shared/widgets/cache_image.dart';
import 'package:sasha_botique/shared/widgets/cached_network_image.dart';

import '../../../auth/presentation/pages/login.dart';
import '../../../cart/presentation/pages/order_screen.dart';
import '../../../profile/domain/entities/user.dart';
import '../../../profile/presentation/bloc/user_profile/user_profile_bloc.dart';
import '../../../profile/presentation/pages/payment_methods_screen.dart';
import '../../../profile/presentation/pages/user_address_screen.dart';
import '../../../profile/presentation/pages/user_profile_screen.dart';
import '../../../theme/presentation/theme/theme_helper.dart';
import '../pages/favourite_products_screen.dart';
import 'drawar_item.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
 late final ProfileBloc profileBloc;

  String name = "John";

  String email = "abc@gmail.com";

  String link =
      "https://img.freepik.com/premium-vector/vector-flat-illustration-grayscale-avatar-user-profile-person-icon-profile-picture-business-profile-woman-suitable-social-media-profiles-icons-screensavers-as-templatex9_719432-1328.jpg?semt=ais_hybrid";

  String imageURL = "";
  @override
  void initState() {
    profileBloc = getIt<ProfileBloc>();
    imageURL = link;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: appGradientColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileScreen()));
                    //ProfileScreen
                  },
                  child: BlocConsumer<ProfileBloc, ProfileState>(
                    bloc: profileBloc,
                    listener: (context, state) {
                      // User user=  profileBloc.user;

                        // name = state.user.firstName + state.user.lastName;
                        // email = state.user.email;
                        // imageURL = state.user.profileImageUrl ?? link;

                    }, builder: (context, state) {
                    return  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber,
                                width: 3.0,
                              ),
                            ),
                            child: ClipOval(
                              child:
                              // state.user.profileImageUrl != null
                              //     ?
                              CustomCachedNetworkShimmer(
                                imageUrl: state.user.profileImageUrl ?? link,
                                // fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              )
                              //     : Icon(
                              //   Icons.person,
                              //   size: 60,
                              //   color: Colors.grey,
                              // ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${state.user.firstName} ${state.user.lastName}",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  state.user.email,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white70,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Icon(
                              Icon(Icons.edit, color: Colors.white),

                          // ),
                        ],
                      ),
                    );
  },
),),

              const Divider(color: Colors.white24),
              DrawerItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Orders',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => OrderScreen()));

                },
              ),
              DrawerItem(
                icon: Icons.favorite_border,
                title: 'Wishlist',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => FavouriteProductsScreen()));

                },
              ),
              DrawerItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => AddressScreen()));

                },
              ),
              DrawerItem(
                icon: Icons.payment,
                title: 'Payment Methods',
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => UserPaymentMethods()));

                },
              ),
              DrawerItem(
                icon: Icons.local_offer_outlined,
                title: 'Promo Code',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.notifications_none,
                title: 'Notifications',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),
              const Spacer(),
              BlocListener<AuthBloc, AuthState>(
                bloc: getIt<AuthBloc>(),
                listener: (context, state) {
                  print(state);
                  if (state is Unauthenticated) {
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DrawerItem(
                    icon: Icons.logout,
                    title: 'LOG OUT',
                    onTap: () {
                      getIt<AuthBloc>().add(LogoutEvent());
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
