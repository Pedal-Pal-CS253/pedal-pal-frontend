import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/pages/reg_login_forgot.dart';
import 'package:uni_links/uni_links.dart';

import 'pages/map_page.dart';

bool _initialURILinkHandled = false;

Future<void> main() async {
  await dotenv.load();

  FlutterSecureStorage storage = FlutterSecureStorage();
  var token = await storage.read(key: 'auth_token');

  if (token == null) {
    runApp(MaterialApp(
      home: MyApp(),
    ));
  } else {
    runApp(MaterialApp(
      home: Dashboard(),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedal Pal',
      theme: ThemeData(
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
      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
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
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
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

  // Handle incoming links - the ones that the app will receive from the OS
  // while already started.
  void _incomingLinkHandler() {
    if (true) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing app content here
            Image.asset(
              'assets/pedal_pal_logo.png', // Adjust the path to your image
              width: 260, // Adjust the width as needed
            ),
            Text("Welcome to PedalPal!"),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
