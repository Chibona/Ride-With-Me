import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/splashscreen/splash_screen.dart';
import 'package:ride_with_mee/widgets/progress_dialog.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();
  TextEditingController carNumberOfSeatsTextEditingController =
      TextEditingController();

  Future<void> saveCarInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Processing, Please wait...",
        );
      },
    );

    Map<String, dynamic> driverCarInfoMap = {
      "carModel": carModelTextEditingController.text.trim(),
      "carNumber": carNumberTextEditingController.text.trim(),
      "carColor": carColorTextEditingController.text.trim(),
      "carNumberOfSeats": carNumberOfSeatsTextEditingController.text.trim(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('car_details')
          .add(driverCarInfoMap);
      Fluttertoast.showToast(msg: "Car Details have been saved");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to save car details");
    } finally {
      Navigator.pop(context); // Dismiss the progress dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 150, 156),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const SizedBox(height: 10),
              const Text(
                "Write Car Details",
                style: TextStyle(
                  fontSize: 26,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: carModelTextEditingController,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Car Model",
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
                controller: carNumberTextEditingController,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  labelText: "Car Plate Number",
                  hintText: "Car Plate Number",
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
                controller: carColorTextEditingController,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  labelText: "Car Color",
                  hintText: "Car Color",
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 253, 253, 253)),
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
                controller: carNumberOfSeatsTextEditingController,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  labelText: "Number of Seats",
                  hintText: "Number of Seats",
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
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (carColorTextEditingController.text.isNotEmpty &&
                      carModelTextEditingController.text.isNotEmpty &&
                      carNumberOfSeatsTextEditingController.text.isNotEmpty &&
                      carNumberTextEditingController.text.isNotEmpty) {
                    saveCarInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 39, 179, 167),
                ),
                child: const Text(
                  "Save Now",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
