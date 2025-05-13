import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class ContactRepo {
  static final ContactRepo instance = ContactRepo._init();

  static Database? _database;

  ContactRepo._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        email TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE deleted_numbers (
      phoneNumber TEXT PRIMARY KEY
    )
  ''');
  }

  Future<Contact> createContact(Contact contact) async {
    final db = await instance.database;
    final id = await db.insert('contacts', contact.toMap());
    return contact.copy(id: id);
  }

  Future<Contact?> getContact(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'contacts',
      columns: [
        'id',
        'firstName',
        'lastName',
        'phoneNumber',
        'email',
        'address',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    final contact = await getContact(id);
    if (contact != null) {
      await db.insert('deleted_numbers', {
        'phoneNumber': contact.phoneNumber,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension ContactCopy on Contact {
  Contact copy({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? address,
  }) => Contact(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    address: address ?? this.address,
  );
}
