import 'dart:async';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:spaceships/colorcode.dart';

import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/wishlistfilter/tune.dart';


import '../homeview/propertyview.dart';

import 'dart:async';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/wishlistfilter/tune.dart';
import '../homeview/propertyview.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late Query<Map<String, dynamic>> wishlistQuery;
  int _selectedIndex = 2;
  Color customTeal = const Color(0xFF8F00FF);
  DateTime? _lastPressedAt; // Track the last back press time

  @override
  void initState() {
    super.initState();
    if (user != null) {
      wishlistQuery = FirebaseFirestore.instance
          .collection('wishlist')
          .where('userId', isEqualTo: user!.uid);
    }
  }

  void applyFilters(Map<String, dynamic> filters) {}

  void _navigateToSearchScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _navigateToWishlistScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WishlistScreen()),
    );
  }

  void navigateToProfileScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? '')),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen(username: '')),
    );
  }

  // Handle double back press to exit
  Future<bool> _onWillPop() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      // First back press or time elapsed > 2 seconds
      _lastPressedAt = DateTime.now();
      Fluttertoast.showToast(msg: "Double Tap to Exit");
      return false; // Prevent exit
    }
    return true; // Allow exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: customTeal,
          title: const Text(
            'My Wishlist',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Tune(
                        onApplyFilters: (Map<String, dynamic> filters) {},
                      )),
                );
              },
            ),
          ],
        ),
        body: user != null
            ? StreamBuilder<QuerySnapshot>(
          stream: wishlistQuery.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: ColorUtils.primaryColor(),
                  size: 50,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No properties in wishlist'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var wishlistItem = doc.data() as Map<String, dynamic>;

                return Dismissible(
                  key: Key(doc.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return true;
                  },
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('wishlist')
                        .doc(doc.id)
                        .delete();
                  },
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Whislits(
                            propertyId: wishlistItem['propertyId'] ?? '',
                          ),
                        ),
                      );
                    },
                    title: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(160, 161, 164, 1000),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Stack(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                  color: Colors.grey,
                                  image: wishlistItem['imageUrl'] != null &&
                                      wishlistItem['imageUrl']
                                          .isNotEmpty
                                      ? DecorationImage(
                                    image: NetworkImage(
                                        wishlistItem['imageUrl']),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: wishlistItem['imageUrl'] == null ||
                                    wishlistItem['imageUrl'].isEmpty
                                    ? const Icon(Icons.image, size: 50)
                                    : null,
                              ),
                              Positioned(
                                bottom: 8,
                                left: 10,
                                child: Container(
                                  width: 85,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: ColorUtils.primaryColor(),
                                  ),
                                  child: Text(
                                    wishlistItem['subcategory'] ?? 'cat',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    wishlistItem['propertyType'] ??
                                        'No Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.primaryColor(),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: ColorUtils.primaryColor(),
                                      size: 20,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        wishlistItem['area'] ??
                                            'No Address',
                                        style: TextStyle(
                                          color:
                                          ColorUtils.primaryColor(),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
            : const Center(child: Text('Please log in to view your wishlist')),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(143, 0, 255, 1.0),
          height: 55,
          child: FlashyTabBar(
            backgroundColor:
            const Color.fromRGBO(143, 0, 255, 1.0).withOpacity(0),
            selectedIndex: _selectedIndex,
            showElevation: true,
            onItemSelected: (index) {
              if (index == 2) {
                // No action for WishlistScreen (index 2)
              } else {
                setState(() {
                  _selectedIndex = index;
                  switch (_selectedIndex) {
                    case 0:
                      _navigateToHomeScreen(context);
                      break;
                    case 1:
                      _navigateToSearchScreen(context);
                      break;
                    case 2:
                    // _navigateToWishlistScreen(context);
                      break;
                    case 3:
                      navigateToProfileScreen(context);
                      break;
                    default:
                      break;
                  }
                });
              }
            },
            items: [
              FlashyTabBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Subtract.svg",
                  height: 24,
                  color: Colors.white,
                ),
                title: const Text(""),
                activeColor: Colors.white,
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: SvgPicture.asset(
                  height: 24,
                  "assets/images/SearchIcon.svg",
                  color: Colors.white,
                ),
                inactiveColor: Colors.white,
                title: const Text(""),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: SvgPicture.asset(
                  "assets/images/Heart.svg",
                  height: 24,
                  color: Colors.white,
                ),
                inactiveColor: Colors.white,
                title: const Text(""),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: SvgPicture.asset(
                  "assets/images/ProfileIcon.svg",
                  height: 34,
                  color: Colors.white,
                ),
                inactiveColor: Colors.white,
                title: const Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Whislits extends StatefulWidget {
  final String propertyId;
  Color customTeal = const Color(0xFF8F00FF);
  Whislits({super.key,
    required this.propertyId,
  });
  @override
  _WhislitsState createState() => _WhislitsState();
}
class _WhislitsState extends State<Whislits> {
  late Future<Map<String, dynamic>> propertyDataFuture;
  PageController _pageController = PageController();
  int _currentImageIndex = 0;
  // late VideoPlayerController _controller;
  late Future<List<Map<String, dynamic>>> paymentRowsFuture;
  late Future<List<Map<String, dynamic>>> nearbyplaces;
  StreamSubscription? _sub;
  User? user = FirebaseAuth.instance.currentUser; // Get the current user
  GoogleMapController? _mapController;
  final int _currentIndex = 0;
  List<String> amenities = [];
  List<String> propertyFacing = [];
  List<String> propertyImages = [];
  DateTime? selectedDate;
  String formattedDate = '';
  bool _showOptions = false;
  bool isInWishlist = false;
  String? subcategory;
  String? category;
  String? userName;
  String? userMobileNumber;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  UserProfile? _posterProfile;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    propertyDataFuture = fetchPropertyData();
    _pageController = PageController();
    _checkIfInWishlist();
    fetchLocation();
    fetchUserDetails();
    _initUniLinks();
    amenties();
    fetchData();
  }
  @override
  void dispose() {
    _sub?.cancel();
    _pageController.dispose();
    super.dispose();
  }
  Future<void> _launchWhatsApp() async {

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
      shape: const RoundedRectangleBorder(
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
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Text('Enter Given Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Mobile Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
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
                            const SnackBar(
                              content: Text('Error submitting details'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(  ColorUtils.primaryColor(),),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Submit', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _initUniLinks() async {


  }
  void _handleDeepLink(Uri? uri) {

    if (uri != null) {
      String? propertyId = uri.queryParameters['id']; // Adjust based on your query parameters
      if (propertyId != null) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PropertyView(
        //     imageUrl:,
        //     category: widget.category,
        //     subcategory: widget.subcategory,
        //     propertyType: widget.propertyType,
        //     propertyOwner: widget.propertyOwner,
        //     yearsOld: widget.yearsOld,
        //     furnishingType: widget.furnishingType,
        //     totalArea: widget.totalArea,
        //     dimension: widget.dimension,
        //     postuid: widget.postuid,
        //     undividedshare: widget.undividedshare,
        //     superbuildup: widget.superbuildup,
        //     roadController: widget.roadController,
        //     isCornerArea: widget.isCornerArea,
        //     featuredStatus: widget.featuredStatus,
        //     propertyId: propertyId,
        //
        //     possessionType: widget.possessionType,
        //     areaType: widget.areaType,
        //     propertyFacing: widget.propertyFacing,
        //     floorNumber: widget.floorNumber,
        //     balcony: widget.balcony,
        //     bathroom: widget.bathroom,
        //     floorType: widget.floorType,
        //     doorNo: widget.doorNo,
        //     addressLine: widget.addressLine,
        //     area: widget.area,
        //     locationaddress: widget.locationaddress,
        //     landmark: widget.landmark,
        //     amenities: amenities,
        //     nearbyPlaces: widget.nearbyPlaces,
        //     parkingIncluded: widget.parkingIncluded,
        //     parkingType: widget.parkingType,
        //     carParkingCount: widget.carParkingCount,
        //     bikeParkingCount: widget.bikeParkingCount,
        //     latitude: widget.latitude.toString(), // Convert String to String
        //     longitude: widget.longitude.toString(),
        //     videoUrl:widget.videoUrl,)),
        // );
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
          const SnackBar(
            content: Text('Interest details updated successfully.'),
          ),
        );
      }
    } catch (e) {
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error updating user details'),
      ));
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
            'postuid': widget.propertyId,
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
  Future<Map<String, dynamic>> fetchPropertyData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('propert')
          .doc(widget.propertyId)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        subcategory = data['subcategory'];
        category = data['subcategory'];
      });
      return data;
    } catch (e) {
      print('Error fetching property data: $e');
      return {}; // Return an empty map in case of error
    }
  }
  bool shouldDisplayBalconyAndBathroom() {
    return !(subcategory == 'Plot / Land' ||
        subcategory == 'Commercial Space' ||
        subcategory == 'Hostel/PG/Service Apartment');
  }
  bool yearsold() {
    return !(subcategory == 'Plot / Land' ||

        subcategory == 'Hostel/PG/Service Apartment');
  }
  bool total() {

    return !(category == 'Rent' ||category == 'Lease'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool dimensionandroad() {

    return !(category == 'Rent' ||category == 'Lease' ||subcategory == 'Flat'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool possesion() {

        return !(subcategory == 'Plot / Land' ||category == 'Rent' ||category == 'Lease'
            || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool parking() {

    return !(subcategory == 'Plot / Land'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool floornumbertype () {

    return !(subcategory == 'Plot / Land' || subcategory == 'Villa / Independent House'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool facing() {
    return !(
        subcategory == 'Hostel/PG/Service Apartment');
  }
  bool corner() {
    return !(subcategory == 'Flat' ||
        subcategory == 'Villa / Independent House' ||
        subcategory == 'Hostel/PG/Service Apartment');
  }
  bool undivided() {

    return !(subcategory == 'Plot / Land' || subcategory == 'Villa / Independent House' ||category == 'Rent' ||category == 'Lease'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  bool superbuild () {

    return !(subcategory == 'Plot / Land' || subcategory == 'Commercial Space' || subcategory == 'Villa / Independent House' ||category == 'Rent' ||category == 'Lease'
        || subcategory == 'Hostel/PG/Service Apartment');
  }
  @override
  Widget build(BuildContext context) {
    // bool isInWishlist = false; // Assuming a variable to check wishlist status

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 17.0), // Adjust the left padding as needed
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
                      offset: const Offset(0, 3), // Change offset to your preference
                    ),
                  ],
                ),
                child: const CircleAvatar(
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
          const SizedBox(width: 25,),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: propertyDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No property data found.'));
          } else {
            Map<String, dynamic> propertyData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      if (propertyData['PropertyImages'] != null && propertyData['PropertyImages'].isNotEmpty)
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 500,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35.0),
                                    topRight: Radius.circular(35.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(35.0),
                                    topRight: Radius.circular(35.0),
                                  ),
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: propertyData['PropertyImages'].length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        propertyData['PropertyImages'][index],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: LoadingAnimationWidget.fourRotatingDots(
                                              color: ColorUtils.primaryColor(),
                                              size: 50,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey,
                                            child: const Center(
                                              child: Text(
                                                'Failed to load image',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentImageIndex = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 80,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
                                  " ${propertyData['category']}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 100,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: ColorUtils.primaryColor(),
                                  borderRadius: BorderRadius.circular(20.0), // Border radius
                                ),
                                child: Text(
                                  " ${propertyData['subcategory']}", // Conditionally change text here
                                  style: const TextStyle(
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
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: ColorUtils.primaryColor(),
                                  borderRadius: BorderRadius.circular(20.0), // Border radius
                                ),
                                child: Text(
                                  " ${propertyData['propertyType']}", // Conditionally change text here
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text color
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                '${_currentImageIndex + 1} / ${propertyData['PropertyImages'].length}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Text(
                              " ${propertyData['propertyOwner']}",
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
                          const SizedBox(width: 8),
                          Icon(
                            Icons.location_on,
                            color: ColorUtils.primaryColor(),
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                " ${propertyData['addressLine']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtils.primaryColor(),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30,),
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 20),
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     widget.amount,
                          //     style: TextStyle(
                          //       fontSize: 24,
                          //       fontWeight: FontWeight.bold,
                          //       color: ColorUtils.primaryColor(),
                          //     ),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),


                        ],
                      ),
                      const SizedBox(height:1),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Divider(
                              height: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
          if (shouldDisplayBalconyAndBathroom()) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [


                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                        color: const Color.fromRGBO(139, 200, 62, 1.0),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        " ${propertyData['balcony'] } balcony",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                      color: const Color.fromRGBO(139, 200, 62, 1.0),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      " ${propertyData['bathroom']} bathroom",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                        ),
                      ),
                      ],
                      const SizedBox(height:10),
                      if (_currentPosition != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.tryParse(propertyData['latitude'] ?? '0.0') ?? 0.0,
                                    double.tryParse(propertyData['longitude'] ?? '0.0') ?? 0.0,
                                  ),
                                  zoom: 15,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _mapController = controller;
                                },
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('property_location'),
                                    position: LatLng(
                                      double.tryParse(propertyData['latitude'] ?? '0.0') ?? 0.0,
                                      double.tryParse(propertyData['longitude'] ?? '0.0') ?? 0.0,
                                    ),
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
                            color: ColorUtils.primaryColor(),),),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Displaying fetched amenities
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Wrap(
                                spacing: 10, // Adjust as needed for spacing between containers
                                children: List.generate(amenities.length, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.primaryColor(),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        amenities[index], // Display each amenity here
                                        style: const TextStyle(
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
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Value',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                ),
                              ),
                            ],
                            rows: [
                            if (yearsold()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Years old :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['yearsOld']} year old",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),

],
                                if (dimensionandroad()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Dimension :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      " ${propertyData['dimension']} ",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),

],
          if (undivided()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'undivided share :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      " ${propertyData['undividedshare']}  undivided share",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                                ],
                                if (total()) ...[

                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Area type :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['totalArea']}  ${propertyData['areaType']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
],
          if (shouldDisplayBalconyAndBathroom()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Furnished Status :',
                                      style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['furnishingType']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
],
          if (superbuild()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'superbuildup area :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['superbuildup']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
          ],
          if (dimensionandroad()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'road Size :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      " ${propertyData['roadController']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
],
                              if (corner()) ...[
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        'Is this a corner area?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ColorUtils.primaryColor(),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        corner() ? 'Yes' : 'No',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ColorUtils.primaryColor(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                              ],
          if (parking()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Parking option:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      propertyData['parkingIncluded'] ? 'Included' : 'Not Included',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ColorUtils.primaryColor(),
                                      ),
                                    ),
                                  )

                                ],
                              ),
                                  ],
                                  if (facing()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Facing Direction :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Row(
                                        children: propertyFacing.map((facing) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(


                                              child: Center(
                                                child: Text(
                                                  facing,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: ColorUtils.primaryColor(),
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
                                  if (parking()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Parking Type :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['parkingType']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Car parking :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['carparking']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Bike parking :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${propertyData['bikeParkingCount']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                                ],
                                if (possesion()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Possesion type :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text("  ${propertyData['possessionType']}",

                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),

                                ],
                              ),
],
          if (floornumbertype()) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Floor number :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(

                                    Text(" ${propertyData['floorNumber']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Floor type :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['floorType']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
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
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['doorNo']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),


                                    ),
                                  )],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Address line :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['addressLine']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Area :',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['area']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'address:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['locationaddress']}",
                                      style: TextStyle(fontSize: 12,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'landmark:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                  DataCell(
                                    Text(" ${propertyData['landmark']}",
                                      style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Text("Nearby Places:"),
                      ...propertyData['nearbyPlaces'].map<Widget>((place) {
                        return Text("${place['place']} (${place['distance']} km)");
                      }).toList(),
                      const Text("Payment Rows:"),
                      ...propertyData['paymentRows'].map<Widget>((payment) {
                        return Text("${payment['category']}: ${payment['amount']} (${payment['type']})");
                      }).toList(),


                      // ...propertyData['videos'].map<Widget>((video) {
                      //   return VideoPlayerWidget(videoUrl: video);
                      // }).toList(),


                    ],
                  ),


                ],
              ),
            );
          }
        },
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
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text('know more', style: TextStyle(color: Colors.white)),
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
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text('chat support', style: TextStyle(color: Colors.white)),
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
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text('share', style: TextStyle(color: Colors.white)),
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




// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerWidget({super.key, required this.videoUrl});
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // _controller = VideoPlayerController.network(widget.videoUrl)
//     //   ..initialize().then((_) {
//     //     setState(() {});
//     //   });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayback() {
//     setState(() {
//       if (_isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       _isPlaying = !_isPlaying;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : const Center(child: CircularProgressIndicator()),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//               onPressed: _togglePlayback,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
