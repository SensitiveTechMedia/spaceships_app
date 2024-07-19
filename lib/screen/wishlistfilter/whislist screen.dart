import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/filter.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/wishlistfilter/tune.dart';

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

  @override
  void initState() {
    super.initState();
    propertyDataFuture = fetchPropertyData();
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
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      if (propertyData['PropertyImages'] != null)
                        ...propertyData['PropertyImages'].map<Widget>((image) {
                          return Image.network(image);
                        }).toList(),
                      Text("Address: ${propertyData['addressLine']}"),
                      Text("Area: ${propertyData['area']}"),
                      Text("Area Type: ${propertyData['areaType']}"),
                      Text("Balcony: ${propertyData['balcony']}"),
                      Text("Bathroom: ${propertyData['bathroom']}"),
                      Text("Bike Parking Count: ${propertyData['bikeParkingCount']}"),
                      Text("Car Parking Count: ${propertyData['carParkingCount']}"),
                      Text("Category: ${propertyData['category']}"),
                      Text("Dimension: ${propertyData['dimension']}"),
                      Text("Door No: ${propertyData['doorNo']}"),
                      Text("Floor Number: ${propertyData['floorNumber']}"),
                      Text("Floor Type: ${propertyData['floorType']}"),
                      Text("Furnishing Type: ${propertyData['furnishingType']}"),
                      Text("Landmark: ${propertyData['landmark']}"),
                      Text("Location Address: ${propertyData['locationaddress']}"),
                      Text("Nearby Places:"),
                      ...propertyData['nearbyPlaces'].map<Widget>((place) {
                        return Text("${place['place']} (${place['distance']} km)");
                      }).toList(),
                      Text("Parking Included: ${propertyData['parkingIncluded']}"),
                      Text("Parking Type: ${propertyData['parkingType']}"),
                      Text("Payment Rows:"),
                      ...propertyData['paymentRows'].map<Widget>((payment) {
                        return Text("${payment['category']}: ${payment['amount']} (${payment['type']})");
                      }).toList(),
                      Text("Possession Type: ${propertyData['possessionType']}"),
                      Text("Property Facing: ${propertyData['propertyFacing'].join(', ')}"),
                      Text("Property Status: ${propertyData['propertyStatus']}"),
                      Text("Property Type: ${propertyData['propertyType']}"),
                      Text("Road Controller: ${propertyData['roadController']}"),
                      Text("Subcategory: ${propertyData['subcategory']}"),
                      Text("Super Build Up: ${propertyData['superbuildup']}"),
                      Text("Total Area: ${propertyData['totalArea']}"),
                      Text("Undivided Share: ${propertyData['undividedshare']}"),
                      ...propertyData['videos'].map<Widget>((video) {
                        return Text("Video: $video"); // Replace with video player if needed
                      }).toList(),
                      Text("Years Old: ${propertyData['yearsOld']}"),
                    ],
                  ),

                  Positioned(
                    top: 10,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 40,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 24,
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              // Handle share action
                            },
                            icon: SvgPicture.asset(
                              'assets/images/ShareIcon.svg',
                              width: 24,
                              height: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        // Text(
                        //   "${widget.propertyId}",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: isInWishlist ? Colors.red : Colors.green,
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
                      ],
                    ),
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
