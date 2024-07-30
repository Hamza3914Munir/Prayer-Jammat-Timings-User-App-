import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prayer_jamat_timings/Screen/Home%20Screen.dart';
import 'package:provider/provider.dart';
import 'Provider/SelectMasjid.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(create: (context) => SelectMasjid(),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prayer Jamat Timings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MasjidsScreen(),
    );
  }
}

