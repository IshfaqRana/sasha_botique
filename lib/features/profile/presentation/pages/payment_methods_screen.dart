import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';

class UserPaymentMethods extends StatefulWidget {
  const UserPaymentMethods({super.key});

  @override
  State<UserPaymentMethods> createState() => _UserPaymentMethodsState();
}

class _UserPaymentMethodsState extends State<UserPaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Payment Methods',style: context.titleMedium,),), body: const Center(child: Text('In Progress'),));
  }
}
