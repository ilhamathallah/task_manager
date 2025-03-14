import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return user jika berhasil
    } catch (e) {
      print("Error during sign-in: $e");
      return null; // Return null jika terjadi error
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print("User : ${userCredential.user}");
      }
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> addNote(String title, String subtitle) async {
    String? userId = _auth.currentUser!.uid;
    DateTime time = new DateTime.now();
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("task")
          .add({
        "title": title,
        "subtitle": subtitle,
        "userId": userId,
        "time": '${time.hour}:${time.minute}',
        "createdAt": FieldValue.serverTimestamp()
      });
    }
  }

  Stream<QuerySnapshot> getNotes() {
    String? userId = _auth.currentUser!.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("task")
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  Future<void> checkTask(String docId, Map<String, dynamic> newData) async {
    await FirebaseFirestore.instance
        .collection("task")
        .doc(docId)
        .update(newData);
  }

  
}
