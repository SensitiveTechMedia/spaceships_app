import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spaceships/colorcode.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  LatLng _center = const LatLng(12.9716, 77.5946);
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  String address = '';
  LatLng? selectedLocation; // Store the selected location

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });

    addMarker(_center);
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('request denied');
    }
  }

  void addMarker(LatLng tappedPoint) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      tappedPoint.latitude,
      tappedPoint.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}';

      setState(() {
        Marker marker = Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(title: 'Location', snippet: address),
        );
        markers.clear();
        markers.add(marker);
        this.address = address;
        selectedLocation = tappedPoint; // Save the selected location
        print(address);
      });
    } else {
      print('No address found for the tapped location');
    }
  }


  Future<void> addLocation() async {
    if (_user != null && selectedLocation != null) {
      String userId = _user.uid;

      await FirebaseFirestore.instance.collection('address').doc(userId).set({
        'uid': userId,
        'address': address,
        'lat': selectedLocation!.latitude,
        'lon': selectedLocation!.longitude
      });
    } else {
      print('No user signed in or location not selected');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getCurrentLocation(); // Get current location on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorUtils.primaryColor(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),color: Colors.white,
            onPressed: () {
              // Handle search icon press
              // You can add search functionality here
              print('Search icon pressed');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
            markers: markers,
            onTap: (LatLng tappedPoint) {
              addMarker(tappedPoint);
            },
          ),
        ],
      ),
        bottomNavigationBar: BottomAppBar(
          color:  ColorUtils.primaryColor(),
          height: 125,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        'Address: $address',style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,  // Set the maximum number of lines to 2
                        softWrap: true,  // Enable soft wrapping
                      ),
                    ),
                    const SizedBox(height: 2.0), // Optional: Add spacing between Text and button
                    Padding(
                      padding: const EdgeInsets.only(left: 250.0),
                      child: Container(
                        child: FloatingActionButton(
                          onPressed: () {
                            if (selectedLocation != null) {
                              Navigator.pop(context, {
                                'address': address,
                                'latitude': selectedLocation!.latitude,
                                'longitude': selectedLocation!.longitude
                              });
                            } else {
                              print('No location selected');
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


    );
  }
}
