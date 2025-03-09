import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equipment_tracking/services/equipment_provider.dart';
import 'package:equipment_tracking/screens/equipment_details_scren.dart';

class EquipmentListScreen extends StatelessWidget {
  const EquipmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final equipmentProvider = Provider.of<EquipmentProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: equipmentProvider.equipmentList.length,
        itemBuilder: (context, index) {
          final equipment = equipmentProvider.equipmentList[index];
          return Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.amberAccent),
            ),
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                equipment['name'],
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.amberAccent),
              ),
              subtitle: Text(
                "Status: ${equipment['status']}",
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EquipmentDetailsScreen(equipment: equipment),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () {
          // Open add equipment form
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
