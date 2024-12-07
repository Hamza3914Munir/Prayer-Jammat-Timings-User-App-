import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerJamatTimings extends StatefulWidget {
  final String documentId;
  final String masjidName;

  PrayerJamatTimings({required this.documentId, required this.masjidName});

  @override
  State<PrayerJamatTimings> createState() => _PrayerJamatTimingsState();
}

class _PrayerJamatTimingsState extends State<PrayerJamatTimings> {
  late Stream<DocumentSnapshot> _prayerTimesStream;

  @override
  void initState() {
    super.initState();
    _prayerTimesStream = FirebaseFirestore.instance
        .collection('Masjid')
        .doc(widget.documentId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),

      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _prayerTimesStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          // Extract prayer times and last updated dates from Firestore data
          List<Map<String, String>> prayers = [
            {
              'nameEng': 'Fajr',
              'time': data['Fajr'] ?? '00:00',
              'nameUrdu': 'فجر',
              'date': data['FajrDate'] ?? '00:00'
            },
            {
              'nameEng': 'Dhuhr',
              'time': data['Dhuhr'] ?? '00:00',
              'nameUrdu': 'ظهر',
              'date': data['DhuhrDate'] ?? '00:00'
            },
            {
              'nameEng': 'Asr',
              'time': data['Asr'] ?? '00:00',
              'nameUrdu': 'عصر',
              'date': data['AsrDate'] ?? '00:00'
            },
            {
              'nameEng': 'Maghrib',
              'time': data['Maghrib'] ?? '00:00',
              'nameUrdu': 'مغرب',
              'date': data['MaghribDate'] ?? '00:00'
            },
            {
              'nameEng': 'Isha',
              'time': data['Isha'] ?? '00:00',
              'nameUrdu': 'عشاء',
              'date': data['IshaDate'] ?? '00:00'
            },
            {
              'nameEng': 'Jumu\'ah',
              'time': data['Jumu\'ah'] ?? '00:00',
              'nameUrdu': 'جمعة',
              'date': data['Jumu\'ahDate'] ?? '00:00'
            },
          ];

          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF004D40), Color(0xFF00796B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      painter: IslamicArchPainter(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80,left: 110,right: 110),
                        child: Text(
                          widget.masjidName,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Prayer Info Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: prayers.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final prayer = prayers[index];
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.amber,width: 2),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prayer['nameEng']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Text(
                                    prayer['nameUrdu']!,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Time: ${prayer['time']!}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.amber),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last Updated: ${prayer['date']!}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.amber),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class IslamicArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Fill paint for the arch
    final fillPaint = Paint()
      ..color = Colors.transparent // Fill color
      ..style = PaintingStyle.fill;

    // Border paint for the arch
    final borderPaint = Paint()
      ..color = Colors.amber // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Border thickness

    // Adjusted height
    double adjustedHeight = size.height * 1.8; // Increase the height by 20%

    // Path for the filled shape (Islamic arch with increased height)
    Path fillPath = Path();
    fillPath.moveTo(size.width * 0.5, 0);
    fillPath.quadraticBezierTo(
        size.width * 0.1, adjustedHeight * 0.2, 0, adjustedHeight * 0.4);
    fillPath.lineTo(0, adjustedHeight);
    fillPath.lineTo(size.width, adjustedHeight);
    fillPath.lineTo(size.width, adjustedHeight * 0.4);
    fillPath.quadraticBezierTo(
        size.width * 0.9, adjustedHeight * 0.2, size.width * 0.5, 0);
    fillPath.close();

    // Path for the border (same as fillPath but without the bottom line)
    Path borderPath = Path();
    borderPath.moveTo(size.width * 0.5, 0);
    borderPath.quadraticBezierTo(
        size.width * 0.1, adjustedHeight * 0.2, 0, adjustedHeight * 0.4);
    borderPath.lineTo(0, adjustedHeight);
    borderPath.moveTo(size.width, adjustedHeight);
    borderPath.lineTo(size.width, adjustedHeight * 0.4);
    borderPath.quadraticBezierTo(
        size.width * 0.9, adjustedHeight * 0.2, size.width * 0.5, 0);

    // Draw the filled shape
    canvas.drawPath(fillPath, fillPaint);

    // Draw the border
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



