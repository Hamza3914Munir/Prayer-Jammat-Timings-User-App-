import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerJamatTimings extends StatefulWidget {
  final String masjidName;
  final String documentId;

  PrayerJamatTimings({required this.masjidName, required this.documentId});

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
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text(
          widget.masjidName,
          style:
          TextStyle(color: Color(0xFF000080), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Optional: Add logic to manually trigger refresh
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 60, bottom: 60),
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.lightGreenAccent, width: 10),
            borderRadius: BorderRadius.circular(20)),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _prayerTimesStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No data available'));
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
                'nameUrdu': 'ضهر',
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

            return LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                    constraints.maxWidth / constraints.maxWidth,
                  ),
                  itemCount: prayers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pinkAccent, width: 5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                prayers[index]['nameEng']!,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                              Text(
                                prayers[index]['nameUrdu']!,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Jammat Time',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            prayers[index]['time']!,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Last update: ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                prayers[index]['date']!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
