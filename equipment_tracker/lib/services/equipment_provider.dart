import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

  List<Map<String, dynamic>> _equipmentList = [];
  List<Map<String, dynamic>> get equipmentList => _equipmentList;
  EquipmentProvider() {
     _initializeFirestorePersistence();
    _initializeEquipment();
  }
   Future<void> _initializeFirestorePersistence() async {
    try  {
       _firestore.settings = const Settings(persistenceEnabled: true);
      debugPrint("✅ Firestore Offline Persistence Enabled.");
    } catch (e) {
      debugPrint("❌ Error enabling Firestore persistence: $e");
    }
  }

  final List<Map<String, dynamic>> _preFilledEquipment = [
    {
      "name": "Excavator",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Main Storage",
      "quantity": 5
    },
    {
      "name": "Bulldozer",
      "status": "In Use",
      "lastUsedBy": "Mike Johnson",
      "lastUsedAt": "2025-03-07T10:30:00Z",
      "location": "Site A",
      "quantity": 3
    },
    {
      "name": "Tower Crane",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Crane Yard",
      "quantity": 4
    },
    {
      "name": "Backhoe Loader",
      "status": "In Use",
      "lastUsedBy": "Sarah Lee",
      "lastUsedAt": "2025-03-06T15:45:00Z",
      "location": "Foundation Area",
      "quantity": 6
    },
    {
      "name": "Concrete Mixer",
      "status": "Under Maintenance",
      "lastUsedBy": "Mark Spencer",
      "lastUsedAt": "2025-03-05T09:00:00Z",
      "location": "Equipment Garage",
      "quantity": 7
    },
    {
      "name": "Dump Truck",
      "status": "In Use",
      "lastUsedBy": "Jack Robinson",
      "lastUsedAt": "2025-03-07T12:15:00Z",
      "location": "Site B",
      "quantity": 10
    },
    {
      "name": "Compactor",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Tool Shed",
      "quantity": 8
    },
    {
      "name": "Scaffolding Set",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Storage Yard",
      "quantity": 20
    },
    {
      "name": "Jackhammer",
      "status": "In Use",
      "lastUsedBy": "Kevin White",
      "lastUsedAt": "2025-03-06T17:20:00Z",
      "location": "Site C",
      "quantity": 12
    },
    {
      "name": "Welding Machine",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Workshop",
      "quantity": 6
    },
    {
      "name": "Safety Harness",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Safety Room",
      "quantity": 30
    },
    {
      "name": "Concrete Vibrator",
      "status": "In Use",
      "lastUsedBy": "Tom Hardy",
      "lastUsedAt": "2025-03-05T14:00:00Z",
      "location": "Concrete Pouring Area",
      "quantity": 5
    },
    {
      "name": "Forklift",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Warehouse B",
      "quantity": 4
    },
    {
      "name": "Portable Generator",
      "status": "In Use",
      "lastUsedBy": "Alex Cooper",
      "lastUsedAt": "2025-03-04T16:30:00Z",
      "location": "Power Supply Area",
      "quantity": 7
    },
    {
      "name": "Air Compressor",
      "status": "Under Maintenance",
      "lastUsedBy": "Rachel Green",
      "lastUsedAt": "2025-03-07T09:50:00Z",
      "location": "Tool Repair Room",
      "quantity": 4
    },
    {
      "name": "Drill Machine",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Tool Shed",
      "quantity": 15
    },
    {
      "name": "Chainsaw",
      "status": "In Use",
      "lastUsedBy": "Robert Wilson",
      "lastUsedAt": "2025-03-07T11:00:00Z",
      "location": "Timber Yard",
      "quantity": 5
    },
    {
      "name": "Ladder",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Maintenance Area",
      "quantity": 20
    },
    {
      "name": "Cement Mixer",
      "status": "In Use",
      "lastUsedBy": "James Brown",
      "lastUsedAt": "2025-03-07T13:30:00Z",
      "location": "Site D",
      "quantity": 5
    },
    {
      "name": "Plasma Cutter",
      "status": "Available",
      "lastUsedBy": "",
      "lastUsedAt": "",
      "location": "Metal Workshop",
      "quantity": 3
    }
  ];

 void _initializeEquipment() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('equipment').get();

      if (snapshot.docs.isEmpty) {
        for (var equipment in _preFilledEquipment) {
          equipment["qrCode"] = uuid.v4(); // Assign QR Code
          await _firestore.collection('equipment').add(equipment);
        }
        debugPrint("✅ Pre-filled equipment added to Firestore.");
      } else {
        debugPrint("✅ Equipment already exists in Firestore.");
      }

      _listenToEquipmentChanges();
    } catch (e) {
      debugPrint("❌ Error initializing equipment: $e");
    }
  }

  void _listenToEquipmentChanges() {
    _firestore.collection('equipment').snapshots().listen((snapshot) {
      _equipmentList = snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
      notifyListeners();
      debugPrint("📢 Equipment list updated (Real-time Sync)");
    });
  }

  Future<void> addEquipment(Map<String, dynamic> equipmentData) async {
    try {
      equipmentData["qrCode"] = uuid.v4(); // Assign QR Code
      await _firestore.collection('equipment').add(equipmentData);
      debugPrint("✅ Equipment added successfully!");
    } catch (e) {
      debugPrint("❌ Error adding equipment: $e");
    }
  }

  Future<void> updateEquipment(String id, Map<String, dynamic> equipmentData) async {
    try {
      await _firestore.collection('equipment').doc(id).update(equipmentData);
      debugPrint("✅ Equipment updated successfully!");
    } catch (e) {
      debugPrint("❌ Error updating equipment: $e");
    }
  }

  Future<void> deleteEquipment(String id) async {
    try {
      await _firestore.collection('equipment').doc(id).delete();
      debugPrint("✅ Equipment deleted successfully!");
    } catch (e) {
      debugPrint("❌ Error deleting equipment: $e");
    }
  }
}