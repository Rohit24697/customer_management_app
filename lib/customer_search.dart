import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'controllers/customer_controller.dart';

class CustomerSearch extends SearchDelegate {
  final CustomerController controller;

  CustomerSearch(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        controller.fetchCustomers(); // Reset list on clear
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    controller.searchCustomer(query);
    return Obx(() {
      final results = controller.customerList;
      if (results.isEmpty) {
        return const Center(child: Text("No results found."));
      }
      return ListView.builder(
        itemCount: results.length,
        itemBuilder: (_, index) {
          final customer = results[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: customer.imagePath.isNotEmpty
                    ? FileImage(File(customer.imagePath))
                    : null,
                child: customer.imagePath.isEmpty ? Icon(Icons.person) : null,
              ),
              title: Text(customer.fullName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone: ${customer.phone}"),
                  Text("Email: ${customer.email}"),
                  Text("Address: ${customer.address}"),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchCustomer(query);
    return Obx(() {
      final suggestions = controller.customerList;
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (_, index) {
          final customer = suggestions[index];
          return ListTile(
            title: Text(customer.fullName),
            subtitle: Text(customer.phone),
            onTap: () {
              query = customer.fullName;
              showResults(context);
            },
          );
        },
      );
    });
  }
}
