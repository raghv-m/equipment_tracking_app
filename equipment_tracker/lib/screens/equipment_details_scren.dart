import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EquipmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> equipment;

  const EquipmentDetailsScreen({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    final Color craneYellow = const Color.fromARGB(255, 169, 143, 66);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          equipment['name'],
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: craneYellow,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${equipment['status']}", 
              style: GoogleFonts.roboto(fontSize: 18, color: craneYellow)),
            const SizedBox(height: 10),
            Text("Location: ${equipment['location']}", 
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            Text("Last Used By: ${equipment['lastUsedBy'] ?? 'N/A'}", 
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            Text("Last Used At: ${equipment['lastUsedAt'] ?? 'N/A'}", 
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            Text("Quantity Available: ${equipment['quantity']}", 
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: craneYellow,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Go Back", 
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
