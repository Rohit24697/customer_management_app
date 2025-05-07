import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_page.dart';
import 'controllers/customer_controller.dart';


class CustomerListScreen extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers")),
    body: Obx(() =>ListView.builder(
        itemCount: controller.customerList.length,
        itemBuilder: (_, index) {
          final customer = controller.customerList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(File(customer.imagePath)),
            ),
            title: Text(customer.fullName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.phone),
                Text(customer.address),
              ],
            ),
          );
        },
      ),
    ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
