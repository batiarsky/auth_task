import 'file:///D:/FlutterProjects/auth_task/lib/model/user_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider _db = DBProvider._();

  factory DBProvider() => _db;

  Database _database;

  static const String _userTable = 'User';
  static const String _columnEmail = 'Email';
  static const String _columnPassword = 'Password';
  static const String _columnToken = 'Token';
  static const String _columnDuration = 'Duration';
  static const String _isRememberedCredentials = 'isRememberedCredentials';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'User.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(final Database db, final int version) async {
    await db.execute(
      'CREATE TABLE $_userTable($_columnEmail TEXT PRIMARY KEY, $_columnPassword TEXT, $_columnToken TEXT, $_columnDuration TEXT, $_isRememberedCredentials INTEGER)',
    );
  }

  Future<UserEntity> insertUser(final UserEntity user) async {
    final Database db = await this.database;
    try {
      await db.insert(
        _userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> deleteUser(final String email) async {
    final Database db = await this.database;
    try {
      final deletedRow = await db.delete(
        _userTable,
        where: '$_columnEmail = ?',
        whereArgs: [email],
      );
      return deletedRow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserEntity> getUser() async {
    final Database db = await this.database;
    final List<Map<String, dynamic>> usersMap = await db.query(_userTable);
    if(usersMap.isNotEmpty) {
      final userMap = usersMap[0];
      return UserEntity(
          email: userMap['Email'],
          password: userMap['Password'],
          token: userMap['Token'],
          duration: int.parse(userMap['Duration']),
          isRememberedCredentials: userMap['isRememberedCredentials'] == 1);
    } else {
      return UserEntity(
          email: "",
          password: "",
          token: "",
          duration: 0,
          isRememberedCredentials: false);
    }
  }

  Future<int> updateUser(final UserEntity user) async{
    final Database db = await this.database;
    user.token = '';
    return await db.update(_userTable,
      user.toMap(),
      where: '$_columnEmail = ?',
      whereArgs: [user.email],
    );
  }
}
