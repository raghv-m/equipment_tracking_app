import 'request_screen.dart';
import 'reports_screen.dart';
import 'equipment_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final Color craneYellow = const Color.fromARGB(255, 169, 143, 66);

  final List<Widget> _screens = [
    EquipmentListScreen(),
    const RequestsScreen(),
    const ReportsScreen(),
    const ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// ✅ **Logout Function (Corrected)**
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint("✅ [Auth] User logged out successfully.");

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      debugPrint("❌ [Auth] Logout failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: craneYellow,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // ✅ Fixed Logout Call
          ),
        ],
      ),
      body: _screens[_selectedIndex], // ✅ Ensure all screens are present
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: craneYellow,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: craneYellow,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EquipmentListScreen()),
          );
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
      ),
    );
  }
}
