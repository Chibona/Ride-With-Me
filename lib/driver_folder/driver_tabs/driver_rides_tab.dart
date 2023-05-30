// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ride_with_mee/driver_folder/driver_pages/driver_ride_page.dart';
// import 'package:ride_with_mee/global/global.dart';
// //import 'package:ride_with_mee/pages/driver_ridescreate_page.dart';

// class DriverRidesTab extends StatelessWidget {
//   const DriverRidesTab({Key? key}) : super(key: key);

// Future<void> showRideDetailsDialog(BuildContext context) async {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Enter Ride Details'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: 'From'),
//             ),
//             TextField(
//               decoration: const InputDecoration(labelText: 'To'),
//             ),
//             ListTile(
//               title: const Text('Date'),
//               subtitle: selectedDate != null
//                   ? Text(selectedDate.toString())
//                   : const Text('Select Date'),
//               onTap: () async {
//                 final DateTime? date = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2100),
//                 );
//                 if (date != null) {
//                   selectedDate = date;
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Time'),
//               subtitle: selectedTime != null
//                   ? Text(selectedTime!.format(context))
//                   : const Text('Select Time'),
//               onTap: () async {
//                 final TimeOfDay? time = await showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 );
//                 if (time != null) {
//                   selectedTime = time;
//                 }
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Save the ride details here
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       );
//     },
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_with_mee/driver_folder/driver_pages/driver_ride_page.dart';
import 'package:ride_with_mee/global/global.dart';
import 'package:intl/intl.dart';

//import 'package:ride_with_mee/pages/driver_ridescreate_page.dart';

String _formatDateTime(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  return formattedDateTime;
}

class DriverRidesTab extends StatelessWidget {
  const DriverRidesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Rides',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 10,
        leading: const Text(''),
        backgroundColor: Color.fromARGB(255, 167, 240, 236),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('drivers')
              .where('user_id', isEqualTo: currentFirebaseUser!.uid.toString())
              .snapshots(),
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
                          .where('user_id',
                              isEqualTo: currentFirebaseUser!.uid.toString())
                          .snapshots(),
                      builder: (context, rideDetailsSnapshot) {
                        // Rename the snapshot variable
                        if (rideDetailsSnapshot.hasData) {
                          return ListView.separated(
                            itemCount: rideDetailsSnapshot.data!.docs.length,
                            itemBuilder: (context, index2) {
                              var rideDetails =
                                  rideDetailsSnapshot.data!.docs[index2];
                              Timestamp rideDateTime = rideDetails['date'];
                              return InkWell(
                                child: ListTile(
                                    leading: Image.asset(
                                        "asset/images/car_rides2.png"),
                                    // leading: Icon(Icons.car_repair_rounded),
                                    title: Text(
                                        '${driverDetails['first_name']} ${driverDetails['last_name']}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${rideDetails['pickup_location']} to ${rideDetails['dropoff_location']}'),
                                        Text(
                                            'Date and Time: ${_formatDateTime(rideDateTime)}'),
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => DriverRidePage()));
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






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ride_with_mee/global/global.dart';
// import 'package:ride_with_mee/pages/driver_ridescreate_page.dart';

// class DriverHomeTab extends StatelessWidget {
//   const DriverHomeTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Welcome',
//           style: TextStyle(color: Colors.black),
//         ),
//         elevation: 10,
//         leading: Text(''),
//         backgroundColor: Colors.white,
//       ),
//       //StreamBuilder goes here
//       body: Container(
//           child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('drivers')
//                   .where('user_id',
//                       isEqualTo: currentFirebaseUser!.uid.toString())
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         var driverDetails = snapshot.data!.docs[index];
//                         return Container(
//                           height: 90,
//                           width: 500,
//                           child: StreamBuilder(
//                               stream: FirebaseFirestore.instance
//                                   .collection('ride_details')
//                                   .where('user_id',
//                                       isEqualTo:
//                                           currentFirebaseUser!.uid.toString())
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.separated(
//                                     itemCount: snapshot.data!.docs.length,
//                                     itemBuilder: (context, index2) {
//                                       var rideDetails =
//                                           snapshot.data!.docs[index2];
//                                       return InkWell(
//                                         child: ListTile(
//                                           title: Text(
//                                               '${driverDetails['first_name']} ${driverDetails['last_name']}'),
//                                           subtitle:
//                                               Text(rideDetails['depature']),
//                                         ),
//                                         onTap: () {
//                                           print('clicked');
//                                           Fluttertoast.showToast(
//                                               msg: 'i have been clicked');
//                                         },
//                                       );
//                                     },
//                                     separatorBuilder:
//                                         (BuildContext context, int index) {
//                                       return Divider();
//                                     },
//                                   );
//                                 } else {
//                                   return CircularProgressIndicator();
//                                 }
//                               }),
//                         );
//                       });
//                 } else {
//                   return CircularProgressIndicator();
//                 }
//               })),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (c) => CreateRidesPage()));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }