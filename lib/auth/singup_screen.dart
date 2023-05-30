// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ride_with_mee/auth/carinfo_screen.dart';
// import 'package:ride_with_mee/auth/login_screen.dart';
// import 'package:ride_with_mee/widgets/progress_dialog.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController firstNameTextEditingController =
//       TextEditingController();
//   TextEditingController lasstNameTextEditingController =
//       TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController phoneTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();
//   List<String> userTypeList = ["Driver", "Passenger"];
//   String? selectedUserType;

//   @override
//   void initState() {
//     super.initState();
//     Firebase.initializeApp();
//   }

//   validateForm() {
//     if (firstNameTextEditingController.text.length < 3) {
//       Fluttertoast.showToast(msg: "name must be at least 3 characters");
//     } else if (!emailTextEditingController.text.contains("@")) {
//       Fluttertoast.showToast(msg: "Email address is not valid");
//     } else if (passwordTextEditingController.text.length < 6) {
//       Fluttertoast.showToast(msg: "Password must be at least 6 characters");
//     } else if (phoneTextEditingController.text.length != 10) {
//       Fluttertoast.showToast(msg: "Phone Number must be 10 Digits");
//     } else if (selectedUserType == null || selectedUserType!.isEmpty) {
//       Fluttertoast.showToast(msg: "Please select a user type");
//     } else {
//       saveUserInfoNow();
//     }
//   }

//   saveUserInfoNow() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext c) {
//         return ProgressDialog(
//           message: "Processing, Please wait...",
//         );
//       },
//     );

//     try {
//       final UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailTextEditingController.text.trim(),
//         password: passwordTextEditingController.text.trim(),
//       );

//       if (userCredential.user != null) {
//         final userMap = {
//           "id": userCredential.user!.uid,
//           "fName": firstNameTextEditingController.text.trim(),
//           "lName": lasstNameTextEditingController.text.trim(),
//           "email": emailTextEditingController.text.trim(),
//           "phone": phoneTextEditingController.text.trim(),
//           "type": selectedUserType,
//         };

//         await FirebaseFirestore.instance.collection('drivers').add(userMap);

//         Fluttertoast.showToast(msg: "Account Has Been Created");
//         // ignore: use_build_context_synchronously
//         Navigator.push(
//             context, MaterialPageRoute(builder: (c) => const CarInfoScreen()));
//       } else {
//         Fluttertoast.showToast(msg: "Account Has Not Been Created");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 101, 150, 156),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Image.asset("asset/images/rideLogo.png"),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "Sign UP",
//                 style: TextStyle(
//                   fontSize: 26,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextField(
//                 controller: firstNameTextEditingController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: "First Name",
//                   hintText: "First Name",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: lasstNameTextEditingController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: "Last Name",
//                   hintText: "Last Name",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: emailTextEditingController,
//                 keyboardType: TextInputType.emailAddress,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintText: "Email",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: phoneTextEditingController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: "Phone",
//                   hintText: "Phone",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: passwordTextEditingController,
//                 keyboardType: TextInputType.text,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   hintText: "Password",
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   hintStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                   labelStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               DropdownButton(
//                 dropdownColor: Color.fromARGB(255, 4, 5, 5),
//                 hint: const Text(
//                   "Please Choose type of User",
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: Color.fromARGB(255, 0, 0, 0),
//                   ),
//                 ),
//                 value: selectedUserType,
//                 onChanged: (newValue) {
//                   setState(() {
//                     selectedUserType = newValue as String?;
//                   });
//                 },
//                 items: userTypeList.map((valueItem) {
//                   return DropdownMenuItem(
//                     value: valueItem,
//                     child: Text(
//                       valueItem,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   validateForm();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Color.fromARGB(255, 4, 5, 5),
//                   onPrimary: Colors.white,
//                 ),
//                 child: const Text("Sign UP"),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already have an account? ",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (c) => LoginScreen()));
//                     },
//                     child: const Text(
//                       "Login Here",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/auth/carinfo_screen.dart';
import 'package:ride_with_mee/auth/login_screen.dart';
import 'package:ride_with_mee/user_folder/user_home.dart';
import 'package:ride_with_mee/widgets/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  List<String> userTypeList = ["Driver", "Passenger"];
  String? selectedUserType;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  validateForm() {
    if (firstNameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
    } else if (phoneTextEditingController.text.length != 10) {
      Fluttertoast.showToast(msg: "Phone Number must be 10 Digits");
    } else if (selectedUserType == null || selectedUserType!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a user type");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Processing, Please wait...",
        );
      },
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      if (userCredential.user != null) {
        final userMap = {
          "user_id": userCredential.user!.uid,
          "fName": firstNameTextEditingController.text.trim(),
          "lName": lastNameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
          "type": selectedUserType,
        };

        if (selectedUserType == "Driver") {
          await FirebaseFirestore.instance.collection('drivers').add(userMap);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => CarInfoScreen()),
          );
        } else if (selectedUserType == "Passenger") {
          await FirebaseFirestore.instance.collection('users').add(userMap);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => PassHomeScreen()),
          );
        }

        Fluttertoast.showToast(msg: "Account Has Been Created");
      } else {
        Fluttertoast.showToast(msg: "Account Has Not Been Created");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 150, 156),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Sign UP",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: firstNameTextEditingController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "First Name",
                  hintText: "First Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              TextField(
                controller: lastNameTextEditingController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  hintText: "Last Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
              const SizedBox(height: 20),
              DropdownButton<String>(
                dropdownColor: const Color.fromARGB(255, 4, 5, 5),
                style: const TextStyle(color: Colors.white),
                value: selectedUserType,
                onChanged: (String? value) {
                  setState(() {
                    selectedUserType = value;
                  });
                },
                items: userTypeList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  primary: Colors.yellow[800],
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Already have an Account? Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
