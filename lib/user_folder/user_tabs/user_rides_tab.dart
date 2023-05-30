import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/global/global.dart';

class UserRidesTab extends StatelessWidget {
  const UserRidesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showErrorSnackBar(String message) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _sendRequest() {
      // Save the locations to Firestore
      FirebaseFirestore.instance.collection('send_request').add({
        'user_id': currentFirebaseUser!.uid.toString(),
        'msg': "has requested a ride with you"
      }).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Request Sent successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        showErrorSnackBar('Failed to save locations: $error');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Rides',
          style: TextStyle(color: Color.fromARGB(255, 40, 51, 47)),
        ),
        centerTitle: true,
        elevation: 10,
        leading: const Text(''),
        backgroundColor: Color.fromARGB(255, 195, 228, 226),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var driverDetails = snapshot.data!.docs[index];
                  return Container(
                    height: 690,
                    width: 500,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('ride_details')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index2) {
                              var rideDetails = snapshot.data!.docs[index2];
                              return InkWell(
                                child: ListTile(
                                  leading: Image.asset(
                                      "asset/images/car_rides2.png"),
                                  title: Text(
                                      '${driverDetails['first_name']} ${driverDetails['last_name']}'),
                                  subtitle: Text(
                                      '${rideDetails['pickup_location']} to ${rideDetails['dropoff_location']}'),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Do you want to send a ride request?'),
                                        actions: [
                                          GestureDetector(
                                            child: const Text('Yes'),
                                            onTap: () {
                                              _sendRequest();
                                              //Logic to accept ride goes here
                                              // Fluttertoast.showToast(
                                              //     msg: 'Successfully sent');
                                              // Navigator.pop(context);
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            child: const Text('No'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
