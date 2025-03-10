import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Background Message Handler
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("📩 [Background Notification] ${message.notification?.title}");
  }

  // Initialize Notifications
  static Future<void> initialize() async {
    // Request permissions
    await requestNotificationPermission();

    // Configure local notification settings
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);
    
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground Message Handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📩 [Foreground Notification] ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // When the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("📲 [User Opened Notification] ${message.notification?.title}");
    });

    // Get the FCM token for this device
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      log("📲 [FCM Token] $token");
      await saveTokenToFirestore(token);
    }
  }

  // Request Notification Permissions
  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("✅ [NotificationService] Push notifications enabled!");
    } else {
      log("❌ [NotificationService] User denied push notifications.");
    }
  }

  // Store the FCM Token in Firestore
  static Future<void> saveTokenToFirestore(String token) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(token).set({
        'token': token,
        'timestamp': FieldValue.serverTimestamp(),
      });
      log("✅ [Firestore] FCM Token saved successfully");
    } catch (e) {
      log("❌ [Firestore] Error saving FCM Token: $e");
    }
  }

  // Send Push Notification (Admin Only)
  static Future<void> sendNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    final String serverKey = "BPXotm6gaNRVDRYC19AWzkLNbJBqq6hrlbJQ4bDHpWAgpPGkZOPhF7E70VactohW9dIMSP8diuJuA3g2yKn5uMA"; 

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'token': token,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log("✅ [NotificationService] Notification sent successfully!");
    } catch (e) {
      log("❌ [NotificationService] Error sending notification: $e");
    }
  }

  // Show Local Notification (Foreground)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformChannelSpecifics,
    );
  }
}
