import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/reports_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment Reports"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              Provider.of<ReportsProvider>(context, listen: false).generatePDFReport();
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: () {
              Provider.of<ReportsProvider>(context, listen: false).generateExcelReport();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ReportsProvider>(context, listen: false).fetchEquipmentLogs(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No logs available"));
          }

          List<Map<String, dynamic>> data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarChart(
              BarChartData(
                barGroups: data.map((log) {
                  return BarChartGroupData(
                    x: data.indexOf(log),
                    barRods: [
                      BarChartRodData(
                        toY: (log["usageCount"] ?? 1).toDouble(),
                        color: Colors.blue, // ✅ Fixed color issue
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          data[value.toInt()]["equipment"].toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
