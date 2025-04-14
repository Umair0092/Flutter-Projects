import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/fireStore_db.dart';
class NotesDB{
  static final NotesDB instance=NotesDB._init();
  static Database? _db;
  NotesDB._init();
  Future<Database?> get database async{
    if(_db!=null) return _db;
    _db = await _inializeDb("Notes1.db");
    return _db;
  }
  Future<Database > _inializeDb(String file) async{
    final dbpath= await getDatabasesPath();
    final path=join(dbpath,file);
    return openDatabase(path,version: 2,onCreate: _createDb);
  }

  Future close() async {
    final db = await database;
    db!.close();
  }

  Future<void> clearDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes1.db');
    await NotesDB.instance.close(); // Close any open connections
    await deleteDatabase(path); // Delete the database file
    _db = null; // Reset the instance
  }

  Future _createDb(Database db,int version)async{
    final idType="INTEGER PRIMARY KEY AUTOINCREMENT";
    final pinType="BOOLEAN NOT NULL";
    final text="TEXT NOT NULL";
    final boolType = "INTEGER NOT NULL DEFAULT 0"; // For isArchived
    await db.execute('''
    CREATE TABLE ${NotesImpNames.tablename}(
    ${NotesImpNames.id} ${idType},
    ${NotesImpNames.pin} ${pinType},
    ${NotesImpNames.title} ${text},
    ${NotesImpNames.uniqueID} ${text},
    ${NotesImpNames.content} ${text},
    ${NotesImpNames.createdTime} ${text},
    ${NotesImpNames.isArchived} ${boolType}
)
    ''');
  }
  Future< Note?> create(Note note)async{
    await Firedb().createNewNote(note);
    final db=await instance.database;
    final id= await db?.insert(NotesImpNames.tablename, note.tojason());
    print(id);
    return note.copy(id: id);
  }

  Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) return ReadAll(); // Return all notes if query is empty
    final db=await instance.database;
    final orderBy = "${NotesImpNames.createdTime} ASC";
    final queryResult = await db!.query(
      NotesImpNames.tablename,
      where: "${NotesImpNames.title} LIKE ? OR ${NotesImpNames.content} LIKE ?",
      whereArgs: ["%$query%", "%$query%"],
      orderBy: orderBy,
    );
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> ReadAll() async {
    final db = await database;
    final orderBy = "${NotesImpNames.createdTime} ASC";
    final queryResult = await db!.query(
      NotesImpNames.tablename,
      where: "${NotesImpNames.isArchived} = 0 AND ${NotesImpNames.pin} = 0", // Non-archived and unpinned
      orderBy: orderBy,
    );

    // Optional: Print the results for debugging
    print("Query results (non-archived, unpinned): $queryResult");

    return queryResult.map((toElement) => Note.fromJson(toElement)).toList();
  }

  Future<List<Note>> readArchived() async {
    final db = await database;
    final orderBy = "${NotesImpNames.createdTime} ASC";
    final queryResult = await db!.query(
      NotesImpNames.tablename,
      where: "${NotesImpNames.isArchived} = ?",
      whereArgs: [1], // 1 represents true
      orderBy: orderBy,
    );
    print("Query results (archived): $queryResult");
    return queryResult.map((toElement) => Note.fromJson(toElement)).toList();
  }

  Future<List<Note>> readPinned() async {
    final db = await database;
    final orderBy = "${NotesImpNames.createdTime} ASC";
    final queryResult = await db!.query(
      NotesImpNames.tablename,
      where: "${NotesImpNames.pin} = 1", // Only pinned notes
      orderBy: orderBy,
    );

    // Optional: Print the results for debugging
    print("Query results (pinned): $queryResult");

    return queryResult.map((toElement) => Note.fromJson(toElement)).toList();
  }
  Future Update(Note note)async{
    await Firedb().updateNotes(note);
    final db=await instance.database;
    final id= await db?.update(NotesImpNames.tablename, note.tojason(),where: "${NotesImpNames.id} = ?",whereArgs: [note.id]);


  }

  Future PinNote(Note note)async{
    final db=await instance.database;
    final id= await db?.update(NotesImpNames.tablename,{NotesImpNames.pin:!note.pin ?1:0},where: "${NotesImpNames.id} = ?",whereArgs: [note.id]);


  }
  Future ArchiveNote(Note note)async{
    final db=await instance.database;
    final id= await db?.update(NotesImpNames.tablename,{NotesImpNames.isArchived:!note.isArchived ?1:0},where: "${NotesImpNames.id} = ?",whereArgs: [note.id]);


  }

  Future delete(Note note)async{
    await Firedb().deleteNotes(note);
    final db=await instance.database;
    final id= await db?.delete(NotesImpNames.tablename, where: "${NotesImpNames.id} = ?",whereArgs: [note.id]);


  }

  Future<void> migrateNotesTableToAddIsArchived() async {
    // Open the database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Notes1.db');
    final db = await openDatabase(
      path,
      version: 2, // Increment version to trigger migration
      onCreate: (db, version) async {
        // This won’t run since the table already exists
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the isArchived column with default value false (0 in SQLite)
          await db.execute('''
          ALTER TABLE ${NotesImpNames.tablename}
          ADD COLUMN ${NotesImpNames.isArchived} INTEGER NOT NULL DEFAULT 0
        ''');
          print("Added isArchived column to Notes table");
        }
      },
    );

    // Verify the change (optional)
    final result = await db.rawQuery('PRAGMA table_info(${NotesImpNames.tablename})');
    print("Updated table schema: $result");

    // Close the database
    await db.close();
  }


  Future<Note?> ReadOne(int id) async{
    final db=await instance.database;
    final qurey_result= await db!.query(NotesImpNames.tablename,columns:NotesImpNames.values,where: "${NotesImpNames.id} = ?",whereArgs: [id]);
    if(qurey_result.isNotEmpty){
      return Note.fromJson(qurey_result.first);
    }
    else
      return null;
  }

  Future CloseDB()async{
    final db=await instance.database;
    db!.close();


  }
  Future<Note?> getNoteByUniqueID(String uniqueID) async {
    final db = await database;
    final maps = await db!.query(
      NotesImpNames.tablename,
      where: 'uniqueID = ?',
      whereArgs: [uniqueID],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Note(
        title: maps.first['title'] as String,
        uniqueID: maps.first['uniqueID'] as String,
        content: maps.first['content'] as String,
        pin: (maps.first['pin'] as int) == 1,
        createdTime: DateTime.parse(maps.first['createdTime'] as String),
        isArchived: (maps.first['isArchived'] as int) == 1,
      );
    }
    return null; // Return null if no note is found
  }


}