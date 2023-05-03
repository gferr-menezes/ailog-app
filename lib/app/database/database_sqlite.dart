import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSQLite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'ailog.db');

    return await openDatabase(
      databaseFinalPath,
      version: 1,
      onCreate: (Database db, int version) async {
        log('Criando banco de dados versão $version');

        final batch = db.batch();
        batch.execute('''
          CREATE TABLE travel (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plate VARCHAR(50) NOT NULL,
            status VARCHAR(100) NOT NULL,
            date_init_travel DATE_TIME NOT NULL,
            status_travel VARCHAR(100),
            emissor VARCHAR(100),
            valor_total FLOAT,
            travel_id INTEGER
          )
        ''');

        batch.execute('''
            CREATE TABLE geolocation (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              travel_id INTEGER NOT NULL,
              latitude VARCHAR(50) NOT NULL,
              longitude VARCHAR(100) NOT NULL,
              collection_date DATE_TIME NOT NULL,
              status_send VARCHAR(100)
            )
          ''');

        batch.execute('''
            CREATE TABLE IF NOT EXISTS tolls (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              travel_id INTEGER NOT NULL,
              pass_order INTEGER NOT NULL,
              tolls_code INTEGER NOT NULL,
              tolls_name VARCHAR(100) NOT NULL,
              concessionaire VARCHAR(255),
              highway VARCHAR(255),
              value FLOAT NOT NULL,
              date_time_pasage DATE_TIME
            )
          ''');

        batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
  }
}
