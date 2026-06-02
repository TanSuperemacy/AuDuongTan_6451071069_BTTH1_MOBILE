import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jobspot_profile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    // Create Profile table
    await db.execute('''
      CREATE TABLE profile (
        id $idType,
        name $textType,
        email $textType,
        location $textType,
        avatar $textType,
        followers $textType,
        following $textType,
        about_me $textType
      )
    ''');

    // Create Work Experience table
    await db.execute('''
      CREATE TABLE work_experience (
        id $idType,
        role $textType,
        company $textType,
        start_date $textType,
        end_date $textType,
        duration $textType
      )
    ''');

    // Create Education table
    await db.execute('''
      CREATE TABLE education (
        id $idType,
        field $textType,
        school $textType,
        start_date $textType,
        end_date $textType,
        duration $textType
      )
    ''');

    // Create Skills table
    await db.execute('''
      CREATE TABLE skills (
        id $idType,
        name $textType UNIQUE
      )
    ''');

    // Create Languages table
    await db.execute('''
      CREATE TABLE languages (
        id $idType,
        name $textType UNIQUE
      )
    ''');

    // Create Appreciation table
    await db.execute('''
      CREATE TABLE appreciation (
        id $idType,
        title $textType,
        award $textType,
        year $textType
      )
    ''');

    // Seed mock database records
    await _seedMockData(db);
  }

  Future<void> _seedMockData(Database db) async {
    // 1. Seed Profile
    await db.insert('profile', {
      'id': 1,
      'name': 'Nguyễn Văn A',
      'email': 'fithou@agent.etc.vn',
      'location': 'California, USA',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
      'followers': '120k',
      'following': '23k',
      'about_me': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus id commodo egestas metus interdum dolor. Ut cursus pulvinar elementum placerat.',
    });

    // 2. Seed Work Experience
    await db.insert('work_experience', {
      'role': 'Manager',
      'company': 'Amazon Inc',
      'start_date': 'Jan 2015',
      'end_date': 'Feb 2022',
      'duration': '7 years',
    });

    // 3. Seed Education
    await db.insert('education', {
      'field': 'Information Technology',
      'school': 'University of Oxford',
      'start_date': 'Sep 2013',
      'end_date': 'Aug 2015',
      'duration': '2 years',
    });

    // 4. Seed Skills
    final sampleSkills = ['Leadership', 'Teamwork', 'Visioner', 'Target oriented', 'Consistent'];
    for (var skill in sampleSkills) {
      await db.insert('skills', {'name': skill});
    }

    // 5. Seed Languages
    final sampleLanguages = ['English', 'German', 'Spanish', 'Mandarin', 'Italy'];
    for (var lang in sampleLanguages) {
      await db.insert('languages', {'name': lang});
    }

    // 6. Seed Appreciation
    await db.insert('appreciation', {
      'title': 'Wireless Symposium (RWS)',
      'award': 'Young Scientist',
      'year': '2014',
    });
  }

  // --- CRUD Operations for Profile ---

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await instance.database;
    final maps = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateProfile(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'profile',
      row,
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // --- CRUD Operations for Work Experience ---

  Future<List<Map<String, dynamic>>> getWorkExperiences() async {
    final db = await instance.database;
    return await db.query('work_experience', orderBy: 'id DESC');
  }

  Future<int> addWorkExperience(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('work_experience', row);
  }

  Future<int> updateWorkExperience(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'work_experience',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWorkExperience(int id) async {
    final db = await instance.database;
    return await db.delete(
      'work_experience',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD Operations for Education ---

  Future<List<Map<String, dynamic>>> getEducations() async {
    final db = await instance.database;
    return await db.query('education', orderBy: 'id DESC');
  }

  Future<int> addEducation(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('education', row);
  }

  Future<int> updateEducation(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'education',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEducation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'education',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD Operations for Skills ---

  Future<List<Map<String, dynamic>>> getSkills() async {
    final db = await instance.database;
    return await db.query('skills', orderBy: 'id ASC');
  }

  Future<int> addSkill(String name) async {
    final db = await instance.database;
    return await db.insert(
      'skills', 
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> deleteSkill(int id) async {
    final db = await instance.database;
    return await db.delete(
      'skills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD Operations for Languages ---

  Future<List<Map<String, dynamic>>> getLanguages() async {
    final db = await instance.database;
    return await db.query('languages', orderBy: 'id ASC');
  }

  Future<int> addLanguage(String name) async {
    final db = await instance.database;
    return await db.insert(
      'languages', 
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> deleteLanguage(int id) async {
    final db = await instance.database;
    return await db.delete(
      'languages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD Operations for Appreciation ---

  Future<List<Map<String, dynamic>>> getAppreciations() async {
    final db = await instance.database;
    return await db.query('appreciation', orderBy: 'id DESC');
  }

  Future<int> addAppreciation(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('appreciation', row);
  }

  Future<int> updateAppreciation(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'appreciation',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAppreciation(int id) async {
    final db = await instance.database;
    return await db.delete(
      'appreciation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
