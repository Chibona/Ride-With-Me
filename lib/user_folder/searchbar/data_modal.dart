import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? pickup;
  final String? dropoff;
  final String? framework;
  final String? tool;

  DataModel({this.pickup, this.dropoff, this.framework, this.tool});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold
  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          pickup: dataMap['pickup_locations'],
          dropoff: dataMap['dropoff_location'],
          framework: dataMap['framework'],
          tool: dataMap['tool']);
    }).toList();
  }
}
