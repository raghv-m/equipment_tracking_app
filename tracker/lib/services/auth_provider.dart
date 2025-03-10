import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners(); 
    });
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String companyName,
    String city,
    String province,
    String role
  ) async {
    try {
      //  Check if role is valid
      List<String> validRoles = ["Worker", "Supervisor", "Admin"];
      if (!validRoles.contains(role)) {
        throw Exception("Invalid role selected.");
      }

      debugPrint("Creating user in Firebase...");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
       String initials = (firstName.isNotEmpty ? firstName[0] : "") +
          (lastName.isNotEmpty ? lastName[0] : "");


      debugPrint("Saving user role and details in Firestore...");
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
        'city': city,
        'province': province,
        'role': role,
        'initials': initials.toUpperCase(), 
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("Signup process completed successfully!");
      notifyListeners();
    } catch (e) {
      debugPrint("Error in signUp: ${e.toString()}");
      throw Exception("Sign-up failed: ${e.toString()}");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Password reset failed: ${e.toString()}");
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception("User data update failed: ${e.toString()}");
    }
    notifyListeners();
  }
}
