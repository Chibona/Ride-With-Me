import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_mee/auth/login_screen.dart';
import 'package:ride_with_mee/driver_folder/driver_home_screen.dart';
import 'package:ride_with_mee/global/global.dart';
import 'package:ride_with_mee/user_folder/user_home.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser!;

        // Check the user type and navigate accordingly
        final userTypeSnapshot = await FirebaseFirestore.instance
            .collection('drivers')
            .where('user_id', isEqualTo: currentFirebaseUser!.uid)
            .limit(1)
            .get();

        if (userTypeSnapshot.docs.isNotEmpty) {
          // User is a driver
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const DriverHomeScreen()),
          );
        } else {
          // User is a passenger
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const PassHomeScreen()),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 60, 123, 165),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("asset/images/logo2.png"),
              const SizedBox(height: 10),
              const Text(
                "RIDE WITH ME",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
