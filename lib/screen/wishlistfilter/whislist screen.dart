import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
                MaterialPageRoute(builder: (context) =>  Tune(
                  onApplyFilters: applyFilters,

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
                          imageUrl: wishlistItem['imageUrl'] != null
                              ? List<String>.from(wishlistItem['imageUrl'])
                              : [],
                          title: wishlistItem['propertytype'] ?? 'No Title',
                          selectedAmenities: wishlistItem['selectedAmenities'] != null
                              ? List<String>.from(wishlistItem['selectedAmenities'])
                              : [],
                          property: wishlistItem['property'] ?? '',
                          propertyName: wishlistItem['propertyName'] ?? '',
                          propertytype: wishlistItem['subcategory'] ?? '',
                          balcony: wishlistItem['balcony'] ?? '',
                          bathroom: wishlistItem['bathrooms'] ?? '',
                          sittingroom: wishlistItem['sittingRoom'] ?? '',
                          toilet: wishlistItem['numberOfToilets'] ?? '',
                          latitude: wishlistItem['latitude'] != null
                              ? wishlistItem['latitude'].toString()
                              : '0.0',
                          longtitude: wishlistItem['longitude'] != null
                              ? wishlistItem['longitude'].toString()
                              : '0.0',
                          squarefeet: wishlistItem['plotSquareFeet'] ?? '',
                          facing: wishlistItem['selectedDirection'] ?? '',
                          parkingoption: wishlistItem['selectedParking'] ?? '',
                          kitchen: wishlistItem['kitchen'] ?? '',
                          bedroom: wishlistItem['bedRooms'] ?? '',
                          furnishedstatus: wishlistItem['furnishedstatus'] ?? '',
                          amount: wishlistItem['amount'] ?? '',
                          address: wishlistItem['address'] ?? '',
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
                                    wishlistItem['imageUrl'].isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(wishlistItem['imageUrl']),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: wishlistItem['imageUrl'] == null ||
                                  wishlistItem['imageUrl'].isEmpty
                                  ? Icon(Icons.image, size: 50)
                                  : null,
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Container(
                                width: 30, // Adjust width and height for the circular button
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen, // Green background color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero, // Remove padding for a clean circular shape
                                  iconSize: 1, // Adjust icon size as needed
                                  color: Colors.white, // Color of the IconButton itself
                                  onPressed: () {

                                  },
                                  icon: SvgPicture.asset(
                                    'assets/images/HeartIcon.svg',
                                    color: Colors.white, // Color of the heart icon
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 10,
                              child: Container(
                                width: 85, // Adjust width and height for the circular button
                                height: 20,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                  color: ColorUtils.primaryColor(),
                                  // Green background color
                                  // Circular shape
                                ),
                                child: Text( wishlistItem[ 'subcategory'] ?? 'No category',style: TextStyle(color: Colors.white,fontSize: 14),


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
                                  wishlistItem['propertyType'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: customTeal,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: customTeal,
                                    size: 20,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      wishlistItem['addressLine'] ?? 'No Address',
                                      style: TextStyle(
                                        color: customTeal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              // Row(
                              //   children: [
                              //     Text(
                              //       '₹ ${wishlistItem['amount'] ?? 'No Amount'}',
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         color: customTeal,
                              //         fontSize: 20,
                              //       ),
                              //     ),
                              //     Text(
                              //       '/month',
                              //       style: TextStyle(
                              //         color: customTeal,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
  final List<String> imageUrl;
  final String propertyId;
  final String title;
  final String property;
  final String propertyName;
  final List <String> selectedAmenities;
  final String propertytype;
  final String address;
  final String balcony;
  final String bathroom;
  final String kitchen;
  final String bedroom;
  final String furnishedstatus;
  final String sittingroom;
  final String toilet;
  final String latitude;
  final String amount;
  final String longtitude;
  final String squarefeet;
  final String facing;
  final String parkingoption;
  Color customTeal = Color(0xFF8F00FF);

  Whislits({
    required this.property,
    required this.propertyName,
    required this.selectedAmenities,
    required this.propertytype,
    required this.imageUrl,
    required this.balcony,
    required this.title,
    required this.bathroom,
    required this.sittingroom,
    required this.toilet,
    required this.latitude,
    required this.longtitude,
    required this.squarefeet,
    required this.facing,
    required this.parkingoption,
    required this.kitchen,
    required this.bedroom,
    required this.furnishedstatus,
    required this.amount,
    required this.address,
    required this.propertyId,
  });

  @override
  _WhislitsState createState() => _WhislitsState();
}

class _WhislitsState extends State<Whislits> {
  User? user = FirebaseAuth.instance.currentUser;
  GoogleMapController? _mapController;
  int _currentIndex = 0;
  List<String> amenities = [];
  Position? _currentPosition;
  bool isInWishlist = false;
  List<String> propertyImages = [];
  DateTime? selectedDate;
  String formattedDate = '';
  bool gatedCommunity = false; // Default value if not fetched
  bool possessionStatus = false; // Default value if not fetched
  bool showPriceAs = false; // Default value if not fetched
  bool transactionType = false;
  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
    fetchAmenities();
    fetchLocation();
    fetchpropertyimges();
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
  Future<void> fetchpropertyimges () async {
    try {
      DocumentSnapshot propertyImagesQuery = await FirebaseFirestore.instance
          .collection('property')
          .doc(widget.propertyId)
          .get();

      if (propertyImagesQuery.exists) {
        Map<String, dynamic>? data = propertyImagesQuery.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('propertyImages')) {
          setState(() {
            propertyImages = List<String>.from(data['propertyImages'] as List<dynamic>);

            selectedDate = data['selectedDate'] != null ? DateTime.parse(data['selectedDate']) : null;
            formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);

            gatedCommunity = data['GatedCommunity'] ?? false;
            possessionStatus = data['PossessionStatus'] ?? false;
            showPriceAs = data['ShowPriceAs'] ?? false;
            transactionType = data['TransactionType'] ?? false;

          });
          print('Fetched propertyImages: $propertyImages');
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
  Future<void> fetchAmenities() async {
    try {
      DocumentSnapshot amenitiesQuery = await FirebaseFirestore.instance
          .collection('property')
          .doc(widget.propertyId)
          .get();

      if (amenitiesQuery.exists) {
        Map<String, dynamic>? data =
        amenitiesQuery.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('selectedAmenities')) {
          setState(() {
            amenities =
            List<String>.from(data['selectedAmenities'] as List<dynamic>);
          });
          print('Fetched Amenities: $amenities');
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
        var querySnapshot = await FirebaseFirestore.instance
            .collection('wishlist')
            .where('userId', isEqualTo: uid)
            .where('propertyId', isEqualTo: widget.propertyId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Property exists in wishlist, so remove it
          await FirebaseFirestore.instance
              .collection('wishlist')
              .doc(querySnapshot.docs.first.id)
              .delete();
          setState(() {
            isInWishlist = false;
          });
          print('Property removed from wishlist');
        } else {
          // Property does not exist in wishlist, so add it
          await FirebaseFirestore.instance.collection('wishlist').add({
            'userId': uid,
            'propertyId': widget.propertyId,
            'category': widget.title,
            'selectedAmenities' :widget.selectedAmenities,
            'property' :widget.property,
            'propertyName':widget.propertyName,
            'propertyType': widget.propertytype,
            'address': widget.address,
            'balcony': widget.balcony,
            'bathrooms': widget.bathroom,
            'kitchen': widget.kitchen,
            'bedRooms': widget.bedroom,
            'furnishedstatus': widget.furnishedstatus,
            'sittingRoom': widget.sittingroom,
            'numberOfToilets': widget.toilet,
            'latitude': widget.latitude,
            'amount': widget.amount,
            'longitude': widget.longtitude,
            'plotSquareFeet': widget.squarefeet,
            'selectedDirection': widget.facing,
            'selectedParking': widget.parkingoption,
            'propertyImages': widget.imageUrl,
          });
          setState(() {
            isInWishlist = true;
          });
          print('Property added to wishlist');
        }
      } else {
        print('User is not logged in');
        // Handle scenario where user is not logged in
      }
    } catch (e) {
      print('Error saving to wishlist: $e');
      // Handle error saving to wishlist
    }
  }
  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: widget.imageUrl.isNotEmpty
                            ? Image.network(
                          widget.imageUrl[_currentIndex],
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
                                  'Image Load Error',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        )

                            : Container(
                          color: Colors.grey,
                          child: Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 40,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:  ColorUtils.primaryColor(), // Green background color
                        borderRadius: BorderRadius.circular(20.0), // Border radius
                      ),
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
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
                      child: Column(
                        children: [
                          for (int i = 0; i < (propertyImages.length > 3 ? 3 : propertyImages.length); i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  _showFullScreenImage(propertyImages[i]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(

                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5.0),
                                    // Adjust as needed
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(2, 2),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0), // Match border radius with the container
                                    child: Image.network(
                                      propertyImages[i],
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'I',
                                              style: TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
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
                        CircleAvatar(
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.propertyName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.customTeal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.amount,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.customTeal,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 18),
                  Icon(
                    Icons.location_on,
                    color: widget.customTeal,
                    size: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.customTeal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "per month",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.customTeal,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Row(
              //   children: [
              //     SizedBox(width: 50,),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //         decoration: BoxDecoration(
              //           color: Color.fromRGBO(139, 200, 62, 1.0), // Green background color
              //           borderRadius: BorderRadius.circular(20.0), // Border radius
              //         ),
              //         child: Text(
              //           "${widget.propertytype}",
              //           style: TextStyle(
              //             fontSize: 16,
              //             color: Colors.white, // Text color
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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

              Padding(
                padding: EdgeInsets.all(10), // Adjust the amount of outer padding as needed
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2), // Adjust opacity as needed
                    borderRadius: BorderRadius.circular(10), // Adjust radius as needed
                  ),
                  padding: EdgeInsets.all(15), // Add padding for space around the container content
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child:  Image.asset(
                          "assets/images/logos.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.fitWidth,
                        ),
                      ),


                      SizedBox(width: 55),
                      Align(
                        alignment: Alignment.topRight,
                        child:SvgPicture.asset(
                          'assets/images/ChatIcon.svg',
                          width: 40,  // Adjust width and height as needed
                          height: 34,
                        ),

                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                "Chat with Support",style: TextStyle(color:widget.customTeal,fontSize: 18,),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Sitting Room Container
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
                              'assets/images/sofa.svg', // Path to sitting room SVG asset
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(139, 200, 62, 1.0),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${widget.sittingroom} sitting room ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bathroom Container
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
                              'assets/images/balcony.svg', // Path to bathroom SVG asset
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
                              'assets/images/kitchen.svg',
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(139, 200, 62, 1.0),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${widget.kitchen} kitchen ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Another Bed Container
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
                              'assets/images/Bed.svg', // Path to bathroom SVG asset
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(139, 200, 62, 1.0),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${widget.bedroom} Bedroom",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
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
                              'assets/images/toilet.svg', // Path to bathroom SVG asset
                              width: 24,
                              height: 24,
                              color: Color.fromRGBO(139, 200, 62, 1.0),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${widget.toilet} Toilet",
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




              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: Text("Location details",style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.customTeal,),),
                ),
              ),

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
                          target: LatLng(
                            widget.latitude != null ? double.parse(widget.latitude) : 0.0,
                            widget.longtitude != null ? double.parse(widget.longtitude) : 0.0,
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
                              widget.latitude != null ? double.parse(widget.latitude) : 0.0,
                              widget.longtitude != null ? double.parse(widget.longtitude) : 0.0,
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
                    color: widget.customTeal,),),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Displaying fetched amenities
                    for (String amenity in amenities)
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color:widget.customTeal,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
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
                          'Detail',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.customTeal),
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
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Squarefeet :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.squarefeet} sq.feet",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Furnished Status :',
                              style: TextStyle(fontSize:19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.furnishedstatus}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Parking option :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.parkingoption}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Facing Direction :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.facing}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Gated Comunity :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(" ${gatedCommunity ? 'Yes' : 'No'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),

                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Possession Status :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(" ${possessionStatus ? 'Under Construction' : 'Ready to Move'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Available from:',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(
                              selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : 'No date selected',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),


                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Show Pricing As :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(" ${showPriceAs ? 'Negotiable' : 'Call for Pricing'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Tranasction Type :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                          DataCell(
                            Text(" ${transactionType ? 'New property' : 'Resale'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: widget.customTeal),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),

            ]
        ),
      ),
    );
  }
}
