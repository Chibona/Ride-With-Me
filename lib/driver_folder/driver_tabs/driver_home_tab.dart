import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_datepicker/cool_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart' hide TravelMode;
import 'package:ride_with_mee/global/global.dart';
import 'package:ride_with_mee/global/map_key.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

class DriverHomeTab extends StatefulWidget {
  const DriverHomeTab({Key? key}) : super(key: key);

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabState();
}

class _DriverHomeTabState extends State<DriverHomeTab> {
  String location1 = '';
  String location2 = '';
  LatLng pickup = LatLng(0, 0);
  LatLng dropoff = LatLng(0, 0);
  Set<googleMaps.Marker> markers = <googleMaps.Marker>{};
  Map<googleMaps.PolylineId, googleMaps.Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  final Completer<googleMaps.GoogleMapController> _controllerGoogleMap =
      Completer<googleMaps.GoogleMapController>();
  googleMaps.GoogleMapController? newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
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
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
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

  static const googleMaps.CameraPosition _kGooglePlex =
      googleMaps.CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          googleMaps.GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: googleMaps.MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (googleMaps.GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
            markers: markers,
            polylines: Set<googleMaps.Polyline>.of(polylines.values),
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 16,
            child: InkWell(
              onTap: () async {
                var dropOffPlace = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: mapKey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'zm')],
                  onError: (err) {
                    print(err);
                  },
                );

