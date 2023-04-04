import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_firebase/models/image_file.dart';
import 'package:flutter_firebase/utils/file_utils.dart';
import 'package:flutter_firebase/utils/firestore_utils.dart';
import 'package:flutter_firebase/utils/image_file_utils.dart';
import 'package:flutter_firebase/utils/user_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_android/url_launcher_android.dart';
import '../models/user.dart';
import '../utils/firestorage_utils.dart';
import 'package:path/path.dart' as p;

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  late Stream<List<ImageFile?>> images;

  @override
  void initState() {
    images =
        ImageFileUtils.instanse.get(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  TextEditingController filenameController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  void showImageDialog(String filenameBase, filenameEdit, path) {
    filenameController.text = filenameEdit;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                      key: key,
                      child: TextFormField(
                        controller: filenameController,
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Имя файла не должно быть пустым";
                          }
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!key.currentState!.validate()) return;
                          File file = await FileUtils.fileFromImageUrl(path);
                          final size = file.lengthSync();
                          final fileExtension = p.extension(file.path);
                          final imagefile = ImageFile(
                              size: size,
                              file: file,
                              fileExtension: fileExtension);
                          String newFileName =
                              FireStorageUtils.getFileNameByName(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  filenameController.text + fileExtension);
                          await FileUtils.updateFile(
                              filenameBase, newFileName, imagefile);
                          Navigator.of(context).pop();
                        },
                        child: Text("Сохранить"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                          overlayColor: MaterialStateProperty.all(Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          filenameController.text = "";
                          Navigator.of(context).pop();
                        },
                        child: Text("Отмена"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                          overlayColor: MaterialStateProperty.all(Colors.black),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FileUtils.uploadImage();
        },
        child: const Icon(Icons.add_a_photo),
        focusColor: Colors.purple,
        hoverColor: Colors.purple,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: StreamBuilder(
          stream: images,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView(
              children: snapshot.data!.map((image) {
                if (image != null) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                      ),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 200, height: 200),
                            child: Image(image: NetworkImage(image.path!)),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 4)),
                          Text("Название файла: " +
                              FileUtils.restructFileName(image.filename!)),
                          Padding(padding: EdgeInsets.only(bottom: 4)),
                          Text("Размер файла: " +
                              FileUtils.restructSize(image.size)),
                          Padding(padding: EdgeInsets.only(bottom: 4)),
                          ElevatedButton(
                              onPressed: () async {
                                Uri uri = Uri(path: image.path!);
                                await UrlLauncherAndroid().launch(
                                  image.path!,
                                  useSafariVC: true,
                                  useWebView: false,
                                  enableJavaScript: false,
                                  enableDomStorage: true,
                                  universalLinksOnly: false,
                                  headers: <String, String>{
                                    'my_header_key': 'my_header_value'
                                  },
                                );
                              },
                              child: Icon(Icons.download_sharp)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    showImageDialog(
                                        image.filename!,
                                        FileUtils
                                            .restructFileNameWithOutExtension(
                                                image.filename!),
                                        image.path!);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.purple),
                                    overlayColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  child: Icon(Icons.edit_sharp)),
                              ElevatedButton(
                                onPressed: () async {
                                  String filename = image.filename!;
                                  FileUtils.deleteImage(filename);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.purple),
                                  overlayColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                child: Icon(Icons.delete_sharp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
