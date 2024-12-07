import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prayer_jamat_timings/Provider/SelectMasjid.dart';
import 'package:prayer_jamat_timings/Screen/Namaz%20Timing.dart';
import 'package:provider/provider.dart';
import 'Screen/Home Screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectMasjid(),
      child: MyApp(),
    ),
  );
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
      home: PrayerAppHome(), // Updated to use the PrayerAppHome widget
    );
  }
}

class PrayerAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004D40),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF00796B)],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  width: 300, // Adjust width
                  height: 400, // Adjust height
                  decoration: BoxDecoration(
                    color: Color(0xFF004D40), // Dark green background
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Color(0xFF004D40), Color(0xFF00796B)],
                      // Gradient effect
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ), // Gold border
                  ),
                  child: Stack(
                    children: [
                      // Islamic Arch Design
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ArchPainter(),
                        ),
                      ),
                      // Content
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title in English
                            Text(
                              "Timely Prayers",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                            SizedBox(height: 10),
                            // Title in Urdu (Basic Font)
                            Text(
                              "اوقات نماز",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // First Container: Jamat Timings
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MasjidsScreen()));
                    },
                    child: Container(
                      width: 170,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color(0xFF00796B),
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // First Row: Jamat Icon with Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'lib/assets/jamat_icon.png',
                                // Correct path to your image
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Second Row: Text for Jamat Timings
                          Text(
                            "JAMAT TIMINGS",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Second Container: Namaz Timings
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrentCityPrayerTimes()));
                    },
                    child: Container(
                      width: 170,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color(0xFF00796B),
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // First Row: Namaz Icon with Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'lib/assets/namaz_icon.png',
                                // Correct path to your image
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Second Row: Text for Namaz Timings
                          Text(
                            "NAMAZ TIMINGS",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.1)
      ..style = PaintingStyle.fill;

    Path path = Path();
    // Draw the Islamic arch shape
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.2, 0, size.height * 0.4);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.2,
        size.width * 0.5, 0); // Arch top curve
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
