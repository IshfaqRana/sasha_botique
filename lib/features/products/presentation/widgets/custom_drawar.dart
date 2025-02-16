import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../auth/presentation/pages/login.dart';
import '../../../theme/presentation/theme/theme_helper.dart';
import 'drawar_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      // backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'jenny',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'jenny@gmail.com',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              DrawerItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Orders',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.favorite_border,
                title: 'Wishlist',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                onTap: () {},
              ),
              DrawerItem(
                icon: Icons.payment,
                title: 'Payment Methods',
                onTap: () {},
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
             if(state is Unauthenticated){
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
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) =>  LoginScreen()),(Route<dynamic> route) => false);
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
