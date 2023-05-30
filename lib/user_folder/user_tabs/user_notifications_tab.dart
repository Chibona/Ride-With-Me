import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserNotificationsTab extends StatefulWidget {
  const UserNotificationsTab({Key? key}) : super(key: key);

  @override
  State<UserNotificationsTab> createState() => _UserNotificationsTabState();
}

class _UserNotificationsTabState extends State<UserNotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Notifications',
          style: TextStyle(color: Color.fromARGB(255, 49, 59, 55)),
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
                  var driverDetails = snapshot.data!.docs[0];
                  return Container(
                    width: double.infinity,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('accept_request')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var rideProgress = snapshot.data!.docs[0];
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
                                    '${driverDetails['first_name']} ${driverDetails['last_name']} ${rideProgress['accept_msg']}',
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
