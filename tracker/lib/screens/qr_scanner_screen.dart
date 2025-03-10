// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});

//   @override
//   QRScannerScreenState createState() => QRScannerScreenState();
// }

// class QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   // QRViewController? controller;
//   bool isProcessing = false;
//   final Color craneYellow = const Color.fromARGB(255, 169, 143, 66);

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.resumeCamera();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (!isProcessing) {
//         isProcessing = true;
//         _processQRCode(scanData.code!);
//       }
//     });
//   }

//   Future<void> _processQRCode(String equipmentId) async {
//     try {
//       DocumentSnapshot equipmentDoc =
//           await FirebaseFirestore.instance.collection('equipment').doc(equipmentId).get();

//       if (!equipmentDoc.exists) {
//         _showSnackBar("❌ Equipment not found!");
//         isProcessing = false;
//         return;
//       }

//       Map<String, dynamic> equipmentData = equipmentDoc.data() as Map<String, dynamic>;
//       String currentStatus = equipmentData["status"];
//       String newStatus = currentStatus == "Available" ? "In Use" : "Available";

//       await FirebaseFirestore.instance.collection('equipment').doc(equipmentId).update({
//         "status": newStatus,
//         "lastUsedBy": "John Doe", // Replace with actual logged-in user later
//         "lastUsedAt": DateTime.now().toIso8601String(),
//       });

//       _showSnackBar("✅ Equipment status updated to: $newStatus");
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           Navigator.pop(context);
//         }
//       });
//     } catch (e) {
//       _showSnackBar("❌ Error updating equipment: $e");
//     } finally {
//       isProcessing = false;
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message, style: GoogleFonts.roboto(fontSize: 16))),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Scan Equipment QR", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: craneYellow)),
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Text(
//                 "Align the QR code within the frame",
//                 style: GoogleFonts.roboto(fontSize: 16, color: craneYellow),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
