import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equipment_tracking/services/offline_storage.dart';

class OfflineSyncService {
  static void startListeningForConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        log("🌐 Internet reconnected! Syncing offline data...");
        await syncOfflineTransactions();
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  static Future<void> syncOfflineTransactions() async {
    List<Map<String, dynamic>> transactions = await OfflineStorage.getOfflineTransactions();

    for (var transaction in transactions) {
      try {
        await FirebaseFirestore.instance.collection('equipment_transactions').add(transaction);
        log("✅ Synced transaction for ${transaction['equipmentId']}");
      } catch (e) {
        log("❌ Failed to sync transaction: $e");
      }
    }

    await OfflineStorage.clearOfflineTransactions();
  }
}
