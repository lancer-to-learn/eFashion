import 'package:e_fashion/common/views/login_screen.dart';
import 'package:e_fashion/user/views/home_screen/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'consts/consts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  // databaseFactory = databaseFactoryFfi;
  databaseFactory = databaseFactoryFfiWeb;
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCWmJ89tgypt4ijO6huMxCsHZ-JcLLJqK8", 
      appId: "1:776815399611:android:e9791f593be53b98120f9e", 
      messagingSenderId: "776815399611", 
      projectId: "efashion-f1112"
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // changing MaterialApp to GetMaterialApp due to using getX
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          // set app bar icon color
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent),
          fontFamily: regular,
      ),
      home: const LoginScreen(),
    );
  }
}
