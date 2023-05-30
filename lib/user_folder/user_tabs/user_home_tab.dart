import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps;

class UserHomeTab extends StatefulWidget {
  const UserHomeTab({Key? key}) : super(key: key);

  @override
  State<UserHomeTab> createState() => _UserHomeTabState();
}

class _UserHomeTabState extends State<UserHomeTab> {
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  double bottomPaddingOfMap = 0;

  late Position currentPosition;
  StreamSubscription<QuerySnapshot>? rideSubscription;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    fetchRideDetails();
  }

  @override
  void dispose() {
    rideSubscription?.cancel();
    super.dispose();
  }

  void checkLocationPermission() async {
    LocationPermission permission;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      showErrorSnackBar('Location services are disabled.');
      return;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        showErrorSnackBar('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      showErrorSnackBar('Location permissions are permanently denied.');
      return;
    }

    // Get current position
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
      locatePosition();
    } catch (e) {
      showErrorSnackBar('Error getting current location: $e');
    }
  }

  void locatePosition() async {
    if (currentPosition == null) return;

    LatLng latLngPosition =
        LatLng(currentPosition.latitude!, currentPosition.longitude!);

    googleMaps.CameraPosition cameraPosition =
        googleMaps.CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController?.animateCamera(
        googleMaps.CameraUpdate.newCameraPosition(cameraPosition));
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void fetchRideDetails() {
    rideSubscription = FirebaseFirestore.instance
        .collection('ride_details')
        .snapshots()
        .listen((QuerySnapshot rideSnapshot) {
      markers.clear();
      for (DocumentSnapshot rideDocument in rideSnapshot.docs) {
        Map<String, dynamic> rideData =
            rideDocument.data() as Map<String, dynamic>;

        if (rideData.containsKey('pickup_coordinates')) {
          GeoPoint? pickupGeoPoint =
              rideData['pickup_coordinates'] as GeoPoint?;
          if (pickupGeoPoint != null) {
            LatLng pickupLatLng =
                LatLng(pickupGeoPoint.latitude, pickupGeoPoint.longitude);
            addMarker(pickupLatLng);
          }
        }
      }
    });
  }

  void addMarker(LatLng location) {
    final markerId = MarkerId(location.toString());
    final marker = Marker(
      markerId: markerId,
      position: location,
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });
            },
            markers: markers,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Implement your location button functionality
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: Color.fromARGB(255, 25, 119, 136),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
