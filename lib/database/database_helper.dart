import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'customers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        imagePath TEXT NOT NULL
      )
    ''');
  }

  // Insert new customer
  Future<int> insertCustomer(Customer customer) async {
    try {
      final dbClient = await db;
      return await dbClient.insert('customers', customer.toMap());
    } catch (e) {
      print("Insert Error: $e");
      return -1;
    }
  }

  // Fetch all customers
  Future<List<Customer>> fetchCustomers() async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query('customers');
      return maps.map((map) => Customer.fromMap(map)).toList();
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  // Search customers by name or phone
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'customers',
        where: 'fullName LIKE ? OR phone LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return maps.map((map) => Customer.fromMap(map)).toList();
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }

  // Update existing customer
  Future<int> updateCustomer(Customer customer) async {
    try {
      final dbClient = await db;
      return await dbClient.update(
        'customers',
        customer.toMap(),
        where: 'id = ?',
        whereArgs: [customer.id],
      );
    } catch (e) {
      print("Update Error: $e");
      return -1;
    }
  }

  // Delete customer by ID
  Future<int> deleteCustomer(int id) async {
    try {
      final dbClient = await db;
      return await dbClient.delete(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Delete Error: $e");
      return -1;
    }
  }
}
