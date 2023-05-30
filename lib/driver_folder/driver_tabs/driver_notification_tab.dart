import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/global/global.dart';

class DriverNotificationsTab extends StatefulWidget {
  const DriverNotificationsTab({Key? key});

  @override
  State<DriverNotificationsTab> createState() => _DriverNotificationsTabState();
}

class _DriverNotificationsTabState extends State<DriverNotificationsTab> {
  @override
  Widget build(BuildContext context) {
    void showErrorSnackBar(String message) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _acceptRequest() {
      // Save the locations to Firestore
      FirebaseFirestore.instance
          .collection('accept_request')
          .add({
            'user_id': currentFirebaseUser!.uid.toString(),
            'accept_msg': "has accepted your requested"
          })
          .then((value) {})
          .catchError((error) {
            showErrorSnackBar('Failed to accept request: $error');
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Driver Notifications',
          style: TextStyle(color: Color.fromARGB(255, 53, 68, 67)),
        ),
        centerTitle: true,
        elevation: 10,
        leading: const Text(''),
        backgroundColor: Color.fromARGB(255, 147, 255, 241),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var userDetails = snapshot.data!.docs[index];
                  return Container(
                    width: double.infinity, // Ensure container takes full width
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('send_request')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var rideProgress = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 157, 221, 176),
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${userDetails['fName']} ${userDetails['lName']} ${rideProgress['msg']}',
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Do you want to accept this request?'),
                                        actions: [
                                          GestureDetector(
                                            child: const Text('Yes'),
                                            onTap: () {
                                              // Logic to accept ride goes here
                                              _acceptRequest();
                                              Fluttertoast.showToast(
                                                  msg: 'Successfully Accepted');
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            child: const Text('No'),
                                            onTap: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
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
