import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share/share.dart';

import 'package:spaceships/colorcode.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';


class PropertyView extends StatefulWidget {
  final String imageUrl;
  final List<String> videoUrl;
  final String category;
  final String subcategory;
  final String propertyType;
  final String propertyOwner;
  final int yearsOld;
  final String furnishingType;
  final String totalArea;
  final String dimension;
  final String postuid;
  final String undividedshare;
  final String latitude;
  final String longitude;
  final String superbuildup;
  final String roadController;
  final bool isCornerArea;
  final bool featuredStatus;
  final String propertyId;

  final String possessionType;
  final String areaType;
  final List<String> propertyFacing;
  final String floorNumber;
  final String balcony;
  final String bathroom;
  final String floorType;
  final String doorNo;
  final String addressLine;
  final String area;
  final String locationaddress;
  final String landmark;
  final List<String> amenities;
  final List<Map<String, dynamic>> nearbyPlaces;
  final bool parkingIncluded;
  final String parkingType;
  final int carParkingCount;
  final int bikeParkingCount;
  Color customTeal = Color(0xFF8F00FF);

  PropertyView({

  required this.imageUrl, required this.videoUrl, required this.category, required this.subcategory, required this.propertyType, required this.propertyOwner, required this.yearsOld, required this.furnishingType, required this.totalArea, required this.dimension, required this.postuid, required this.undividedshare, required this.latitude, required this.longitude, required this.superbuildup, required this.roadController, required this.isCornerArea, required this.featuredStatus, required this.propertyId,  required this.possessionType, required this.areaType, required this.propertyFacing, required this.floorNumber, required this.balcony, required this.bathroom, required this.floorType, required this.doorNo, required this.addressLine, required this.area, required this.locationaddress, required this.landmark, required this.amenities, required this.nearbyPlaces, required this.parkingIncluded, required this.parkingType, required this.carParkingCount, required this.bikeParkingCount});

  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  late VideoPlayerController _controller;
   late Future<List<Map<String, dynamic>>> paymentRowsFuture;
  late Future<List<Map<String, dynamic>>> nearbyplaces;

  StreamSubscription? _sub;
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  GoogleMapController? _mapController;
  int _currentIndex = 0;
  List<String> amenities = [];
  List<String> propertyFacing = [];
  List<String> propertyImages = [];
  DateTime? selectedDate;
  String formattedDate = '';
  bool _showOptions = false;

