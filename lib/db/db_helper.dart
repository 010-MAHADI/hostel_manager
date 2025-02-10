import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/market.dart';

class DBHelper {
  static const _databaseName = "hostel_manager.db";
  static const _databaseVersion = 1;

  static const tableMember = 'members';
  static const tableMeals = 'meals';
  static const tableMarket = 'market';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableMember(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        balance REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMeals(
        id INTEGER PRIMARY KEY,
        member_id INTEGER,
        date TEXT,
        breakfast INTEGER DEFAULT 0,
        lunch INTEGER DEFAULT 0,
        dinner INTEGER DEFAULT 0,
        FOREIGN KEY (member_id) REFERENCES $tableMember(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMarket(
        id INTEGER PRIMARY KEY,
        item TEXT,
        amount REAL,
        date TEXT
      )
    ''');
  }

  // Member CRUD operations
  Future<int> insertMember(Member member) async {
    final db = await database;
    return await db.insert(tableMember, member.toMap());
  }

  Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableMember);
    return List.generate(maps.length, (i) {
      return Member.fromMap(maps[i]);
    });
  }

  // Meal CRUD operations
  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    return await db.insert(tableMeals, meal.toMap());
  }

  Future<List<Meal>> getMeals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableMeals);
    return List.generate(maps.length, (i) {
      return Meal.fromMap(maps[i]);
    });
  }

  // Market CRUD operations
  Future<int> insertMarket(Market market) async {
    final db = await database;
    return await db.insert(tableMarket, market.toMap());
  }

  Future<List<Market>> getMarketItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableMarket);
    return List.generate(maps.length, (i) {
      return Market.fromMap(maps[i]);
    });
  }

  // Update member balance
  Future<int> updateMemberBalance(int id, double balance) async {
    final db = await database;
    return await db.update(tableMember, {'balance': balance},
        where: 'id = ?', whereArgs: [id]);
  }
}