                if (dropOffPlace != null) {
                  setState(() {
                    location1 = dropOffPlace.description!;
                  });

                  final plist = GoogleMapsPlaces(
                    apiKey: mapKey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                  );
                  String placeid = dropOffPlace.placeId!;
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  String selectedPlaceDropOff = dropOffPlace.description!;

                  List<geoCoding.Location> locations =
                      await geoCoding.locationFromAddress(selectedPlaceDropOff);

                  setState(() {
                    pickup = LatLng(
                      locations.first.latitude,
                      locations.first.longitude,
                    );
                  });

                  newGoogleMapController?.animateCamera(
                    googleMaps.CameraUpdate.newCameraPosition(
                      googleMaps.CameraPosition(target: newlatlang, zoom: 17),
                    ),
                  );

                  // Update polyline
                  void updatePolyline() {
                    if (pickup == null || dropoff == null) return;

                    googleMaps.PolylineId polylineId =
                        googleMaps.PolylineId("polyline");
                    googleMaps.Polyline polyline = googleMaps.Polyline(
                      polylineId: polylineId,
                      color: Colors.red,
                      points: [pickup, dropoff],
                    );

                    googleMaps.Marker pickupMarker = googleMaps.Marker(
                      markerId: googleMaps.MarkerId('pickup'),
                      position: pickup,
                      icon: googleMaps.BitmapDescriptor.defaultMarkerWithHue(
                          googleMaps.BitmapDescriptor.hueGreen),
                      infoWindow: googleMaps.InfoWindow(
                          title: 'Pickup', snippet: location1),
                    );

                    googleMaps.Marker dropoffMarker = googleMaps.Marker(
                      markerId: googleMaps.MarkerId('dropoff'),
                      position: dropoff,
                      icon: googleMaps.BitmapDescriptor.defaultMarkerWithHue(
                          googleMaps.BitmapDescriptor.hueRed),
                      infoWindow: googleMaps.InfoWindow(
                          title: 'Dropoff', snippet: location2),
                    );

                    setState(() {
                      markers.clear();
                      markers.add(pickupMarker);
                      markers.add(dropoffMarker);
                      polylines.clear();
                      polylines[polylineId] = polyline;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location1,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 16,
            child: InkWell(
              onTap: () async {
                var dropOffPlace = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: mapKey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'zm')],
                  onError: (err) {
                    print(err);
                  },
                );

                if (dropOffPlace != null) {
                  setState(() {
                    location2 = dropOffPlace.description!;
                  });

                  final plist = GoogleMapsPlaces(
                    apiKey: mapKey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                  );
                  String placeid = dropOffPlace.placeId!;
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  String selectedPlaceDropOff = dropOffPlace.description!;

                  List<geoCoding.Location> locations =
                      await geoCoding.locationFromAddress(selectedPlaceDropOff);

                  setState(() {
                    dropoff = LatLng(
                      locations.first.latitude,
                      locations.first.longitude,
                    );
                  });

                  newGoogleMapController?.animateCamera(
                    googleMaps.CameraUpdate.newCameraPosition(
                      googleMaps.CameraPosition(target: newlatlang, zoom: 17),
                    ),
                  );

                  // Update polyline
                  updatePolyline();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location2,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Date
          Positioned(
            // New code for date picker
            bottom: 550,
            left: 80,
            right: 16,
            child: CoolDatepicker(
              defaultValue: [DateTime.now()],
              onSelected: (List<DateTime> dates) {
                setState(() {
                  selectedDate = dates.first;
                });
              },
              disabledList: [DateTime(2021, 10, 22), DateTime(2021, 10, 12)],
              disabledRangeList: [
                {'start': DateTime(2021, 11, 1), 'end': DateTime(2021, 11, 13)},
              ],
            ),
          ),
          // CoolDatepicker(
          //   defaultValue: {
          //     // range select
          //     'start': DateTime(2020, 9, 25),
          //     'end': DateTime(2021, 11, 24)
          //   },
          //   onSelected: (_) {},
          // ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                locatePosition();
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _saveLocation();
                // CoolDatepicker(onSelected: (_) {});
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.save,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updatePolyline() {
    googleMaps.PolylineId polylineId = googleMaps.PolylineId("polyline");
    googleMaps.Polyline polyline = googleMaps.Polyline(
      polylineId: polylineId,
      color: Colors.red,
      points: [pickup, dropoff],
    );

    googleMaps.Marker pickupMarker = googleMaps.Marker(
      markerId: googleMaps.MarkerId('pickup'),
      position: pickup,
      icon: googleMaps.BitmapDescriptor.defaultMarkerWithHue(
          googleMaps.BitmapDescriptor.hueGreen),
      infoWindow: googleMaps.InfoWindow(title: 'Pickup', snippet: location1),
    );

    googleMaps.Marker dropoffMarker = googleMaps.Marker(
      markerId: googleMaps.MarkerId('dropoff'),
      position: dropoff,
      icon: googleMaps.BitmapDescriptor.defaultMarkerWithHue(
          googleMaps.BitmapDescriptor.hueRed),
      infoWindow: googleMaps.InfoWindow(title: 'Dropoff', snippet: location2),
    );

    setState(() {
      markers.clear();
      markers.add(pickupMarker);
      markers.add(dropoffMarker);
      polylines.clear();
      polylines[polylineId] = polyline;
    });
  }

  void _saveLocation() {
    if (pickup == null || dropoff == null) {
      showErrorSnackBar('Please select pickup and dropoff locations.');
      return;
    }

    // Save the locations to Firestore
    //////////////////////////////////
    ///////////////////////////////////
    ////////////////////////////////////
    ///
    /////////////////////////
    FirebaseFirestore.instance.collection('ride_details').add({
      'user_id': currentFirebaseUser!.uid.toString(),
      'pickup_location': location1,
      'dropoff_location': location2,
      'pickup_coordinates': GeoPoint(pickup.latitude, pickup.longitude),
      'dropoff_coordinates': GeoPoint(dropoff.latitude, dropoff.longitude),
      'date': selectedDate,
    }).then((value) {
      showDialog(
        ///////////////////////////////////////////////////////
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Locations saved successfully.'),
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

    // Save the locations
    // Replace the code below with the actual code to save the locations
    // You can use a database or any other storage mechanism to save the locations

    print('Pickup Location: $location1');
    print('Dropoff Location: $location2');
    print('Pickup Coordinates: $pickup');
    print('Dropoff Coordinates: $dropoff');
  }
}
