import 'dart:developer';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/reports_provider.dart';
import 'services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_provider.dart' as my_auth_provider;
import 'services/equipment_provider.dart' as equipment_provider;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  await NotificationService.initialize();

  // Enable Firestore Offline Persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, 
  );

  log("✅ Firestore offline mode enabled");
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.requestNotificationPermission(); 
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ReportsProvider>(create: (_) => ReportsProvider()),
        ChangeNotifierProvider<my_auth_provider.AuthProvider>(
          create: (_) => my_auth_provider.AuthProvider(),
        ),
        ChangeNotifierProvider<equipment_provider.EquipmentProvider>(
          create: (_) => equipment_provider.EquipmentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.amberAccent),
            ),
          );
        }

        if (snapshot.hasData) {
          log("✅ [Auth] User Logged In - Navigating to Dashboard");
          return const DashboardScreen();
        } else {
          log("🚪 [Auth] No User Found - Redirecting to Auth Screen");
          return const AuthScreen();
        }
      },
    );
  }
}
