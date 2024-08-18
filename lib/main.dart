import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth/login_screen.dart';
import 'home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseConnected = false;

  try {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDq3yGgE9A4dX7EET3kERPh5-Qzy4Kbax8",
        appId: "1:311426102122:android:2100e2ba9b8336dd35eb13",
        messagingSenderId: "311426102122",
        projectId: "assignment-484d6",
        storageBucket: "assignment-484d6.appspot.com",
      ),
    );
    isFirebaseConnected = true;
    Fluttertoast.showToast(msg: "Successfully connected to Firebase");
  } catch (e) {
    Fluttertoast.showToast(msg: "Failed to connect to Firebase: $e");
    print("Failed to connect to Firebase $e");
  }

  runApp(MyApp(isFirebaseConnected: isFirebaseConnected));
}

class MyApp extends StatelessWidget {
  final bool isFirebaseConnected;

  MyApp({Key? key, required this.isFirebaseConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseConnected) {
      Fluttertoast.showToast(msg: "Firebase is not connected");
    }

    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Assignment',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: child,
        );
      },
      child: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return HomeScreen();
    } else {
      return LoginPage();
    }
  }
}
