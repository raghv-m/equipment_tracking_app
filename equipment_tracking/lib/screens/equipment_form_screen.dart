import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equipment_tracking/services/equipment_provider.dart';

class EquipmentFormScreen extends StatefulWidget {
  final String? equipmentId;
  final Map<String, dynamic>? initialData;

  const EquipmentFormScreen({this.equipmentId, this.initialData, super.key});

  @override
  EquipmentFormScreenState createState() => EquipmentFormScreenState();
}

class EquipmentFormScreenState extends State<EquipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _status = "Available";
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'];
      _status = widget.initialData!['status'];
      _locationController.text = widget.initialData!['location'];
    }
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final equipmentProvider = Provider.of<EquipmentProvider>(context, listen: false);

    Map<String, dynamic> equipmentData = {
      'name': _nameController.text.trim(),
      'status': _status,
      'location': _locationController.text.trim(),
    };

    if (widget.equipmentId == null) {
      equipmentProvider.addEquipment(equipmentData);
    } else {
      equipmentProvider.updateEquipment(widget.equipmentId!, equipmentData);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Manage Equipment", style: GoogleFonts.roboto(color: Colors.amberAccent)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.roboto(color: Colors.white),
                decoration:const InputDecoration(labelText: "Equipment Name", labelStyle: TextStyle(color: Colors.amberAccent)),
                validator: (value) => value!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status", labelStyle: TextStyle(color: Colors.amberAccent)),
                items: ["Available", "In Use", "Maintenance"].map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                style: GoogleFonts.roboto(color: Colors.white),
                decoration: const InputDecoration(labelText: "Location", labelStyle: TextStyle(color: Colors.amberAccent)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => _submitForm(context), child:const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