  int _currentImageIndex = 0;
  late PageController _pageController;
  String? userName;
  String? userMobileNumber;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  UserProfile? _posterProfile;
  Position? _currentPosition;
  bool isInWishlist = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _currentImageIndex = _pageController.page!.round();
        });
      });
    if (widget.videoUrl.isNotEmpty) {
      print('Video URL: ${widget.videoUrl[0]}');
      _controller = VideoPlayerController.network(widget.videoUrl[0])
        ..initialize().then((_) {
          setState(() {}); // Update UI after initialization
        });
    } else {
      print('No video URL available.');
    }

    _checkIfInWishlist();
    fetchLocation();
    fetchpropertyimges();
    fetchUserDetails();
    _initUniLinks();
    amenties();
    fetchData();
  }
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> nearbyplace() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('propert').doc(widget.propertyId).get();
    return List<Map<String, dynamic>>.from(doc['nearbyPlaces']);
  }
  Future<List<Map<String, dynamic>>> amenties() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('propert')
        .doc(widget.propertyId)
        .get();
    return List<Map<String, dynamic>>.from(doc['amenities']);
  }
  Future<List<Map<String, dynamic>>> fetchPaymentRows() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('propert').doc(widget.propertyId).get();
    return List<Map<String, dynamic>>.from(doc['paymentRows']);
  }
  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text('Enter Given Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Mobile Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop(); // Close modal after submission
                        } catch (e) {
                          print('Error submitting details: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error submitting details'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(  ColorUtils.primaryColor(),),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Submit', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _initUniLinks() async {

    _sub ??= uriLinkStream.listen((Uri? uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      print('Failed to get latest link: $err');
    });

    // Handle the initial uri when the application starts
    Uri? initialUri;
    try {
      initialUri = await getInitialUri();
    } catch (e) {
      print('Error getting initial uri: $e');
    }
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }
  void _handleDeepLink(Uri? uri) {

      if (uri != null) {
        String? propertyId = uri.queryParameters['id']; // Adjust based on your query parameters
        if (propertyId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PropertyView(
              imageUrl:widget.imageUrl,
              category: widget.category,
              subcategory: widget.subcategory,
              propertyType: widget.propertyType,
              propertyOwner: widget.propertyOwner,
              yearsOld: widget.yearsOld,
              furnishingType: widget.furnishingType,
              totalArea: widget.totalArea,
              dimension: widget.dimension,
              postuid: widget.postuid,
              undividedshare: widget.undividedshare,
              superbuildup: widget.superbuildup,
              roadController: widget.roadController,
              isCornerArea: widget.isCornerArea,
              featuredStatus: widget.featuredStatus,
              propertyId: propertyId,

              possessionType: widget.possessionType,
              areaType: widget.areaType,
              propertyFacing: widget.propertyFacing,
              floorNumber: widget.floorNumber,
              balcony: widget.balcony,
              bathroom: widget.bathroom,
              floorType: widget.floorType,
              doorNo: widget.doorNo,
              addressLine: widget.addressLine,
              area: widget.area,
              locationaddress: widget.locationaddress,
              landmark: widget.landmark,
              amenities: amenities,
              nearbyPlaces: widget.nearbyPlaces,
              parkingIncluded: widget.parkingIncluded,
              parkingType: widget.parkingType,
              carParkingCount: widget.carParkingCount,
              bikeParkingCount: widget.bikeParkingCount,
              latitude: widget.latitude.toString(), // Convert String to String
              longitude: widget.longitude.toString(),
              videoUrl:widget.videoUrl,)),
          );
        } else {
          print('Property ID not found in the link.');
        }
      }


  }
  void fetchData() async {
    // Fetch data from Firebase Firestore
    final docSnapshot = await FirebaseFirestore.instance
        .collection('propert')
        .doc(widget.propertyId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        amenities = List<String>.from(docSnapshot.data()?['amenities'] ?? []);
        propertyFacing = List<String>.from(docSnapshot.data()?['propertyFacing'] ?? []);

      });
    }
  }
  void fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }
  Future<void> fetchpropertyimges() async {
    try {
      DocumentSnapshot propertyImagesQuery = await FirebaseFirestore.instance.collection('propert').doc(widget.propertyId).get();
      if (propertyImagesQuery.exists) {
        Map<String, dynamic>? data = propertyImagesQuery.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('PropertyImages')) {
          setState(() {
            propertyImages = List<String>.from(data['PropertyImages'] as List<dynamic>);

            print('Fetched data:');
            print('PropertyImages: $propertyImages');

          });
        } else {
          print('Amenities data is missing or not in expected format');
        }
      } else {
        print('Amenities document does not exist');
      }
    } catch (e) {
      print('Error fetching amenities: $e');
    }
  }
  Future<void> fetchUserDetails() async {
    try {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'];
            userMobileNumber = userDoc['number'];
            nameController.text = userName ?? '';
            mobileController.text = userMobileNumber ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  Future<void> updateInterestDetails() async {
    try {
      if (user != null) {
        Timestamp currentTime = Timestamp.now();
        DocumentReference docRef = await FirebaseFirestore.instance.collection('interested').add({
          'name': nameController.text,
          'mobile_number': mobileController.text,
          'property_id': widget.propertyId,
          'user_uid': user!.uid,
          'submitted_date': currentTime,
        });

        // Get the document ID
        String docId = docRef.id;


        await docRef.update({
          'status': '',
          'comment': '',
          'updated_date': '',
        });

        // Clear the form fields or update the UI as needed
        setState(() {
          userName = nameController.text;
          userMobileNumber = mobileController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Interest details updated successfully.'),
          ),
        );
      }
    } catch (e) {
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating user details'),
      ));
    }
  }
  Future<void> _launchWhatsApp() async {
    String message = "Checkout this property: ${widget.category}\nAddress: ${widget.addressLine}\nArea: ${widget.area}\n${PropertyDeepLink.generateDeepLink(widget.propertyId)}";
    try {
      await Share.share(message);
      print('Sharing via WhatsApp: $message');
    } catch (e) {
      print('Error sharing: $e');
    }
  }
  Future<void> _checkIfInWishlist() async {
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('userId', isEqualTo: user!.uid)
          .where('propertyId', isEqualTo: widget.propertyId)
          .get();

      setState(() {
        isInWishlist = querySnapshot.docs.isNotEmpty;
      });
    }
  }
  Future<void> saveToWishlist() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Check if the property is already in the wishlist
        var querySnapshot = await FirebaseFirestore.instance.collection('wishlist')
            .where('userId', isEqualTo: uid)
            .where('propertyId', isEqualTo: widget.propertyId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Property exists in wishlist, so remove it
          await FirebaseFirestore.instance.collection('wishlist')
              .doc(querySnapshot.docs.first.id)
              .delete();

          setState(() {
            isInWishlist = false;
          });
          print('Property removed from wishlist');
        } else {

          await FirebaseFirestore.instance.collection('wishlist').add({

            'userId': uid,
            'imageUrl':widget.imageUrl,
            'category': widget.category,
            'subcategory': widget.subcategory,
            'propertyType': widget.propertyType,
            'propertyOwner': widget.propertyOwner,
            'yearsOld': widget.yearsOld,
            'furnishingType': widget.furnishingType,
            'totalArea': widget.totalArea,
            'dimension': widget.dimension,
            'postuid': widget.postuid,
            'undividedshare': widget.undividedshare,
            'superbuildup': widget.superbuildup,
            'roadController': widget.roadController,
            'isCornerArea': widget.isCornerArea,
            'featuredStatus': widget.featuredStatus,
            'propertyId': widget.propertyId,

          'possessionType': widget.possessionType,
          'areaType': widget.areaType,

          'floorNumber': widget.floorNumber,
          'balcony': widget.balcony,
          'bathroom': widget.bathroom,
          'floorType': widget.floorType,
          'doorNo': widget.doorNo,
          'addressLine': widget.addressLine,
          'area': widget.area,
          'locationaddress': widget.locationaddress,
          'landmark': widget.landmark,


          'parkingIncluded': widget.parkingIncluded,
          'parkingType': widget.parkingType,
          'carParkingCount': widget.carParkingCount,
          'bikeParkingCount': widget.bikeParkingCount,
         'latitude': widget.latitude.toString(), // Convert String to String
          'longitude': widget.longitude.toString(),
         'videoUrl':widget.videoUrl,
          });

          setState(() {
            isInWishlist = true;
          });
          print('Property added to wishlist');
        }
      } else {
        print('User is not logged in'); // Handle scenario where user is not logged in
      }
    } catch (e) {
      print('Error saving to wishlist: $e'); // Handle error saving to wishlist
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.white.withOpacity(1),
        body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            // backgroundColor: widget.customTeal,
            pinned: true,
            leadingWidth: 70,
            leading: Padding(
              padding: EdgeInsets.only(left: 17.0), // Adjust the left padding as needed
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Adjust the shadow color and opacity
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3), // Change offset to your preference
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            title:Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Text(
                  widget.subcategory,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),

              ),

            ),


            actions: [
              Container(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: isInWishlist ? Colors.red : Colors.green,
                  child: IconButton(
                    onPressed: () {
                      saveToWishlist();
                    },
                    icon: SvgPicture.asset(
                      'assets/images/HeartIcon.svg',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 25,)
            ],
          ),


          SliverToBoxAdapter(
    child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10),
                  // SizedBox(height: 30),
                  Stack(
                    children: [

                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                        child: Stack(
                          children: [
                          PageView.builder(
                          controller: _pageController,
                          itemCount: propertyImages.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              propertyImages[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                      ]),
                    )
                  )
          ),

                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          '${_currentImageIndex + 1} / ${propertyImages.length}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,fontWeight: FontWeight.bold
                          ),
                        ),
                      ),


            Positioned(
                        top: 40,
                        left: 80,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                          child: Text(
                            "${widget.propertyType}",
                            style: TextStyle(
                              fontSize: 24,fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 100,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: widget.customTeal, // Green background color
                            borderRadius: BorderRadius.circular(20.0), // Border radius
                          ),
                          child: Text(
                            "${widget.category == 'Sell' ? 'Buy' : 'Rent'}", // Conditionally change text here
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                       bottom: 40,
                        left: 60,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: widget.customTeal, // Green background color
                            borderRadius: BorderRadius.circular(20.0), // Border radius
                          ),
                          child: Text(
                            "${widget.subcategory}", // Conditionally change text here
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 10,
                      //   left: 20,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: CircleAvatar(
                      //       radius: 25,
                      //       backgroundColor: Colors.white,
                      //       child: Icon(
                      //         Icons.arrow_back_ios,
                      //         size: 25,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        top: 10,
                        right: 16,
                        child: Row(
                          children: <Widget>[
                            // CircleAvatar(
                            //   radius: 25,
                            //   backgroundColor: Colors.white,
                            //   child: IconButton(
                            //     onPressed: () {
                            //       _launchWhatsApp();
                            //     },
                            //     icon: SvgPicture.asset(
                            //       'assets/images/ShareIcon.svg',
                            //       width: 24,
                            //       height: 24,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            //
                            // ),
                            SizedBox(width: 25),
                            // CircleAvatar(
                            //   radius: 25,
                            //   backgroundColor: isInWishlist ? Colors.red : Colors.green,
                            //   child: IconButton(
                            //     onPressed: () {
                            //       saveToWishlist();
                            //     },
                            //     icon: SvgPicture.asset(
                            //       'assets/images/HeartIcon.svg',
                            //       width: 24,
                            //       height: 24,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  // Row(
                  //   children: [
                  //     SizedBox(width: 1),
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  //       child: Row(
                  //         children: [
                  //           for (int i = 0; i < (propertyImages.length > 3 ? 3 : propertyImages.length); i++) ...[
                  //             GestureDetector(
                  //               onTap: () {
                  //                 _showFullScreenImage(propertyImages[i]);
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(color: Colors.white),
                  //                   borderRadius: BorderRadius.circular(5.0),
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: Colors.white,
                  //                       offset: Offset(2, 2),
                  //                       blurRadius: 5.0,
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(5.0),
                  //                   child: Image.network(
                  //                     propertyImages[i],
                  //                     fit: BoxFit.cover,
                  //                     width: 50,
                  //                     height: 50,
                  //                     errorBuilder: (context, error, stackTrace) {
                  //                       return Container(
                  //                         color: Colors.grey,
                  //                         width: 50,
                  //                         height: 50,
                  //                         child: Center(
                  //                           child: Text(
                  //                             'I',
                  //                             style: TextStyle(color: Colors.white),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             if (i < (propertyImages.length > 3 ? 3 : propertyImages.length) - 1)
                  //               SizedBox(width: 1), // Add spacing between images
                  //           ],
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.propertyOwner,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.primaryColor(),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //
                      //     alignment: Alignment.centerRight,
                      //     child: Text(
                      //       widget.paymentType,
                      //       style: TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.bold,
                      //         color: ColorUtils.primaryColor(),
                      //       ),
                      //       textAlign: TextAlign.right,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        color: ColorUtils.primaryColor(),
                        size: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            widget.addressLine,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.primaryColor(),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 20),
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     widget.amount,
                      //     style: TextStyle(
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.bold,
                      //       color: widget.customTeal,
                      //     ),
                      //     textAlign: TextAlign.right,
                      //   ),
                      // ),


                    ],
                  ),
                  SizedBox(height:1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        child: Divider(
                          height: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (widget.subcategory != 'Plot / Land' &&
                            widget.subcategory != 'Commercial Space' &&
                            widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/balcony.svg', // Path to balcony SVG asset
                                    width: 24,
                                    height: 24,
                                    color: Color.fromRGBO(139, 200, 62, 1.0),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${widget.balcony} Balcony",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/BathRoom.svg', // Path to bathroom SVG asset
                                    width: 24,
                                    height: 24,
                                    color: Color.fromRGBO(139, 200, 62, 1.0),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${widget.bathroom} Bathroom",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      child: Text("Location details",style: TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.customTeal,),),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_currentPosition != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
                              zoom: 15,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                            markers: {
                              Marker(
                                markerId: MarkerId('property_location'),
                                position: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
                              ),
                            },
                          ),

                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      child: Text("Amenties",style: TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.customTeal,),),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Displaying fetched amenities

                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Wrap(
                            spacing: 10, // Adjust as needed for spacing between containers
                            children: List.generate(amenities.length, (index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: widget.customTeal,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.amenities[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.grey, // You can adjust border color here
                          width: 1.0,
                        ),
                      ),
                      child: DataTable(
                        columnSpacing: 10.0,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Other Details',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Value',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                        rows: [
                      if (widget.subcategory != 'Plot / Land' &&
                      widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Years old :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.yearsOld} year old",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
],
    if (widget.subcategory != 'Flat'  &&widget.category != 'Rent' && widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Dimension :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.dimension} dimension ",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
],
    if (widget.subcategory != 'Plot / Land' &&widget.subcategory != 'Villa / Independent House' &&
 widget.category != 'Rent' && widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'undivided share :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.undividedshare}  undivided share",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          ],
    if (  widget.category != 'Rent' && widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Area type :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.totalArea}  ${widget.areaType}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
    ],
    if (widget.subcategory != 'Plot / Land' && widget.subcategory != 'Commercial Space' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Furnished Status :',
                                  style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.furnishingType}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          ],
                            if (widget.subcategory != 'Plot / Land' &&widget.subcategory != 'Villa / Independent House' &&
    widget.subcategory != 'Commercial Space' &&widget.category != 'Rent' && widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'superbuildup area :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.superbuildup}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          ],      if (widget.subcategory != 'Flat'  &&widget.category != 'Rent' && widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'road controller :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.roadController}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          ],
    if (widget.subcategory != 'Flat' && widget.subcategory != 'Villa / Independent House' &&
        widget.category != 'Lease' &&        widget.category != 'Rent' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Is this a corner area?',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  widget.isCornerArea ? 'Yes' : 'No',
                                  style: TextStyle(fontSize: 16, color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
],
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Parking option:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  widget.parkingIncluded ? 'Included' : 'Not included',
                                  style: TextStyle(fontSize: 16, color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
    if (widget.subcategory != 'Plot / Land' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Facing Direction :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Container(
                                  child: Row(
                                    children: propertyFacing.map((facing) {
                                      return Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Container(


                                          child: Center(
                                            child: Text(
                                              facing,
                                              style: TextStyle(
                                                fontSize: 16,
                                                  color: widget.customTeal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
    ],
    if (widget.subcategory != 'Plot / Land' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Parking Type :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.parkingType}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Car parking :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.carParkingCount}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Bike parking :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${widget.bikeParkingCount}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                                ],
                                if (widget.subcategory != 'Plot / Land' && widget.category != 'Rent' &&
                                    widget.category != 'Lease' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Possesion type :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.possessionType}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),

                            ],
                          ),
                          ],
    if (widget.subcategory != 'Villa / Independent House' &&
    widget.subcategory != 'Plot / Land' &&
    widget.subcategory != 'Hostel/PG/Service Apartment') ...[
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Floor number :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.floorNumber }",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Floor type :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.floorType }",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          ],
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Door no:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
    Text(" ${widget.doorNo}",
    style: TextStyle(fontSize: 16,  color: widget.customTeal),


                              ),
                              )],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Address line :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.addressLine}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Area :',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.area}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'address:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.locationaddress}",
                                  style: TextStyle(fontSize: 12,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'landmark:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.customTeal),
                                ),
                              ),
                              DataCell(
                                Text(" ${widget.landmark}",
                                  style: TextStyle(fontSize: 16,  color: widget.customTeal),
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                  if (widget.videoUrl.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        VideoPlayerControls(controller: _controller),
                      ],
                    ),
                  // Column(
                  //   children: widget.nearbyPlaces.map((place) {
                  //     return ListTile(
                  //       title: Text(place['place']),
                  //       subtitle: Text('Distance: ${place['distance']} km'),
                  //     );
                  //   }).toList(),
                  // ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: nearbyplace(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(     child: LoadingAnimationWidget.inkDrop(
                          color: ColorUtils.primaryColor(),
                          size: 50,
                        ),);
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final nearbyplace = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: nearbyplace.length,
                        itemBuilder: (context, index) {
                          final place = nearbyplace[index];
                          return ListTile(
                            title: Text(place['place']),
                            subtitle: Text('Distance: ${place['distance']} km'),
                          );
                        },
                      );
                    },
                  ),

                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchPaymentRows(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(     child: LoadingAnimationWidget.inkDrop(
                          color: ColorUtils.primaryColor(),
                          size: 50,
                        ),);
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final paymentRows = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: paymentRows.length,
                        itemBuilder: (context, index) {
                          final payment = paymentRows[index];
                          return ListTile(
                            title: Text('${payment['category']}'),
                            subtitle: Text('Amount: ${payment['amount']} - Type: ${payment['type']}'),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 50,),
                  // Container(child: Text("Gated Community: ${gatedCommunity.isNotEmpty ? gatedCommunity : 'Not specified'}")),

                ]),
    ),
          ),
        ]
        ),
      floatingActionButton: Stack(
        children: [
          // Options menu positioned above the floating action button when _showOptions is true
          if (_showOptions)
            Positioned(
              bottom: 80.0, // Adjust the position as needed
              right: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text('know more', style: TextStyle(color: Colors.white)),
                      ),
                      FloatingActionButton(backgroundColor: widget.customTeal,
                        heroTag: 'know more',
                        mini: true,
                        onPressed: () {
                          _showModalBottomSheet();
                          setState(() {
                            _showOptions = false;
                          });
                        },
                        child: SvgPicture.asset(color:Colors.white,
                          'assets/images/knowmore.svg', // Ensure the SVG files are in your assets folder
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text('chat support', style: TextStyle(color: Colors.white)),
                      ),
                      FloatingActionButton(backgroundColor: widget.customTeal,
                        heroTag: 'chat support',
                        mini: true,
                        onPressed: () {
                          // Implement your second option action
                          setState(() {
                            _showOptions = false;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/ChatIcon.svg',color:Colors.white, // Ensure the SVG files are in your assets folder
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text('share', style: TextStyle(color: Colors.white)),
                      ),
                      FloatingActionButton(backgroundColor: widget.customTeal,
                        heroTag: 'share',
                        mini: true,
                        onPressed: () {
                          _launchWhatsApp();
                          // Implement your third option action
                          setState(() {
                            _showOptions = false;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/ShareIcon.svg',color:Colors.white, // Ensure the SVG files are in your assets folder
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Main Floating action button
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: widget.customTeal, // Change to desired color
              child: IconButton(
                icon: Icon(
                  _showOptions ? Icons.close : Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showOptions = !_showOptions;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );

  }
}



class UserProfile {
  final String uid;
  final String name;
  final String avatarUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.avatarUrl,
  });
}

class UserService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(uid).get();
      if (userDoc.exists) {
        return UserProfile(
          uid: uid,
          name: userDoc['name'],
          avatarUrl: userDoc['profile_picture'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
class PropertyDeepLink {
  static const String baseUrl = 'https://spaceships.page.link/property';

  static String generateDeepLink(String propertyId) {
    return '$baseUrl?id=$propertyId';
  }
}class VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;

  VideoPlayerControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () {
            controller.pause();
            controller.seekTo(Duration.zero);
          },
        ),
      ],
    );
  }
}
