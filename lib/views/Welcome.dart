import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec_you/components/CustomComponents.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.fitWidth,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
            )),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset('assets/logo_name.png', width: 240),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  padding: const EdgeInsets.only(
                    left: 30,
                    top: 20,
                    right: 30,
                    bottom: 30,
                  ),
                  child: Column(children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      "The soundtrack of your life",
                      style: TextStyle(
                          fontSize: 15.0, decoration: TextDecoration.none),
                    ),
                    SizedBox(height: 10),
                    Text("Created for you",
                        style: TextStyle(
                            fontSize: 15.0, decoration: TextDecoration.none)),
                    SizedBox(height: 10),
                    Text("By you and your friends",
                        style: TextStyle(
                            fontSize: 15.0, //
                            decoration: TextDecoration.none)),
                    SizedBox(height: 10),
                    Text("Start the record 📣",
                        style: TextStyle(
                            fontSize: 15.0, //
                            decoration: TextDecoration.none)),
                  ]),
                ),
              ],
            )),
            CustomComponents.customButton(
                "Login", context, () => Navigator.pushNamed(context, '/login')),
            SizedBox(height: 20),
            CustomComponents.customButton("Sign Up", context,
                () => Navigator.pushNamed(context, '/register')),
            SizedBox(height: 30)
          ],
        ));
  }
}
