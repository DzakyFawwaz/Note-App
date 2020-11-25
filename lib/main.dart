import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_demo/model/siswa.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as providerPath;
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentary = await providerPath.getApplicationDocumentsDirectory();
  Hive.init(appDocumentary.path);
  Hive.registerAdapter(SiswaAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HiveDemo(),
    );
  }
}

class HiveDemo extends StatefulWidget {
  @override
  _HiveDemoState createState() => _HiveDemoState();
}

class _HiveDemoState extends State<HiveDemo> {
  TextEditingController _controllerJudul = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (value) {
            Hive.box("note").deleteFromDisk();
            setState(() {
              Hive.box("note").listenable();
            });
          }, itemBuilder: (BuildContext context) {
            return ['Delete All'].map((e) {
              return PopupMenuItem(value: e, child: Text(e));
            }).toList();
          })
        ],
        title: Text("Note App"),
      ),
      body: FutureBuilder(
        future: Hive.openBox("note"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            } else {
              var boxSiswa = Hive.box("note");
              if (boxSiswa.length > 0) {
                Center(child: Text("No Data"));
              }
              return ValueListenableBuilder(
                  valueListenable: Hive.box("note").listenable(),
                  builder: (context, dataSiswa, _) =>
                      StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: dataSiswa.length,
                        itemBuilder: (context, index) {
                          Siswa siswa = dataSiswa.getAt(index);
                          return GestureDetector(
                            onLongPress: () => dataSiswa.deleteAt(index),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.fromLTRB(5, 10, 5, 2),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(3, 3),
                                      blurRadius: 6)
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    siswa.judul,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(siswa.desc,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey))
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      )
                  );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              child: Center(
                child: Dialog(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextField(
                                decoration: InputDecoration(hintText: "Judul"),
                                controller: _controllerJudul),
                            TextField(
                              maxLines: null,
                              controller: _controllerDesc,
                              decoration: InputDecoration(
                                hintText: "Deskripsi",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                            onPressed: () {
                              Siswa siswa = Siswa(
                                  _controllerJudul.text, _controllerDesc.text);

                              Hive.box("note").add(siswa);
                              Navigator.pop(context);

                              _controllerJudul.clear();
                              _controllerDesc.clear();

                            },
                            child: Text(
                              "Tambah Note",
                              style: TextStyle(color: Colors.grey),
                            ))
                      ],
                    ),
                  ),
                ),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
