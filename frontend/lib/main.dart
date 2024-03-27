import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/pages/reg_login_forgot.dart';
import 'package:uni_links/uni_links.dart';

import 'pages/map_page.dart';

bool _initialURILinkHandled = false;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  await dotenv.load();

  FlutterSecureStorage storage = FlutterSecureStorage();
  var loggedIn = await storage.containsKey(key: 'auth_token');

  if (!loggedIn) {
    runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
      navigatorObservers: [routeObserver],
    ));
  } else {
    runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.blue,
        ),
        home: Dashboard(),
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedal Pal',
      theme: ThemeData(
        fontFamily: 'Lato',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: "PedalPal"),
        '/register': (context) => RegistrationApp(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  _handleDeepLink(Uri? uri) {
    if (uri!.path == "/auth/password_reset/confirm/") {
      final String token = uri.queryParameters['token']!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordResetPage(token: token),
        ),
      );
    }
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      debugPrint('Invoked initURIHandler');
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {});
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() {});
      }
    }
  }

  void _incomingLinkHandler() {
    if (true) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        _handleDeepLink(uri);
        setState(() {});
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0, 0.1, 0.45, 0.5, 0.95, 1],
            colors: [
              Color.fromARGB(255, 56, 165, 210),
              Color.fromARGB(255, 60, 170, 217),
              Color.fromARGB(255, 169, 200, 217),
              Color.fromARGB(255, 169, 200, 217),
              Color.fromARGB(255, 88, 83, 154),
              Color.fromARGB(255, 69, 78, 140),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Image.asset(
                'assets/pedal_pal_logo_small.png',
                width: 180,
              ),
              Image.asset(
                'assets/pedal_pal_logo_text.png',
                width: 220,
              ),
              SizedBox(height: 30),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    backgroundColor: const Color.fromARGB(255, 60, 170, 217),
                    minimumSize: Size(130, 40),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage())),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    backgroundColor: const Color.fromARGB(255, 88, 83, 154),
                    minimumSize: Size(130, 40),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Powered by BitBrewers",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
