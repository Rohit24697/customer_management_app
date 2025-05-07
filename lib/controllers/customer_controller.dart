import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/customer.dart';

class CustomerController extends GetxController {
  var customerList = <Customer>[].obs;

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }

  Future<void> fetchCustomers() async {
    final data = await DatabaseHelper.instance.fetchCustomers();
    customerList.assignAll(data);
  }

  Future<void> addCustomer(Customer customer) async {
    await DatabaseHelper.instance.insertCustomer(customer);
    fetchCustomers();
  }

  Future<void> searchCustomer(String query) async {
    final result = await DatabaseHelper.instance.searchCustomers(query);
    customerList.assignAll(result);
  }
}
