import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equipment_tracking/screens/profile_screen.dart';
import 'package:equipment_tracking/screens/request_screen.dart';
import 'package:equipment_tracking/services/auth_provider.dart';
import 'package:equipment_tracking/screens/qr_scanner_screen.dart';
import 'package:equipment_tracking/screens/equipment_list_screen.dart';

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
    QRScannerScreen(),
    const RequestsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
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
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: craneYellow,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: craneYellow,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          );
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
      ),
    );
  }
}
