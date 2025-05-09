import 'package:customer_management_app/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Customer Management App',
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
