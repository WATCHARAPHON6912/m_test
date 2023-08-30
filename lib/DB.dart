import 'package:mysql_manager/src/mysql_manager.dart';

var DB = {
  'db': 'project1',
  'host': '127.0.0.1',
  'user': 'root',
  'password': '1234',
  'port': '3306'
};

Future<List<String>> DB_read_r1(String cmd) async {
  List<String> data = [];
  final MySQLManager manager = MySQLManager.instance;
  final conn = await manager.init(false, DB);
  var result = await conn.execute(cmd);
  for (final row in result.rows) {
    data.add(row.colAt(0).toString());
  }
  conn.close();
  return data;
}

Future<List<String>> DB_read(String cmd) async {
  List<String> data = [];
  final MySQLManager manager = MySQLManager.instance;
  final conn = await manager.init(false, DB);
  var result = await conn.execute(cmd);
  for (final row in result.rows) {
    for (int i = 0; i < result.numOfColumns; i++) {
      data.add(row.colAt(i).toString());
    }
  }
  conn.close();
  return data;
}

Future<List<List<String>>> DB_read_all(String cmd) async {
  List<List<String>> data = [];

  final MySQLManager manager = MySQLManager.instance;
  final conn = await manager.init(false, DB);
  var result = await conn.execute(cmd);
  for (final row in result.rows) {
    List<String> da = [];
    for (int i = 0; i < result.numOfColumns; i++) {
      da.add(row.colAt(i).toString());
    }
    data.add(da);
  }
  conn.close();
  return data;
}

Future DB_update(cmd) async {
  bool error = false;
  final MySQLManager manager = MySQLManager.instance;
  final conn = await manager.init(false, DB);
  try {
    await conn.execute(cmd);
  } catch (e) {
    error = true;
  }

  conn.close();
  return error;
}

Future<List<List<String>>> DB_read_st(String cmd) async {
  List<List<String>> data = [];

  final MySQLManager manager = MySQLManager.instance;
  final conn = await manager.init(false, DB);
  var result = await conn.execute(cmd);
  for (final row in result.rows) {
    List<String> da = [];
    for (int i = 0; i < result.numOfColumns; i++) {
      da.add(row.colAt(i).toString());
    }
    data.add(da);
  }
  conn.close();
  return data;
}

List<List<String>> convert(data) {
  List<String> number = [];
  List<List<String>> data_out = [];

  for (int i = 0; i < data.length; i++) {
    if (number.contains(data[i][0]) == false) {
      number.add(data[i][0]);
      data_out.add([data[i][0], data[i][1]]);
    }
  }
  for (int i = 0; i < number.length; i++) {
    for (int k = 0; k < data.length; k++) {
      if (number[i] == data[k][0]) {
        data_out[i].add(data[k][3]);
      }
    }
  }
  return data_out;
}

List<List<List<String>>> convert_GPA(data) {
  List<String> number = [];
  List<String> number_ti = [];
  List<List<String>> data_out = [];
  List<List<String>> title = [];
  int yy = 0;

  for (int i = 0; i < data.length; i++) {
    if (number.contains(data[i][0]) == false) {
      number.add(data[i][0]);
      data_out.add([data[i][0]]);
    }
    if (number_ti.contains(data[i][1]) == false) {
      number_ti.add(data[i][1]);
      title.add([data[i][1]]);
    }
  }
  for (int i = 0; i < number.length; i++) {
    for (int k = 0; k < data.length; k++) {
      if (number[i] == data[k][0]) {
        data_out[i].add(data[k][2]);
      }
    }
  }
  for (int f = 0; f < data_out.length; f++) {
    if (data_out[f].length > yy) yy = data_out[f].length;
  }
  for (int j = 0; j < data_out.length; j++) {
    if (data_out[j].length < yy) {
      print(yy - data_out[j].length);
      for (int z = 0; z <= (yy - data_out[j].length); z++) {
        data_out[j].add("null");
      }
    }
  }

  return [
    [
      ["$yy"]
    ],
    data_out
  ];
}
