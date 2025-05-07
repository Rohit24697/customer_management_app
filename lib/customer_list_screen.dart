import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/customer_controller.dart';
import 'customer_search.dart';
import 'models/customer.dart';
import 'profile_page.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final controller = Get.put(CustomerController());
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    controller.fetchPaginatedCustomers(_page, _pageSize);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    _page++;
    await controller.fetchPaginatedCustomers(_page, _pageSize);
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        final customers = controller.customerList;
        if (customers.isEmpty) {
          return const Center(child: Text("No customers found"));
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: customers.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= customers.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final customer = customers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 2,
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
