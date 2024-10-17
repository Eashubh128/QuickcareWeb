// import 'dart:developer';

// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:fluttertoast/fluttertoast.dart';

// class LoginProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User? _user;

//   User? get user => _user;

//   Future<bool> signIn(
//     String email,
//     String password,
//   ) async {
//     try {
//       _user = await _signInWithEmailAndPassword(email, password);

//       notifyListeners();
//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       return false;
//     }
//   }

//   Future<bool> signOut() async {
//     try {
//       await _signOut();
//       _user = null;
//       notifyListeners();
//       Fluttertoast.showToast(msg: "Logged Out");
//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       return false;
//     }
//   }

//   Future<bool> resetPassword(String email) async {
//     try {
//       // await _resetPassword(email);
//       await requestPasswordReset(email);
//       await Fluttertoast.showToast(
//           toastLength: Toast.LENGTH_LONG,
//           msg: "A password reset mail has been sent to registered email.");

//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       return false;
//     }
//   }

//   Future<bool> createAccount(String name, String email, String password,
//       {String accType = "SM"}) async {
//     try {
//       _user = await _createAccount(name, email, password, accType);
//       notifyListeners();
//       return true;
//     } catch (e) {
//       // Fluttertoast.showToast(msg: e.toString());
//       return false;
//     }
//   }

//   checkLoggedInUser() async {
//     try {
//       _user = _auth.currentUser;
//       notifyListeners();
//     } catch (e) {
//       log("Error ocurred in checking logged in user ${e.toString()} ");
//     }
//   }

//   Future<void> _signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       throw e.toString();
//     }
//   }

//   Future<User?> _signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       print("$email + $password");
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       print(userCredential.toString());
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Error: ${e.message}");
//       throw e.message.toString();
//     }
//   }

//   Future<void> _resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       print("Error: ${e.message}");
//       throw Exception(e.message);
//     }
//   }

//   Future<User?> _createAccount(
//       String name, String email, String password, String accType) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Update user's display name
//       if (accType == "admin") {
//         await userCredential.user?.updateDisplayName("AD_$name");
//       } else {
//         await userCredential.user?.updateDisplayName("SM_$name");
//       }

//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Error: ${e.message}");
//       throw "${e.message}";
//     }
//   }

//   Future<void> requestPasswordReset(String email) async {
//     try {
//       final HttpsCallable callable =
//           FirebaseFunctions.instance.httpsCallable('requestPasswordReset');
//       final result = await callable.call({'email': email});
//       print(result.data);
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
