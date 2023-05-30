import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../requests/google_maps_requests.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition = LatLng(0, 0);
  static LatLng _lastPosition = LatLng(0, 0);

  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController? _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController? get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  AppState() {
    _getUserLocation();
    _loadingInitialPosition();
  }

  void _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<geocoding.Placemark> placemark = await geocoding
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    _lastPosition = _initialPosition;
    print(
        "the latitude is: ${position.latitude} and the longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name ?? '';
    notifyListeners();
  }

  void createRoute(String encodedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i += 2) {
      result.add(LatLng(points[i], points[i + 1]));
    }
    return result;
  }

  List<double> _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }

      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    print(lList.toString());

    return lList;
  }

  void sendRequest(String intendedLocation) async {
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(intendedLocation);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
