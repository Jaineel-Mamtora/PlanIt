import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import 'package:PlanIt/locator.dart';
import 'package:PlanIt/models/task.dart';

const String DB_NAME = 'plan_it.sqlite';
const String TABLE_NAME = 'plan_it';

const String id = '_id';
const String title = 'title';
const String fromTime = 'from_time';
const String date = 'date';
const String toTime = 'to_time';
const String reminder = 'reminder';
const String priority = 'priority';
const String status = 'status';

class DatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  Database _database;

  Future initialize() async {
    _database = await openDatabase(DB_NAME, version: 1);
    await _migrationService.runMigration(
      _database,
      migrationFiles: ['1_create_schema.sql'],
      verbose: true,
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return _database.insert(TABLE_NAME, row);
  }

  Future<List<Task>> queryAll() async {
    var allTasks = <Task>[];
    var allDbTasks = await _database.query(TABLE_NAME);
    allDbTasks.forEach((task) {
      allTasks.add(Task.fromJson(task));
    });
    return allTasks;
  }

  Future<List<Task>> queryPendingTask(int selectedDate) async {
    var allPendingTasks = <Task>[];
    var allPendingDbTasks = await _database.query(
      TABLE_NAME,
      where: '$status = ? AND $date = ?',
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
      TABLE_NAME,
      where: '$status = ? AND $date = ?',
      whereArgs: [1, selectedDate],
    );
    allCompletedDbTasks.forEach((completedTask) {
      allCompletedTasks.add(Task.fromJson(completedTask));
    });
    return allCompletedTasks;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int updateId = row[id];
    return _database.update(
      TABLE_NAME,
      row,
      where: '$id = ?',
      whereArgs: [updateId],
    );
  }

  Future<int> delete(int deleteId) async {
    var allTasks = await queryAll();
    allTasks.removeWhere((element) {
      return element.id == deleteId;
    });
    return _database.delete(
      TABLE_NAME,
      where: '$id = ?',
      whereArgs: [deleteId],
    );
  }
}
