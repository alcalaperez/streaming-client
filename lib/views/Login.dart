import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import '../stores/UserStore.dart';
import '../components/CustomComponents.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  UserStore store;
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  emailEditText() => CustomComponents.customEditText(
      "Username", false, store.borderColor, userController);

  passwordEditText() => CustomComponents.customEditText(
      "Password", true, store.borderColor, passController);

  loginButton() => CustomComponents.customButton("Log in", context, () async {
    store.logInUser(userController.text, passController.text, context);
  });

  body() {
    return Column(children: [
      Expanded(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 25.0),
                emailEditText(),
                SizedBox(height: 25.0),
                passwordEditText(),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  store.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              ],
            ),
          ),
        ),
      ),
      loginButton(),
      SizedBox(
        height: 30.0,
      )
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
            if (store.networkCallResult == null) {
              return body();
            } else {
              switch (store.networkCallResult.status) {
                case FutureStatus.pending:
                  return Center(
                      child: SpinKitFadingCube(
                          color: Colors.red,
                          duration: Duration(milliseconds: 850)));
                case FutureStatus.fulfilled:
                  return body();
                default:
                  return SizedBox();
              }
            }
          }),
        ));
  }
}
