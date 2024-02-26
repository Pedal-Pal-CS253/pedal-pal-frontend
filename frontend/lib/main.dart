import 'package:flutter/material.dart';
import 'package:frontend/wallet_home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/reg_login_forgot.dart';
import 'pages/map_page.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(const MyApp());
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
        '/DashBoard': (context) => MapPage(),
        // '/history': (context) =>
        '/registration': (context) => RegistrationApp(),
        '/otp_verification': (context) => OTPVerificationPage(),
        '/account_created': (context) => AccountCreatedPage(),
        '/login': (context) => LoginPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/password_reset': (context) => PasswordResetPage(),
        '/password_reset_successful': (context) => PasswordResetSuccessfulPage(),

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Register')
            ),

            // Button to navigate to the wallet page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletHomePage()),
                );
              },
              child: Text('Open Wallet'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Text('Dashboard')
            ),
          ],
        ),
      ),
    );
  }
}

