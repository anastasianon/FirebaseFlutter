import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/main_screen.dart';
import 'package:flutter_firebase/utils/firestore_utils.dart';
import 'package:flutter_firebase/utils/message_helper.dart';
import 'package:flutter_firebase/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/utils/user_utils.dart';
import 'package:flutter_firebase/models/user.dart' as models;

class EnterScreen extends StatefulWidget {
  const EnterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EnterScreenState();
}

class EnterScreenState extends State<EnterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                            return "Поле не должно быть пустым";
                          }
                        },
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.purple, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.purple,
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                          //create lable
                          labelText: 'Email',
                          //lable style
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == "") {
                            return "Поле не должно быть пустым";
                          }
                        },
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.purple, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.purple,
                          hintText: "Пароль",
                          hintStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                          //create lable
                          labelText: 'Пароль',
                          //lable style
                          labelStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    FireBaseUtils.instance
                        .authWithLoginAndPassword(
                            loginController.text, passwordController.text)
                        .then((status) {
                      if (status.isSuccess) {
                        showMessage("Вы авторизовались", context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                      } else {
                        showMessage(status.errorMessage!, context);
                      }
                    });
                  },
                  child: const Text("Авторизоваться"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    overlayColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    FireBaseUtils.instance
                        .register(loginController.text, passwordController.text)
                        .then((status) {
                      if (status.isSuccess) {
                        showMessage("Вы зарегистрировались", context);
                      } else {
                        showMessage(status.errorMessage!, context);
                      }
                    });
                  },
                  child: const Text("Зарегистрироваться"),
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
