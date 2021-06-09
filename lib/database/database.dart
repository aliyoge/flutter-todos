import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:todo_list/json/task_bean.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  PostgreSQLConnection _database;

  Future<PostgreSQLConnection> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<PostgreSQLConnection> initDB() async {
    var connection = PostgreSQLConnection(
        "47.102.41.197", 5433, "dbbd9aab2ead6f45f6aa28b25be882a465todos",
        username: "hwj", password: "rJ2Rgq8pnWfBu3");
    await connection.open();
    try {
      await connection.execute("""
        CREATE TABLE todolist (
                  id SERIAL PRIMARY KEY,
                  account TEXT,
                  taskName TEXT,
                  taskType TEXT,
                  taskStatus INTEGER,
                  taskDetailNum INTEGER,
                  uniqueId TEXT,
                  needUpdateToCloud TEXT,
                  overallProgress TEXT,
                  changeTimes INTEGER,
                  createDate TEXT,
                  finishDate TEXT,
                  startDate TEXT,
                  deadLine TEXT,
                  detailList TEXT,
                  taskIconBean TEXT,
                  textColor TEXT,
                  backgroundUrl TEXT);
        """);
    } catch (e) {
      print(e);
    }
    return connection;
  }

  ///创建一项任务
  Future createTask(TaskBean task) async {
    final db = await database;
    var sql = getInsertSql('todolist', task.toMap());
    await db.execute(sql, substitutionValues: task.toMap());
  }

  ///根据完成进度查询所有任务
  ///
  ///isDone为true表示查询已经完成的任务,否则表示未完成
  Future<List<TaskBean>> getTasks({bool isDone = false, String account}) async {
    final db = await database;
    var list = await db.mappedResultsQuery(isDone
        ? "SELECT * FROM todolist WHERE cast(overallProgress as float) >= 1.0"
        : "SELECT * FROM todolist WHERE cast(overallProgress as float) < 1.0");
    List<TaskBean> beans = [];
    beans.clear();
    var mapList = list.map((e) => e['todolist']).toList();
    beans.addAll(TaskBean.fromMapList(mapList));
    return beans;
  }

  ///查询所有任务
  Future<List<TaskBean>> getAllTasks({String account}) async {
    final db = await database;
    var list = await db.mappedResultsQuery("SELECT * FROM todolist");
    List<TaskBean> beans = [];
    beans.clear();
    beans
        .addAll(TaskBean.fromMapList(list..map((e) => e['todolist']).toList()));
    return beans;
  }

  Future updateTask(TaskBean taskBean) async {
    if (taskBean == null) return;
    final db = await database;
    var sql = getUpdateSql(
        'todolist',
        taskBean.toMap(),
        'WHERE id = '
            '${taskBean.id}');
    await db.execute(sql, substitutionValues: taskBean.toMap());
    debugPrint("升级当前task:${taskBean.toMap()}");
  }

  Future deleteTask(int id) async {
    final db = await database;
    db.execute("DELETE FROM todolist WHERE id = ${id}");
  }

  ///批量更新任务
  Future updateTasks(List<TaskBean> taskBeans) async {
    for (var task in taskBeans) {
      updateTask(task);
    }
  }

  ///批量创建任务
  Future createTasks(List<TaskBean> taskBeans) async {
    for (var task in taskBeans) {
      createTask(task);
    }
  }

  ///根据[uniqueId]查询一项任务
  Future<List<TaskBean>> getTaskByUniqueId(String uniqueId) async {
    final db = await database;
    var tasks = await db.mappedResultsQuery(
        "SELECT * FROM todolist WHERE uniqueId = ${uniqueId}");
    if (tasks.isEmpty) return null;
    return TaskBean.fromMapList(tasks[0]['todolist']);
  }

  ///批量更新账号
  Future updateAccount(String account) async {
    final tasks = await getAllTasks(account: "default");
    List<TaskBean> newTasks = [];
    for (var task in tasks) {
      if (task.account == "default") {
        task.account = account;
        newTasks.add(task);
      }
    }
    print("更新结果:$newTasks   原来:$tasks");
    updateTasks(newTasks);
  }

  ///通过加上百分号，进行模糊查询
  Future<List<TaskBean>> queryTask(String query) async {
    final db = await database;
    var list = await db.mappedResultsQuery(
        "SELECT * FROM todolist WHERE taskName LIKE '%${query}%' "
        "OR detailList LIKE '%${query}%' "
        "OR startDate LIKE '%${query}%' "
        "OR deadLine LIKE '%${query}%';");
    List<TaskBean> beans = [];
    beans.clear();
    var mapList = list.map((e) => e['todolist']).toList();
    beans.addAll(TaskBean.fromMapList(mapList));
    return beans;
  }

  String getUpdateSql(
      String table, Map<String, dynamic> values, String whereStr) {
    final update = StringBuffer();
    update.write('UPDATE ');
    update.write(_escapeName(table));
    update.write(' SET ');

    final size = (values != null) ? values.length : 0;

    if (size > 0) {
      var i = 0;
      values.forEach((String colName, dynamic value) {
        if (i++ > 0) {
          update.write(', ');
        }

        /// This should be just a column name
        update
            .write('${_escapeName(colName)} = ${PostgreSQLFormat.id(colName)}');
      });
    }
    update.write(' ${whereStr}');

    var sql = update.toString();
    return sql;
  }

  String getInsertSql(String table, Map<String, dynamic> values) {
    final insert = StringBuffer();
    insert.write('INSERT');
    insert.write(' INTO ');
    insert.write(_escapeName(table));
    insert.write(' (');

    final size = (values != null) ? values.length : 0;

    if (size > 0) {
      final sbValues = StringBuffer(') VALUES (');

      var i = 0;
      values.forEach((String colName, dynamic value) {
        if (i++ > 0) {
          insert.write(', ');
          sbValues.write(', ');
        }

        /// This should be just a column name
        insert.write(_escapeName(colName));
        sbValues.write(PostgreSQLFormat.id(colName));
      });
      insert.write(sbValues);
    }
    insert.write(')');

    var sql = insert.toString();
    return sql;
  }

  String _escapeName(String name) {
    if (name == null) {
      return name;
    }
    if (escapeNames.contains(name.toLowerCase())) {
      return _doEscape(name);
    }
    return name;
  }

  String _doEscape(String name) => '"$name"';

  final Set<String> escapeNames = <String>{
    'add',
    'all',
    'alter',
    'and',
    'as',
    'autoincrement',
    'between',
    'case',
    'check',
    'collate',
    'commit',
    'constraint',
    'create',
    'default',
    'deferrable',
    'delete',
    'distinct',
    'drop',
    'else',
    'escape',
    'except',
    'exists',
    'foreign',
    'from',
    'group',
    'having',
    'if',
    'in',
    'index',
    'insert',
    'intersect',
    'into',
    'is',
    'isnull',
    'join',
    'limit',
    'not',
    'notnull',
    'null',
    'on',
    'or',
    'order',
    'primary',
    'references',
    'select',
    'set',
    'table',
    'then',
    'to',
    'transaction',
    'union',
    'unique',
    'update',
    'using',
    'values',
    'when',
    'where'
  };
}
