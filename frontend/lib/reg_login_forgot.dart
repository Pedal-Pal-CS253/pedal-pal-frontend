import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class RegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegistrationPage();
  }
}

class RegistrationPage extends StatelessWidget {
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
                  margin: EdgeInsets.only(bottom: 100, top:80),
                  child:
                  Image.asset(
                    'assets/pedal_pal_logo.png', // Adjust the path to your image
                    width: 260, // Adjust the width as needed
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Welcome to Pedal Pal',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Your Full Name',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
              decoration: InputDecoration(
                labelText: 'Your Phone Number',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Your Email Address',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
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
              Navigator.pushNamed(context, '/otp_verification');
              },
              child: Text('Create an account',
                style: TextStyle( fontSize: 18.0,
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
            Center(child:
            Text('Didn\'t receive the Code?'),
            ),
            Center(
              child:
              ElevatedButton(
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
                child:               ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A2758),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/account_created');
                  },
                  child: Text('Verify',
                    style: TextStyle( fontSize: 18.0,
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
            Text('Account Created Succesfully!',
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
                    child: Text('Continue',
                      style: TextStyle( fontSize: 18.0,
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
                margin: EdgeInsets.only(bottom: 100, top:80),
                child:
                Image.asset(
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
              decoration: InputDecoration(labelText: 'Your phone number'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2758),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text('Login',
                  style: TextStyle( fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgot_password'); // Navigate to forgot password page
                },
                child: Text('Forgot Password?'),
              ),
            ),
            SizedBox(height:70),
            Align(
                alignment: Alignment.center,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not on Pedal Pal Yet? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/registration'); // Navigate to forgot password page
                      },
                      child: Text('Sign Up!',
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
}

class ForgotPasswordPage extends StatelessWidget {
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
                margin: EdgeInsets.only(bottom: 100, top:80),
                child:
                Image.asset(
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
              decoration: InputDecoration(labelText: 'Enter Email'),
            ),
            SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2758),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/password_reset');
                },
                child: Text('Send a Link. ',
                  style: TextStyle( fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to forgot password page
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
}

class PasswordResetPage extends StatelessWidget {
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
                margin: EdgeInsets.only(bottom: 100, top:80),
                child:
                Image.asset(
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
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2758),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/password_reset_successful');
                },
                child: Text('Reset Password',
                  style: TextStyle( fontSize: 18.0,
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
              child: Text('Continue',
                style: TextStyle( fontSize: 18.0,
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
