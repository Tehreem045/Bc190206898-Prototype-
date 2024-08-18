import 'package:assignment/auth/profile_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? _email, _otp;
  bool _isOtpSent = false;
  String? _verificationId;

  Future<void> _sendOtp(String phoneNumber) async {
    _showLoadingDialog(); // Show loading indicator
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pop(context); // Hide loading indicator
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileCreationPage()));
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context); // Hide loading indicator
        Fluttertoast.showToast(msg: e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context); // Hide loading indicator
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
        Fluttertoast.showToast(msg: "OTP sent to $phoneNumber");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isOtpSent) {
        try {
          _showLoadingDialog(); // Show loading indicator
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: _otp!,
          );
          await _auth.signInWithCredential(credential);
          Navigator.pop(context); // Hide loading indicator
          Fluttertoast.showToast(msg: "Registration successful");
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileCreationPage()));
        } catch (e) {
          Navigator.pop(context); // Hide loading indicator
          Fluttertoast.showToast(msg: e.toString());
        }
      } else {
        _sendOtp(_email!);
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
        //  automaticallyImplyLeading: false,
          title: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),


        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (input) => input!.isEmpty ? 'Enter Phone Number' : null,
                onSaved: (input) => _email = input,
              ),
              if (_isOtpSent)
                TextFormField(
                  decoration: InputDecoration(labelText: 'OTP'),
                  validator: (input) => input!.isEmpty ? 'Enter OTP' : null,
                  onSaved: (input) => _otp = input,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text(_isOtpSent ? 'Verify OTP' : 'Register'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: Text("Already have an account? Login here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
