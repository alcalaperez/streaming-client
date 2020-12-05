import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/util/FileManager.dart';

import '../stores/UserStore.dart';
import '../components/CustomComponents.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  UserStore store;
  FileManager fm = FileManager();

  final userController = TextEditingController();
  final passController = TextEditingController();
  final repPassController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    repPassController.dispose();
    super.dispose();
  }

  emailEditText() => CustomComponents.customEditText(
      "Username", false, store.borderColor, userController);

  passwordEditText() => CustomComponents.customEditText(
      "Password", true, store.borderColor, passController);

  rePasswordEditText() => CustomComponents.customEditText(
      "Repeat password", true, store.borderColor, repPassController);

  registerButton() =>
      CustomComponents.customButton("Register", context, () async {
        await store.registerUser(userController.text, passController.text,
            repPassController.text, context);
      });

  getBody() {
    return Column(children: <Widget>[
      Expanded(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      fm.showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.red,
                      child: store.picture != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                store.picture,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                emailEditText(),
                SizedBox(height: 25.0),
                passwordEditText(),
                SizedBox(height: 25.0),
                rePasswordEditText(),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  store.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      ),
      registerButton(),
      SizedBox(
        height: 30.0,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    store = Provider.of<UserStore>(context);
    store.resetUI();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fitWidth,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                )),
            child: Observer(builder: (_) {
              if (store.networkCallResult == null && store.userExist == null) {
                return getBody();
              } else {
                switch (store.userExist.status) {
                  case FutureStatus.pending:
                    return Center(
                        child: SpinKitFadingCube(
                            color: Colors.red,
                            duration: Duration(milliseconds: 850)));
                  case FutureStatus.fulfilled:
                    if (store.networkCallResult != null) {
                      return Center(
                          child: SpinKitFadingCube(
                              color: Colors.red,
                              duration: Duration(milliseconds: 850)));
                    } else {
                      return getBody();
                    }
                    break;
                  default:
                    return SizedBox();
                }
              }
            })));
  }
}
