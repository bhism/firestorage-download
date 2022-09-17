import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'viewpage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'nextpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<ListResult>? futureFiles;
  var vis = false;

  @override
  void initState() {
    futureFiles = FirebaseStorage.instance.ref('/files').list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder<ListResult>(
          future: futureFiles,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.items;

              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 3,
                        right: 3,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.image,
                          ),
                          onPressed: () {
                            setState(() {
                              vis = true;
                            });
                            view(file);
                          },
                        ),
                        title: Text(
                          file.name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.download,
                          ),
                          onPressed: () {
                            setState(() {
                              vis = true;
                            });

                            download(file);
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Errors...."),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
        Center(
          child: Visibility(
            visible: vis,
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
        ),
      ],
    ));
  }

  Future download(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final url = await ref.getDownloadURL();
    final path = '${dir.path}/${ref.name}';
    await Dio().download(url, path);
    await GallerySaver.saveImage(path, toDcim: true).whenComplete(() {
      setState(() {
        vis = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => nectpage(
            path: path,
          ),
        ),
      );
    });
  }

  Future view(Reference ref) async {
    final url = await ref.getDownloadURL();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPage(
          path: url,
        ),
      ),
    ).whenComplete(() {
      setState(() {
        vis = false;
      });
    });
  }
}
