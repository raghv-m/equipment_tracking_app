import 'screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_provider.dart' as my_auth_provider; 
import 'services/equipment_provider.dart' as equipment_provider; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          debugPrint("✅ User logged in. Navigating to Dashboard...");
          return const DashboardScreen();
        } else {
          debugPrint("🚪 No user found. Redirecting to Auth Screen...");
          return const AuthScreen();
        }
      },
    );
  }
}
