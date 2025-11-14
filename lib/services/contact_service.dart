import '../models/contact.dart';
import 'database_helper.dart';

class ContactService {
  final dbHelper = DatabaseHelper();

  // Ajouter un contact
  Future<int> addContact(Contact contact) async {
    final db = await dbHelper.database;
    return await db.insert('contacts', contact.toMap());
  }

  // Récupérer tous les contacts
  Future<List<Contact>> getContacts() async {
    final db = await dbHelper.database;
    final res = await db.query('contacts');
    return res.map((c) => Contact.fromMap(c)).toList();
  }

  // Modifier un contact
  Future<int> updateContact(Contact contact) async {
    final db = await dbHelper.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Supprimer
  Future<int> deleteContact(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
