// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:spaceships/colorcode.dart';
// import 'package:video_player/video_player.dart';
// import 'homeview/propertyview.dart';
//
// class Whislits extends StatefulWidget {
//   final String propertyId;
//   Color customTeal = Color(0xFF8F00FF);
//
//   Whislits({
//     required this.propertyId,
//   });
//
//   @override
//   _WhislitsState createState() => _WhislitsState();
// }
//
// class _WhislitsState extends State<Whislits> {
//   late Future<Map<String, dynamic>> propertyDataFuture;
//   PageController _pageController = PageController();
//   int _currentImageIndex = 0;
//   late VideoPlayerController _controller;
//   late Future<List<Map<String, dynamic>>> paymentRowsFuture;
//   late Future<List<Map<String, dynamic>>> nearbyplaces;
//   StreamSubscription? _sub;
//   User? user = FirebaseAuth.instance.currentUser;
//   GoogleMapController? _mapController;
//   int _currentIndex = 0;
//   List<String> amenities = [];
//   List<String> propertyFacing = [];
//   List<String> propertyImages = [];
//   DateTime? selectedDate;
//   String formattedDate = '';
//   bool _showOptions = false;
//   String? subcategory;
//   String? userName;
//   String? userMobileNumber;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   UserProfile? _posterProfile;
//   Position? _currentPosition;
//   bool isInWishlist = false;
//
//   @override
//   void initState() {
//     super.initState();
//     propertyDataFuture = fetchPropertyData();
//     fetchLocation();
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   Future<Map<String, dynamic>> fetchPropertyData() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('propert')
//           .doc(widget.propertyId)
//           .get();
//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       setState(() {
//         subcategory = data['subcategory'];
//       });
//       return data;
//     } catch (e) {
//       print('Error fetching property data: $e');
//       return {}; // Return an empty map in case of error
//     }
//   }
//
//   void fetchLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       print('Error fetching location: $e');
//     }
//   }
//
//   bool shouldDisplayBalconyAndBathroom() {
//     return !(subcategory == 'Plot / Land' ||
//         subcategory == 'Commercial Space' ||
//         subcategory == 'Hostel/PG/Service Apartment');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: propertyDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No property data found.'));
//           } else {
//             Map<String, dynamic> propertyData = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: ListView(
//                 children: [
//
//
//
//                   if (shouldDisplayBalconyAndBathroom()) ...[
//                     Text(
//                       "Balcony: ${propertyData['balcony']}",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       "Bathroom: ${propertyData['bathroom']}",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                   Text(
//                     "Amenities: ${propertyData['amenities']?.join(', ')}",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     "Facing: ${propertyData['propertyFacing']?.join(', ')}",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
