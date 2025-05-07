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
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        phone TEXT,
        email TEXT,
        address TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertCustomer(Customer customer) async {
    final dbClient = await db;
    return await dbClient.insert('customers', customer.toMap());
  }

  Future<List<Customer>> fetchCustomers() async {
    final dbClient = await db;
    final maps = await dbClient.query('customers');
    return maps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'customers',
      where: 'fullName LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((e) => Customer.fromMap(e)).toList();
  }
}
