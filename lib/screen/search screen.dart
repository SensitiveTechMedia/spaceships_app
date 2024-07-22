import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/a.dart';

import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart'; // Import Firestore
class PropertyModel {
  String addressLine;
  List<String> amenities;
  String area;
  String areaType;
  String balcony;
  String bathroom;
  int bikeParkingCount;
  int carParkingCount;
  String category;
  final List<String> propertyImages;
  String dimension;
  String doorNo;
  bool featuredStatus;
  String floorNumber;
  String floorType;
  String furnishingType;
  bool isCornerArea;
  String landmark;
  String latitude;
  String locationAddress;
  String longitude;
  List<Map<String, dynamic>> nearbyPlaces;
  bool parkingIncluded;
  String parkingType;
  List<Map<String, dynamic>> paymentRows;
  String possessionType;
  List<String> propertyFacing;
  String propertyId;
  String propertyOwner;
  String propertyStatus;
  String propertyType;
  String roadController;
  String subcategory;
  String superbuildup;
  String totalArea;
  String uid;
  String undividedShare;
  List<String> videos;
  int yearsOld;

  PropertyModel( {
 required this.propertyImages,
    required this.category,
    required this.addressLine,
    required this.amenities,
    required  this.area,
    required this.areaType,
    required  this.balcony,
    required  this.bathroom,
    required  this.bikeParkingCount,
    required  this.carParkingCount,


    required  this.dimension,
    required  this.doorNo,
    required this.featuredStatus,
    required  this.floorNumber,
    required  this.floorType,
    required  this.furnishingType,
    required  this.isCornerArea,
    required  this.landmark,
    required  this.latitude,
    required  this.locationAddress,
    required   this.longitude,
    required  this.nearbyPlaces,
    required  this.parkingIncluded,
    required  this.parkingType,
    required   this.paymentRows,
    required  this.possessionType,
    required  this.propertyFacing,
    required   this.propertyId,
    required   this.propertyOwner,
    required   this.propertyStatus,
    required  this.propertyType,
    required  this.roadController,
    required  this.subcategory,
    required  this.superbuildup,
    required  this.totalArea,
    required   this.uid,
    required  this.undividedShare,
    required  this.videos,
    required  this.yearsOld,

  });

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return PropertyModel(
      addressLine: data['addressLine'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      area: data['area'] ?? '',
      areaType: data['areaType'] ?? '',
      balcony: data['balcony'] ?? '',
      bathroom: data['bathroom'] ?? '',
      bikeParkingCount: data['bikeParkingCount'] ?? 0,
      carParkingCount: data['carParkingCount'] ?? 0,
      category: data['category'] ?? '',

      dimension: data['dimension'] ?? '',
      doorNo: data['doorNo'] ?? '',
      featuredStatus: data['featuredStatus'] ?? false,
      floorNumber: data['floorNumber'] ?? '',
      floorType: data['floorType'] ?? '',
      furnishingType: data['furnishingType'] ?? '',
      isCornerArea: data['isCornerArea'] ?? false,
      landmark: data['landmark'] ?? '',
      latitude: data['latitude'] ?? '',
      locationAddress: data['locationAddress'] ?? '',
      longitude: data['longitude'] ?? '',
      nearbyPlaces: List<Map<String, dynamic>>.from(data['nearbyPlaces'] ?? []),
      parkingIncluded: data['parkingIncluded'] ?? false,
      parkingType: data['parkingType'] ?? '',
      paymentRows: List<Map<String, dynamic>>.from(data['paymentRows'] ?? []),
      possessionType: data['possessionType'] ?? '',
      propertyFacing: List<String>.from(data['propertyFacing'] ?? []),
      propertyId: data['propertyId'] ?? '',
      propertyOwner: data['propertyOwner'] ?? '',
      propertyStatus: data['propertyStatus'] ?? '',
      propertyType: data['propertyType'] ?? '',
      roadController: data['roadController'] ?? '',
      subcategory: data['subcategory'] ?? '',
      superbuildup: data['superbuildup'] ?? '',
      totalArea: data['totalArea'] ?? '',
      uid: data['uid'] ?? '',
      undividedShare: data['undividedShare'] ?? '',
      propertyImages: List<String>.from(data['PropertyImages'] ?? []),
      videos: List<String>.from(data['videos'] ?? []),
      yearsOld: data['yearsOld'] ?? 0,
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<PropertyModel> actualProperties = [];
  List<PropertyModel> filteredProperties = [];
  Color customTeal = Color(0xFF8F00FF);
  FocusNode _searchFocusNode = FocusNode();
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _fetchProperties();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Delay setting focus until after the widget has been built
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode when done
    super.dispose();
  }

  void _fetchProperties() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('propert').get();
      setState(() {
        actualProperties = querySnapshot.docs.map((doc) => PropertyModel.fromFirestore(doc)).toList();
        filteredProperties = actualProperties;
      });
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      filteredProperties = actualProperties.where((property) =>
      property.subcategory.toLowerCase().contains(value.toLowerCase()) ||
          property.area.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }
  void _navigateToWishlistScreen(BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WishlistScreen()),
    );
  }
  void _navigateToSearchScreen(BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
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
    // Navigate to HomeScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
    );
  }
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredProperties = actualProperties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Property'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FocusScope(
          node: FocusScopeNode(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                      : null,
                  hintText: 'Search Property',
                ),
              ),
              SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                PropertyModel property = filteredProperties[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                image: property.propertyImages.isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(property.propertyImages[0]),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: property.propertyImages.isEmpty
                                  ? Icon(Icons.image, size: 50)
                                  : null,
                            ),

                            Positioned(
                              bottom: 8,
                              left: 10,
                              child: Container(
                                width: 85,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(143, 0, 255, 0.55),
                                ),
                                child: Center(
                                  child: Text(
                                    property.propertyType,
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  property.subcategory,
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
                                      property.area,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Whislits(propertyId: property.propertyId,)),
                    );
                  },
                );
              },
            ),
          ),
          
                ]),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(143, 0, 255, 1.0),
        height: 55,
        child: FlashyTabBar(
          backgroundColor: Color.fromRGBO(143, 0, 255, 1.0).withOpacity(0),
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) {
            if (index == 1) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? ''),
              //   ),
              // );
            } else
            {
              setState(() {
                _selectedIndex = index;
                switch (_selectedIndex) {
                  case 0:
                    _navigateToHomeScreen(context);
                  case 1:
                    // _navigateToSearchScreen(context);
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

