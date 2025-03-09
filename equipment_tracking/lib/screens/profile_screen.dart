import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final Color craneYellow = const Color.fromARGB(255, 169, 143, 66); 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            "John Doe",
            style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: craneYellow),
          ),
          Text(
            "Supervisor",
            style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logout Logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: craneYellow,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
