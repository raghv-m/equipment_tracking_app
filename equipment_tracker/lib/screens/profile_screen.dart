import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;

  bool _darkMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _roleController = TextEditingController();
    _loadUserData();
    _loadDarkMode();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _nameController.text = doc["firstName"] + " " + doc["lastName"];
            _phoneController.text = doc["phone"] ?? "";
            _roleController.text = doc["role"] ?? "";
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading user data: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _darkMode = prefs.getBool("darkMode") ?? false);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);
    setState(() => _darkMode = value);
  }

  Future<void> _resetPassword() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _auth.sendPasswordResetEmail(email: user.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password Reset Email Sent!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending reset email: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = _nameController.text.isNotEmpty
        ? _nameController.text.split(" ").map((e) => e[0]).take(2).join("")
        : "?";

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.amber,
                    child: Text(
                      initials,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
                  TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
                  TextField(controller: _roleController, decoration: const InputDecoration(labelText: "Role")),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dark Mode"),
                      Switch(value: _darkMode, onChanged: _toggleDarkMode),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _resetPassword,
                    child: const Text("Reset Password"),
                  ),
                ],
              ),
            ),
    );
  }
}
