import 'dart:async';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share/share.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/filter.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/videoplayer.dart';
import 'package:spaceships/screen/wishlistfilter/tune.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

import '../homeview/propertyview.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late Query<Map<String, dynamic>> wishlistQuery;
  int _selectedIndex = 2;
  Color customTeal = Color(0xFF8F00FF);

  @override
  void initState() {
    super.initState();
    if (user != null) {
      wishlistQuery = FirebaseFirestore.instance
          .collection('wishlist')
          .where('userId', isEqualTo: user!.uid);
    }
  }
  void applyFilters(Map<String, dynamic> filters) {

  }
  void _navigateToSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }
  void _navigateToWishlistScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WishlistScreen()),
    );
  }
  void navigateToProfileScreen (BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? '')),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: customTeal,
        title: Text(
          'My Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Screen(onApplyFilters: (Map<String, dynamic> filters) {  },

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
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No properties in wishlist'));
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // You can implement a confirmation dialog here if needed
                  // Return true to dismiss, false to cancel the dismiss action
                  return true;
                },
                onDismissed: (direction) {
                  // Delete the item from Firestore
                  FirebaseFirestore.instance.collection('wishlist').doc(doc.id).delete();
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      color: Color.fromRGBO(160, 161, 164, 1000),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Stack(
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey,
                                image: wishlistItem['imageUrl'] != null &&
                                    wishlistItem['imageUrl']
                                        .isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(wishlistItem[
                                  'imageUrl']),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: wishlistItem['imageUrl'] ==
                                  null ||
                                  wishlistItem['imageUrl']
                                      .isEmpty
                                  ? Icon(Icons.image, size: 50)
                                  : null,
                            ),
                            // Positioned(
                            //   left: 8,
                            //   top: 8,
                            //   child: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       color: Colors.lightGreen,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: IconButton(
                            //       padding: EdgeInsets.zero,
                            //       iconSize: 1,
                            //       color: Colors.white,
                            //       onPressed: () {},
                            //       icon: SvgPicture.asset(
                            //         'assets/images/HeartIcon.svg',
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              bottom: 8,
                              left: 10,
                              child: Container(
                                width: 85,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(43, 84, 112, 55),
                                ),
                                child: Text(
                                  wishlistItem['subcategory'] ??
                                      'cat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
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
                              SizedBox(height: 4.0),
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
                                        color: ColorUtils.primaryColor(),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),

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
          : Center(child: Text('Please log in to view your wishlist')),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(143, 0, 255, 1.0),
        height: 55,
        child: FlashyTabBar(
          backgroundColor: Color.fromRGBO(143, 0, 255, 1.0).withOpacity(0),
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) {
            if (index == 2) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? ''),
              //   ),
              // );
            } else {
              setState(() {
                _selectedIndex = index;
                switch (_selectedIndex) {
                  case 0:
                   _navigateToHomeScreen(context);
                  case 1:
                    _navigateToSearchScreen(context);
                    break;
                  case 2:
                    _navigateToWishlistScreen(context);
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
              // inactiveColor: Colors.white,
              title: Text(""),
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
              title: Text(""),

            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: SvgPicture.asset(
                "assets/images/Heart.svg",
                height: 24,

                color: Colors.white,
              ),
              inactiveColor: Colors.white,
              title: Text(""),

            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: SvgPicture.asset(
                "assets/images/ProfileIcon.svg",
                height: 34,

                color: Colors.white,
              ),
              inactiveColor: Colors.white,

              title: Text(""),

            ),
          ],
        ),
      ),
    );
  }
}

class Whislits extends StatefulWidget {
  final String propertyId;
  Color customTeal = Color(0xFF8F00FF);
  Whislits({
    required this.propertyId,
  });
  @override
  _WhislitsState createState() => _WhislitsState();
}
class _WhislitsState extends State<Whislits> {
  late Future<Map<String, dynamic>> propertyDataFuture;
  PageController _pageController = PageController();
  int _currentImageIndex = 0;
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
  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }
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
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('propert')
        .doc(widget.propertyId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    bool isInWishlist = false; // Assuming a variable to check wishlist status

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        actions: [
          Container(
            child: CircleAvatar(
              radius: 25,
              child: IconButton(
                onPressed: () {
                  // saveToWishlist();
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
          SizedBox(width: 25,),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: propertyDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No property data found.'));
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
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
         " ${propertyData['category']}",
                                  style: TextStyle(
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
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: ColorUtils.primaryColor(),
                                  borderRadius: BorderRadius.circular(20.0), // Border radius
                                ),
                                child: Text(
                                  " ${propertyData['subcategory']}", // Conditionally change text here
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
                                  color: ColorUtils.primaryColor(),
                                  borderRadius: BorderRadius.circular(20.0), // Border radius
                                ),
                                child: Text(
                                  " ${propertyData['propertyType']}", // Conditionally change text here
                                  style: TextStyle(
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
                                style: TextStyle(
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
                          SizedBox(width: 30,),
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
                                        " ${propertyData['balcony'] } balcony",
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
                                        " ${propertyData['bathroom']} bathroom",
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

                        ),
                      ),
                      SizedBox(height:10),
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
                                    markerId: MarkerId('property_location'),
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
                              padding: EdgeInsets.only(left: 10),
                              child: Wrap(
                                spacing: 10, // Adjust as needed for spacing between containers
                                children: List.generate(amenities.length, (index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.primaryColor(),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        amenities[index], // Display each amenity here
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
                                        "${propertyData['area']}  ${propertyData['areaType']}",
                                        style: TextStyle(fontSize: 16,  color: ColorUtils.primaryColor(),),
                                      ),
                                    ),
                                  ],
                                ),


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

                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        'road controller :',
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


                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        'Is this a corner area?',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        "${propertyData['isCornerArea']}",
                                        style: TextStyle(fontSize: 16, color: ColorUtils.primaryColor(),),
                                      ),
                                    ),
                                  ],
                                ),

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
                                      "${propertyData['parkingIncluded']}",
                                      style: TextStyle(fontSize: 16, color: ColorUtils.primaryColor(),),
                                    ),
                                  ),
                                ],
                              ),

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
                                              padding: EdgeInsets.all(10.0),
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

                      Text("Nearby Places:"),
                      ...propertyData['nearbyPlaces'].map<Widget>((place) {
                        return Text("${place['place']} (${place['distance']} km)");
                      }).toList(),
                      Text("Payment Rows:"),
                      ...propertyData['paymentRows'].map<Widget>((payment) {
                        return Text("${payment['category']}: ${payment['amount']} (${payment['type']})");
                      }).toList(),


                      ...propertyData['videos'].map<Widget>((video) {
                        return VideoPlayerWidget(videoUrl: video);
                      }).toList(),


                    ],
                  ),


                ],
              ),
            );
          }
        },
      ),
    );
  }
}




class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Center(child: CircularProgressIndicator()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _togglePlayback,
            ),
          ],
        ),
      ],
    );
  }
}
