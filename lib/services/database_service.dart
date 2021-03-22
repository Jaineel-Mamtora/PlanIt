import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import 'package:plan_it/locator.dart';
import 'package:plan_it/constants.dart';
import 'package:plan_it/models/task.dart';

class DatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  Database _database;

  Future initialize() async {
    _database = await openDatabase(DatabaseConstants.DB_NAME, version: 1);
    await _migrationService.runMigration(
      _database,
      migrationFiles: ['1_create_schema.sql'],
      verbose: true,
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return _database.insert(DatabaseConstants.TABLE_NAME, row);
  }

  Future<List<Task>> queryAll() async {
    var allTasks = <Task>[];
    var allDbTasks = await _database.query(DatabaseConstants.TABLE_NAME);
    allDbTasks.forEach((task) {
      allTasks.add(Task.fromJson(task));
    });
    return allTasks;
  }

  Future<List<Task>> queryPendingTask(int selectedDate) async {
    var allPendingTasks = <Task>[];
    var allPendingDbTasks = await _database.query(
      DatabaseConstants.TABLE_NAME,
      where:
          '${DatabaseConstants.STATUS} = ? AND ${DatabaseConstants.DATE} = ?',
      whereArgs: [0, selectedDate],
    );
    allPendingDbTasks.forEach((pendingTask) {
      allPendingTasks.add(Task.fromJson(pendingTask));
    });
    return allPendingTasks;
  }

  Future<List<Task>> queryCompletedTask(int selectedDate) async {
    var allCompletedTasks = <Task>[];
    var allCompletedDbTasks = await _database.query(
      DatabaseConstants.TABLE_NAME,
      where:
          '${DatabaseConstants.STATUS} = ? AND ${DatabaseConstants.DATE} = ?',
      whereArgs: [1, selectedDate],
    );
    allCompletedDbTasks.forEach((completedTask) {
      allCompletedTasks.add(Task.fromJson(completedTask));
    });
    return allCompletedTasks;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int updateId = row[DatabaseConstants.ID];
    return _database.update(
      DatabaseConstants.TABLE_NAME,
      row,
      where: '${DatabaseConstants.ID} = ?',
      whereArgs: [updateId],
    );
  }

  Future<int> delete(int deleteId) async {
    var allTasks = await queryAll();
    allTasks.removeWhere((element) {
      return element.id == deleteId;
    });
    return _database.delete(
      DatabaseConstants.TABLE_NAME,
      where: '${DatabaseConstants.ID} = ?',
      whereArgs: [deleteId],
    );
  }
}
