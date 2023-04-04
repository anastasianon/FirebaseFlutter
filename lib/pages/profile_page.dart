import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/enter_screen.dart';
import 'package:flutter_firebase/utils/firebase_utils.dart';

import '../utils/message_helper.dart';
import '../utils/user_utils.dart';
import 'package:flutter_firebase/models/user.dart' as models;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    loginController.text = FirebaseAuth.instance.currentUser!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: loginController,
                        validator: (value) {
                          if (value == "") {
                            return "Поле не должны быть пустым";
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Почта"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Новый пароль"),
                      ),
                    )
                  ],
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    if (passwordController.text != "") {
                      if (passwordController.text.length >= 7) {
                        UserUtils.instanse
                            .getUser(FirebaseAuth.instance.currentUser!.uid)
                            .then((user) {
                          if (user.password != passwordController.text) {
                            FireBaseUtils.instance
                                .updatePassword(passwordController.text)
                                .then((status) {
                              UserUtils.instanse.update(
                                  FirebaseAuth.instance.currentUser!.email!,
                                  user.password,
                                  FirebaseAuth.instance.currentUser!.uid);
                              if (status.isSuccess) {
                                showMessage("Пароль обновлён", context);
                              } else {
                                showMessage(status.errorMessage!, context);
                              }
                            });
                          }
                        });
                      } else {
                        showMessage(
                            "Пароль не может быть меньше 7 символлов", context);
                      }
                    }

                    if (FirebaseAuth.instance.currentUser!.email! !=
                        loginController.text) {
                      FireBaseUtils.instance
                          .updateEmail(loginController.text)
                          .then((status) {
                        if (status.isSuccess) {
                          UserUtils.instanse
                              .getUser(FirebaseAuth.instance.currentUser!.uid)
                              .then((user) {
                            UserUtils.instanse.update(
                                FirebaseAuth.instance.currentUser!.email!,
                                user.password,
                                FirebaseAuth.instance.currentUser!.uid);
                          });
                          showMessage("Почта  была обновлена", context);
                        } else {
                          showMessage(status.errorMessage!, context);
                        }
                      });
                    }
                  },
                  child: const Text("Сохранить"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    overlayColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    FireBaseUtils.instance.deleteAccount().then((status) async {
                      if (status.isSuccess) {
                        await UserUtils.instanse.delete(uid);
                      } else {
                        showMessage(status.errorMessage!, context);
                      }
                    });
                    showMessage("Аккаунт был удален", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EnterScreen()));
                  },
                  child: const Text("Удалить аккаунт"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    overlayColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EnterScreen()));
                  },
                  child: const Text("Выйти"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    overlayColor: MaterialStateProperty.all(Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
