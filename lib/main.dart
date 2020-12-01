import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/stores/AudioStore.dart';
import 'package:rec_you/views/MainScreen.dart';
import 'package:rec_you/stores/PostStore.dart';
import 'package:rec_you/views/Record.dart';
import 'package:rec_you/views/Register.dart';
import 'package:rec_you/views/UserProfile.dart';
import 'package:rec_you/stores/UserStore.dart';
import 'package:rec_you/views/Welcome.dart';
import 'package:splashscreen/splashscreen.dart';
import 'views/Login.dart';
import 'stores/RecordStore.dart';
import 'views/Search.dart';
import 'util/SharedPreferencesData.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      Provider<SharedPreferencesData>(create: (_) => SharedPreferencesData()),
      Provider<PostStore>(create: (_) => PostStore()),
      Provider<RecordStore>(create: (_) => RecordStore()),
      Provider<UserStore>(create: (_) => UserStore()),
      Provider<AudioStore>(create: (_) => AudioStore()),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        fontFamily: 'Raleway',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/homepage': (context) => HomePage(),
        UserProfile.routeName: (context) => UserProfile(),
        '/record': (context) => Record(),
        '/search': (context) => Search(),
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _Splash createState() => new _Splash();
}

class _Splash extends State<Splash> {
  SharedPreferencesData sharedPref;

  @override
  Widget build(BuildContext context) {
    sharedPref = Provider.of<SharedPreferencesData>(context);

    return SplashScreen(
      navigateAfterFuture: afterSplashScreen(sharedPref),
      image: new Image.asset('assets/logo.png'),
      backgroundColor: Colors.black,
      title: new Text(
        'Record and Share',
        style: new TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24.0),
      ),
      photoSize: 100.0,
      loaderColor: Colors.black,
    );
  }

  Future<Widget> afterSplashScreen(SharedPreferencesData sharedPref) async {
    await sharedPref.reset();
    await new Future.delayed(const Duration(milliseconds: 1000));
    if (sharedPref.username != null) {
      return HomePage();
    } else {
      return WelcomeScreen();
    }
  }
}
