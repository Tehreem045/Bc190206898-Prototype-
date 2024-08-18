import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home/home_screen.dart';
import '../auth/register_screen.dart'; // Make sure this is the correct import path

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber, _smsCode, _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _loginWithPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber!,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Fluttertoast.showToast(
              msg: "Phone number verified automatically!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          },
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(
              msg: e.message!,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            setState(() {
              _isLoading = false;
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "Verification code sent to $_phoneNumber",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              _verificationId = verificationId;
              _isLoading = false;
            });
          },
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _verifySMSCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();  // Ensure SMS code is saved

      if (_smsCode != null && _verificationId != null) {
        setState(() {
          _isLoading = true;
        });
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: _smsCode!,
          );
          await _auth.signInWithCredential(credential);
          Fluttertoast.showToast(
            msg: "Login successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Invalid verification code",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Please enter the verification code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
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
                onSaved: (input) => _phoneNumber = input,
              ),
              SizedBox(height: 20),
              if (_verificationId != null) ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Verification Code'),
                  validator: (input) => input!.isEmpty ? 'Enter Verification Code' : null,
                  onSaved: (input) => _smsCode = input,
                ),
                SizedBox(height: 20),
              ],
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _verificationId == null ? _loginWithPhoneNumber : _verifySMSCode,
                child: Text(_verificationId == null ? 'Send Verification Code' : 'Verify and Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationPage()));
                },
                child: Text("Don't have an account? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
