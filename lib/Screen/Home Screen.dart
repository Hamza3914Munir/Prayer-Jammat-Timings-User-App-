import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Notifications.dart';
import '../Provider/SelectMasjid.dart';
import 'Masjid%20Details.dart';

class MasjidsScreen extends StatefulWidget {
  MasjidsScreen({Key? key}) : super(key: key);

  @override
  State<MasjidsScreen> createState() => _MasjidsScreenState();
}

class _MasjidsScreenState extends State<MasjidsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _masjids = [];
  List<Map<String, dynamic>> filteredMasjids = [];

  Future<List<Map<String, dynamic>>> fetchMasjids() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Masjid').get();
    _masjids = querySnapshot.docs
        .map((doc) => {
      ...doc.data() as Map<String, dynamic>,
      'documentID': doc.id,
    })
        .toList();
    filteredMasjids = _masjids;
    return _masjids;
  }

  @override
  void initState() {
    super.initState();
    Notifications().requestPermission();
    _searchController.addListener(_filterMasjids);
    // Load selected masjids when the screen initializes
    Provider.of<SelectMasjid>(context, listen: false).loadSelectedMasjids();
  }

  void _filterMasjids() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMasjids = _masjids.where((masjid) {
        String masjidName = masjid['masjidname']?.toLowerCase() ?? '';
        return masjidName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004D40),
        title: const Text(
          'Masjids',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: Container(
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
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: 'Search masjids...',
                  hintStyle: TextStyle(color: Colors.amber),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.amber,
                      width: 3,
                    ),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 3,
                    ),
                  ) ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 3,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchMasjids(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No masjids found'));
                  }

                  List<Map<String, dynamic>> masjids = snapshot.data!;

                  return ListView.builder(
                    itemCount: masjids.length,
                    itemBuilder: (context, index) {
                      String masjidName = masjids[index]['masjidname'] ?? 'Unknown';
                      String address =
                          masjids[index]['address'] ?? 'No address available';
                      String documentId = masjids[index]['documentID'];

                      // Initialize masjid selection state
                      Provider.of<SelectMasjid>(context, listen: false)
                          .initializeMasjid(documentId);

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.amber, width: 3)),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrayerJamatTimings(
                                        masjidName: masjidName,
                                        documentId: documentId)));
                          },
                          tileColor: Colors.white.withOpacity(0.1),
                          trailing: Consumer<SelectMasjid>(
                            builder: (context, selectMasjid, child) {
                              bool isSelected =
                              selectMasjid.isMasjidSelected(documentId);
                              return InkWell(
                                onTap: () {
                                  if (isSelected) {
                                    Notifications().verifyNotifications(
                                        context, "Remove", masjidName, () {
                                      Notifications().removeToken(documentId);
                                      selectMasjid.toggleMasjidSelection(documentId);
                                    }, "remove", "no longer");
                                  } else {
                                    Notifications().verifyNotifications(
                                        context, "Add", masjidName, () {
                                      Notifications().addToken(documentId);
                                      selectMasjid.toggleMasjidSelection(documentId);
                                    }, "add", "now");
                                  }
                                },
                                child: Icon(
                                  isSelected ? Icons.star : Icons.star_border,
                                  color: isSelected ? Colors.yellowAccent : Colors.white,
                                ),
                              );
                            },
                          ),
                          leading: Icon(
                            Icons.mosque,
                            size: 50,
                            color: Colors.amber,
                          ),
                          title: Text(
                            masjidName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                fontSize: 18),
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address,
                                  softWrap: true,
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
