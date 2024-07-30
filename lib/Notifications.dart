import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class Notifications {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userToken;

  Future<void> requestPermission() async {
    try {
      PermissionStatus status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Permission not granted');
      }
      if (status == PermissionStatus.granted) {
        NotificationSettings settings = await FirebaseMessaging.instance
            .requestPermission(
                alert: true,
                announcement: true,
                badge: true,
                carPlay: true,
                criticalAlert: true,
                provisional: true,
                sound: true);
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          print("user granted permission");
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          print("user granted provisional permission");
        } else {
          SnackBar(
            content: Text(
                "Notifications Permission Denied\n Please allow notifications to receive updates."),
          );
        }
      }
    } catch (e) {
      print('Error requesting permission: $e');
    }
  }

  Future<void> getToken() async {
    try {
      // Get the initial token
      userToken = await FirebaseMessaging.instance.getToken();
      if (userToken != null) {
        print('Initial token get Successfully : $userToken');
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print('Token refreshed: $newToken');
        // Save or send the new token to your server
      }).onError((error) {
        print('Error on token refresh: $error');
      });
    } catch (e) {
      print('Error getting token: ${e.toString()}');
    }
  }

  Future<void> addToken(String documentId) async {
    await getToken();
    try {
      if (userToken == null) {
        throw Exception('Token is null');
      }

      DocumentReference mainDocumentRef =
          firestore.collection("Masjid").doc(documentId);
      await mainDocumentRef.update({
        "UserTokens": FieldValue.arrayUnion([userToken]),
      });
      print('Token added successfully');
    } catch (e) {
      print('Error adding token: ${e.toString()}');
    }
  }

  Future<void> removeToken(String documentId) async {
    await getToken();
    try {
      if (userToken == null) {
        throw Exception('Token is null');
      }

      DocumentReference mainDocumentRef =
          firestore.collection("Masjid").doc(documentId);
      await mainDocumentRef.update({
        "UserTokens": FieldValue.arrayRemove([userToken]),
      });
      print('Token removed successfully');
    } catch (e) {
      print('Error removing token: ${e.toString()}');
    }
  }

  Future<void> verifyNotifications(BuildContext context, String text,
      String masjidName, Function onConfirm, String text1, String text2) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text Masjid as Favourite'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to $text1 $masjidName as favourite?'),
                SizedBox(height: 10),
                Text('You will $text2 get notifications about this masjid.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }
}
