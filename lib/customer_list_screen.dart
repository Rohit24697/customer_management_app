import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/customer_controller.dart';
import 'profile_page.dart';

class CustomerListScreen extends StatelessWidget {
  final controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer List"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: CustomerSearch(controller),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.customerList.isEmpty) {
          return const Center(child: Text("No customers found"));
        }
        return ListView.builder(
          itemCount: controller.customerList.length,
          itemBuilder: (context, index) {
            final customer = controller.customerList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: customer.imagePath.isNotEmpty
                    ? FileImage(File(customer.imagePath))
                    : null,
                child: customer.imagePath.isEmpty ? Icon(Icons.person) : null,
              ),
              title: Text(customer.fullName),
              subtitle: Text(customer.phone),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomerSearch extends SearchDelegate {
  final CustomerController controller;

  CustomerSearch(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
        onPressed: () {
          query = '';
          controller.fetchCustomers();
        },
        icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) {
    controller.searchCustomer(query);
    return Obx(() {
      if (controller.customerList.isEmpty) {
        return const Center(child: Text("No results"));
      }
      return ListView.builder(
        itemCount: controller.customerList.length,
        itemBuilder: (_, index) {
          final c = controller.customerList[index];
          return ListTile(
            title: Text(c.fullName),
            subtitle: Text(c.phone),
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
