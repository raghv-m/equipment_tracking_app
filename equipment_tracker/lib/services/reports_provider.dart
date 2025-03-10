import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch Equipment Usage Logs from Firestore
  Future<List<Map<String, dynamic>>> fetchEquipmentLogs() async {
    QuerySnapshot snapshot = await _firestore.collection('equipment_logs').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  /// Generate PDF Report
  Future<void> generatePDFReport() async {
    final pdf = pw.Document();
    final logs = await fetchEquipmentLogs();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Equipment Usage Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ["Equipment", "User", "Date", "Status"],
                data: logs.map((log) => [log["equipment"], log["user"], log["date"], log["status"]]).toList(),
              )
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/Equipment_Report.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  /// Generate Excel Report
Future<void> generateExcelReport() async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Equipment Logs'];

  // Add headers with CellValue
  sheet.appendRow([
    TextCellValue("Equipment"),
    TextCellValue("User"),
    TextCellValue("Date"),
    TextCellValue("Status")
  ]);

  // Add data
  final logs = await fetchEquipmentLogs();
  for (var log in logs) {
    sheet.appendRow([
      TextCellValue(log["equipment"].toString()),
      TextCellValue(log["user"].toString()),
      TextCellValue(log["date"].toString()),
      TextCellValue(log["status"].toString()),
    ]);
  }

  final output = await getExternalStorageDirectory();
  final file = File("${output!.path}/Equipment_Report.xlsx");
  await file.writeAsBytes(excel.encode()!);

  OpenFile.open(file.path);
}
}