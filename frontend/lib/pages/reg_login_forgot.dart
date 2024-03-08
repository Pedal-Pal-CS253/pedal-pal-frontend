import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/pages/alerts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegistrationPage();
  }
}

final InputDecoration textFormFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
    borderRadius: BorderRadius.circular(20.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
    borderRadius: BorderRadius.circular(20.0),
  ),
);

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

class RegistrationPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 100.0, top: 80.0),
                        child: Image.asset(
                          'assets/pedal_pal_logo.png',
                          // Adjust the path to your image
                          width: 260, // Adjust the width as needed
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'Welcome to Pedal Pal',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Your Full Name',
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: phoneController,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Your Phone Number',
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateEmail,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Your Email Address',
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2758),
                      ),
                      onPressed: () {
                        sendRegistrationRequest(
                          context,
                          emailController.text,
                          passwordController.text,
                          phoneController.text,
                          nameController.text,
                        );
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendRegistrationRequest(BuildContext context, String email,
      String password, String phone, String name) async {
    // TODO: change host
    var uri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      path: 'auth/register/',
      port: 8000,
    );

    var firstName = name.split(' ')[0];
    var lastName = name.substring(firstName.length);

    var body = jsonEncode({
      'email': email,
      'password': password,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName
    });

    LoadingIndicatorDialog().show(context);
    // TODO: add OTP validation
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 200) {
      Navigator.pushNamed(
          context, '/login'); // TODO: go to account created page
    } else {
      AlertPopup().show(context, text: response.body);
    }
  }
}

class OTPVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter the 4-digit OTP sent to your phone',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            PinInputTextField(
              pinLength: 4,
              decoration: UnderlineDecoration(
                colorBuilder: PinListenColorBuilder(Colors.blue, Colors.blue),
                textStyle: TextStyle(fontSize: 20.0),
              ),
              autoFocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmit: (pin) {
                // Handle submitted OTP (e.g., verify OTP)
              },
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text('Didn\'t receive the Code?'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Resend OTP
                },
                child: Text('Resend OTP'),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A2758),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/account_created');
                  },
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountCreatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Created'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Account Created Succesfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Your account has been created successfully!'),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A2758),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 100.0, top: 80.0),
                child: Image.asset(
                  'assets/pedal_pal_logo.png', // Adjust the path to your image
                  width: 260, // Adjust the width as needed
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Your Email',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2758),
                      ),
                      onPressed: () {
                        sendLoginRequest(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/forgot_password',
                          ); // Navigate to forgot password page
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not on Pedal Pal Yet? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/registration'); // Navigate to forgot password page
                            },
                            child: Text(
                              'Sign Up!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendLoginRequest(
      BuildContext context, String email, String password) async {
    // TODO: change host
    var uri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      path: 'auth/login/',
      port: 8000,
    );

    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    LoadingIndicatorDialog().show(context);
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 200) {
      var tokenUri = Uri(
        scheme: 'http',
        host: '10.0.2.2',
        path: 'auth/api_token_auth/',
        port: 8000,
      );

      var tokenBody = jsonEncode({
        'username': email,
        'password': password,
      });

      LoadingIndicatorDialog().show(context);
      var tokenResponse = await http.post(
        tokenUri,
        headers: {"Content-Type": "application/json"},
        body: tokenBody,
      );
      LoadingIndicatorDialog().dismiss();

      if (tokenResponse.statusCode == 200) {
        var token = jsonDecode(tokenResponse.body)['token'];
        final storage = FlutterSecureStorage();
        await storage.write(key: "auth_token", value: token);
        print(token);
        AlertPopup().show(context, text: token);
      } else {
        print(tokenResponse.body);
        AlertPopup().show(context, text: tokenResponse.body);
      }
    } else {
      AlertPopup().show(context, text: response.body);
    }
  }
}

class ForgotPasswordPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 100.0, top: 80.0),
                child: Image.asset(
                  'assets/pedal_pal_logo.png', // Adjust the path to your image
                  width: 260, // Adjust the width as needed
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateEmail,
                      decoration: textFormFieldDecoration.copyWith(
                          labelText: 'Enter Email'),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2758),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/password_reset');
                        getEmailForPasswordReset(context, emailController.text);
                      },
                      child: Text(
                        'Send a Link',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context,
                              '/login'); // Navigate to forgot password page
                        },
                        child: Text('Login?'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<http.Response> getEmailForPasswordReset(BuildContext context,
      String email) async {
    var uri = Uri.https('pedal-pal-backend.vercel.app', 'auth/password_reset/');

    var body = jsonEncode({
      'email': email,
    });

    LoadingIndicatorDialog().show(context);

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OpenEmail()));
    } else {
      AlertPopup().show(context, text: response.body);
    }

    return response;
  }
}

class OpenEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please check your email for the password reset link.'),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}


class PasswordResetPage extends StatelessWidget {
  final String token;
  TextEditingController password = TextEditingController();
  TextEditingController confirm_pass = TextEditingController();
  var _password = '';
  var _confirmPassword = '';

  PasswordResetPage({Key? key, required this.token}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 100.0, top: 80.0),
                child: Image.asset(
                  'assets/pedal_pal_logo.png', // Adjust the path to your image
                  width: 260, // Adjust the width as needed
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: password,
                      decoration: textFormFieldDecoration.copyWith(
                          labelText: 'New Password'),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textFormFieldDecoration.copyWith(
                          labelText: 'Confirm Password'),
                      obscureText: true,
                      onChanged: (value) {
                          _confirmPassword = value;
                      }
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2758),
                      ),
                      onPressed: () {
                        if (_password != _confirmPassword){ // you can add your statements here
                        Fluttertoast.showToast(msg : "Passwords do not match! Please re-type again.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          textColor: Colors.redAccent,
                          fontSize: 16.0);
                        } else {
                          sendPasswordResetRequest(context, password.text, token);
                        }
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> sendPasswordResetRequest(BuildContext context,
      String password, String token) async {
    final Map<String, String> _queryParameters = <String, String>{
      'token': token,
    };

    var uri = Uri.https('pedal-pal-backend.vercel.app', 'auth/password_reset/confirm/', _queryParameters);

    var body = jsonEncode({
      'password': password,
      'token' : token,
    });

    LoadingIndicatorDialog().show(context);

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetSuccessfulPage()));
    } else {
      AlertPopup().show(context, text: response.body);
    }

    return response;
  }
}


class PasswordResetSuccessfulPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your password has been reset successfully!'),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A2758),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
