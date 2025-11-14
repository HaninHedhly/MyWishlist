import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Ouvrir ou créer la base
  static Future<Database> openDB() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), "contacts.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            email TEXT
          )
        """);
      },
    );

    return _db!;
  }

  // Ajouter un contact
  static Future<int> insertContact(String name, String phone, String email) async {
    final db = await openDB();
    return await db.insert("contacts", {
      "name": name,
      "phone": phone,
      "email": email,
    });
  }

  // Récupérer tous les contacts
  static Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await openDB();
    return await db.query("contacts");
  }
}
