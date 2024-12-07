import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart'; // For formatting prayer times
import '../Location.dart';

class CurrentCityPrayerTimes extends StatefulWidget {
  @override
  _CurrentCityPrayerTimesState createState() => _CurrentCityPrayerTimesState();
}

class _CurrentCityPrayerTimesState extends State<CurrentCityPrayerTimes> {
  final Location _location = Location();
  String? _currentCity;
  Map<String, String>? _prayerTimes;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndPrayerTimes();
  }

  Future<void> _fetchLocationAndPrayerTimes() async {
    await _location.determinePosition();
    if (_location.currentAddress != null && _location.currentPosition != null) {
      // Fetch prayer times using Adhan package
      final coordinates = Coordinates(
        _location.currentPosition!.latitude,
        _location.currentPosition!.longitude,
      );
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;
      final prayerTimes = PrayerTimes.today(coordinates, params);

      setState(() {
        _currentCity =
            _location.currentAddress; // Use current city from Location
        _prayerTimes = {
          'Fajr': DateFormat.jm().format(prayerTimes.fajr),
          'Sunrise': DateFormat.jm().format(prayerTimes.sunrise),
          'Dhuhr': DateFormat.jm().format(prayerTimes.dhuhr),
          'Asr': DateFormat.jm().format(prayerTimes.asr),
          'Maghrib': DateFormat.jm().format(prayerTimes.maghrib),
          'Isha': DateFormat.jm().format(prayerTimes.isha),
        };
      });
    } else {
      setState(() {
        _currentCity = "Unknown City";
        _prayerTimes = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF004D40),
      appBar: AppBar(
        backgroundColor: Color(0xFF004D40),
      ),
      body: _currentCity == null || _prayerTimes == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004D40), Color(0xFF00796B)],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 400, // Adjust width
                  height: 600, // Increased height to fit prayer times inside arch
                  decoration: BoxDecoration(
                    color: Color(0xFF004D40), // Dark green background
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
                          painter: IslamicArchPainter(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 100, left: 50, right: 50),
                            child: Column(
                              children: [
                                Text(
                                  _currentCity!,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Serif',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30), // Space before prayer times
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _prayerTimes!.length,
                                    itemBuilder: (context, index) {
                                      String prayer = _prayerTimes!.keys.elementAt(index);
                                      String time = _prayerTimes![prayer]!;
                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.amber, width: 2), // Amber border with width 2
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              prayer,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            Text(
                                              time,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )

                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IslamicArchPainter extends CustomPainter {
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
