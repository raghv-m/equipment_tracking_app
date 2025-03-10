import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';


class OfflineStorage {
  static Future<void> saveOfflineTransaction(Map<String, dynamic> transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? transactions = prefs.getStringList('offline_transactions') ?? [];
    transactions.add(jsonEncode(transaction));
    await prefs.setStringList('offline_transactions', transactions);
    log("💾 Saved offline transaction: ${transaction['equipmentId']}");
  }

  static Future<List<Map<String, dynamic>>> getOfflineTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? transactions = prefs.getStringList('offline_transactions') ?? [];
    return transactions.map((t) => jsonDecode(t) as Map<String, dynamic>).toList();
  }

  static Future<void> clearOfflineTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('offline_transactions');
    log("🗑️ Cleared offline transactions");
  }
}
