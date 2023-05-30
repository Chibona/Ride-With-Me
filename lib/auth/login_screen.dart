import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/auth/singup_screen.dart';
import 'package:ride_with_mee/global/global.dart';
import 'package:ride_with_mee/splashscreen/splash_screen.dart';
import 'package:ride_with_mee/widgets/progress_dialog.dart';

import 'carinfo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Login, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error" + msg.toString());
    }))
        .user;
    if (firebaseUser != null) {
      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Login Successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occured during Login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 101, 150, 156),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const SizedBox(height: 10),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              //child: Image.asset("asset/images/logo2.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            // const Text(
            //   "Login",
            //   style: TextStyle(
            //     fontSize: 26,
            //     color: Color.fromARGB(255, 255, 255, 255),
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 10,
                ),
              ),
            ),
            TextField(
              controller: passwordTextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                validateForm();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 39, 179, 167),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              child: const Text(
                "Do Not Have An Account? SignUp Here",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SignUpScreen()));
              },
            )
          ],
        ),
      )),
    );
  }
}
