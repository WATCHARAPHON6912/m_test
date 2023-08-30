import 'package:common_data_table/common_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:m_test/DB.dart';
import 'dart:async';

List<List<String>> data = [];

class table_te extends StatefulWidget {
  const table_te({super.key});

  @override
  State<table_te> createState() => _table_teState();
}

class _table_teState extends State<table_te> {
  @override
  void initState() {
    super.initState();
    read();
  }

  void read() async {
    data.clear();
    Timer(Duration(seconds: 1), handleTimeout);
    DB_read_all("SELECT * FROM student").then((value) {
      for (var x in value) {
        data.add(x);
      }
    });
  }

  void handleTimeout() async {
    try {
      setState(() {});
    } catch (e) {}
  }

  List<String> ti = ['S.NO', 'Name', 'Email', 'Password', 'Phone'];

  var update = ['', '', '', '', ''];
  var update_title = ["S_id", "S_name", "S_email", "pass", "S_phone"];

  @override
  Widget build(BuildContext context) {
    return CommonDataTable(
      isSearchAble: true,
      tableActionButtons: [
        TableActionButton(
          child: Text("Add data"),
          onTap: () {
            print("add");
            add_data();
          },
          shortcuts: SingleActivator(
            LogicalKeyboardKey.keyA,
            control: true,
          ),
          icon: Icon(
            FontAwesomeIcons.addressCard,
            size: 20,
          ),
        ),
        TableActionButton(
          child: Text("re"),
          onTap: () {
            read();
          },
          shortcuts: SingleActivator(
            LogicalKeyboardKey.keyA,
            control: true,
          ),
          icon: Icon(
            FontAwesomeIcons.refresh,
            size: 20,
          ),
        )
      ],
      sortColumn: [
        0,
        1,
        2,
        3,
      ],

      title: "ข้อมูลนักศึกษา",
      titleBgColor: Colors.black,
      titleStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      heading: ti,

      rowBGColor: (index) {
        if (index.isOdd) {
          return Color.fromARGB(255, 236, 230, 119);
        } else {
          return Color.fromARGB(255, 154, 236, 119);
        }
      },
      data: data,
      headingAlign: {
        0: TblAlign.center,
        1: TblAlign.center,
      },
      dataAlign: {
        0: TblAlign.center,
      },
      onEdit: (index) {
        print("edit $index");
        print("edit ${data[0][0]}");
        open_edit1(index);
      },
      onDelete: (index) {
        print("delete $index");
        open_delet(index);
      },
      // disabledDeleteButtons: [1, 3, 5],
      // disabledEditButtons: [0, 2, 4],
      dataTextStyle: (row) {
        return {0: TextStyle(color: Colors.blue, fontSize: 20)};
      },
      onExportExcel: (file) async {
        await launchUrl(Uri.file(file.path));
      },
      onExportPDF: (file) async {
        await launchUrl(Uri.file(file.path));
      },
    );
  }

  Future add_data() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "เพิ่มข้อมูล",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: ti.length,
              itemBuilder: (_, i) {
                return Container(
                  padding: new EdgeInsets.all(5.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "${ti[i]}",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      onChanged: (value) {
                        update[i] = value;
                      }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  for (int j = 0; j < update.length; j++) {
                    if (update[j] == '') {
                      update[j] = 'null';
                    }
                  }
                  DB_update(
                          "INSERT INTO student (S_id, S_name, S_email, pass, S_phone) VALUES ('${update[0]}', '${update[1]}', '${update[2]}', '${update[3]}', '${update[4]}');")
                      .then((value) {
                    if (value == true) {
                      Error();
                    }

                    read();
                    for (int i = 0; i < ti.length; i++) {
                      update[i] = '';
                    }
                  });

                  Navigator.pop(context, 'ยืนยัน');
                },
                child: Text("ยืนยัน")),
            TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: Text("ยกเลิก")),
          ],
        ),
      );

  Future open_edit1(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "เพิ่มข้อมูล",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: ti.length,
              itemBuilder: (_, i) {
                return Container(
                  padding: new EdgeInsets.all(5.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "${ti[i]}",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      onChanged: (value) {
                        update[i] = value;
                      }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < ti.length; i++) {
                      if (update[i] != '') {
                        data[index][i] = update[i];
                      }
                    }
                    print(update);
                    for (int x = 0; x < update.length; x++) {
                      if (update[x] != '') {
                        DB_update(
                            "update student set ${update_title[x]} ='${update[x]}' where S_id ='${data[index][0]}';").then((value) {
                              Error();
                            });
                      }
                    }
                    for (int i = 0; i < ti.length; i++) {
                      update[i] = '';
                    }
                  });
                  Navigator.pop(context, 'ยืนยัน');
                },
                child: Text("ยืนยัน")),
            TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: Text("ยกเลิก")),
          ],
        ),
      );

  Future open_delet(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/al.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text('\t\tแจ้งเตือน'),
            ],
          ),
          content: const Text('คุณแน่ใจในการลบหรือไม่!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context, 'ตกลง');
                  DB_update(
                          "DELETE FROM student WHERE (S_id = '${data[index][0]}');")
                      .then((value) {
                    if (value == false) {
                      Error();
                    } else {
                      data.removeAt(index);
                    }
                  });
                });
              },
              child: const Text('ตกลง'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'ยกเลิก'),
              child: const Text('ยกเลิก'),
            ),
          ],
        ),
      );
  Future Error() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/error.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text('\t\tแจ้งเตือน'),
            ],
          ),
          content: const Text('เกิดข้อผิดพลาด'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ตกลง');
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
}
