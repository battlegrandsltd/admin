import 'package:battlegrands_admin/Admin_Home.dart';
import 'package:battlegrands_admin/admin_panel.dart';
import 'package:battlegrands_admin/create_tournament.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:battlegrands_admin/login.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD9EX-iOi-lWi849-_ht7kJj-w6FljyYfg",
        authDomain: "playground-ghana.firebaseapp.com",
        databaseURL: "https://playground-ghana-default-rtdb.firebaseio.com",
        projectId: "playground-ghana",
        storageBucket: "playground-ghana.appspot.com",
        messagingSenderId: "535305991704",
        appId: "1:535305991704:web:3328e512d7bee35595b56d",
        measurementId: "G-E7Q3DN79D3",
      ),
    );

    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battlegrands',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AdminPanel(),
    );
  }
}
