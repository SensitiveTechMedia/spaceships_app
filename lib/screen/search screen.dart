import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart'; // Import Firestore

class PropertyModel {
  final String propertyName;
  final String propertyImage;
  final String address;
  final String amount;
  final String propertyType;
  final String balcony;
  final String propertyId;
  final String bedRooms;
  final String selectedDirection;
  final String bathrooms;
  final String kitchen;
  final String numberOfToilets;
  final String selectedFurnishedStatus;
  final String selectedParking;
  final String plotSquareFeet;
  final String latitude;
  final String longitude;
  final String sittingRoom;

  PropertyModel({
    required this.propertyName,
    required this.propertyImage,
    required this.address,
    required this.amount,
    required this.propertyType,
    required this.balcony,
    required this.propertyId,
    required this.bedRooms,
    required this.selectedDirection,
    required this.bathrooms,
    required this.kitchen,
    required this.numberOfToilets,
    required this.selectedFurnishedStatus,
    required this.selectedParking,
    required this.plotSquareFeet,
    required this.latitude,
    required this.longitude,
    required this.sittingRoom,
  });

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return PropertyModel(
      propertyName: data['propertyName'] ?? '',
      propertyImage: data['propertyImages'] != null ? data['propertyImages'][0] ?? '' : '',
      address: data['address'] ?? '',
      amount: data['amount'] ?? '',
      propertyType: data['propertyType'] ?? '',
      balcony: data['balcony'] ?? '',
      propertyId: data['propertyId'] ?? '',
      bedRooms: data['bedRooms'] ?? '',
      selectedDirection: data['selectedDirection'] ?? '',
      bathrooms: data['bathrooms'] ?? '',
      kitchen: data['kitchen'] ?? '',
      numberOfToilets: data['numberOfToilets'] ?? '',
      selectedFurnishedStatus: data['selectedFurnishedStatus'] ?? '',
      selectedParking: data['selectedParking'] ?? '',
      plotSquareFeet: data['plotSquareFeet'] ?? '',
      latitude: data['latitude'] != null ? data['latitude'].toString() : '',
      longitude: data['longitude'] != null ? data['longitude'].toString() : '',
      sittingRoom: data['sittingRoom'] ?? '',
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('property').get();
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
      property.propertyName.toLowerCase().contains(value.toLowerCase()) ||
          property.address.toLowerCase().contains(value.toLowerCase())).toList();
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
                                image: property.propertyImage.isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(property.propertyImage),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: property.propertyImage.isEmpty
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
                                  property.propertyName,
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
                                      property.address,
                                      style: TextStyle(
                                        color: ColorUtils.primaryColor(),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    '₹ ${property.amount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.primaryColor(),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '/month',
                                    style: TextStyle(
                                      color: ColorUtils.primaryColor(),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewage(
                          imageUrl: [property.propertyImage],
                          title: property.propertyType,
                          selectedAmenities: [],
                          property: '',
                          propertyName: property.propertyName,
                          propertytype: property.propertyType,
                          balcony: property.balcony,
                          bathroom: property.bathrooms,
                          sittingroom: property.sittingRoom,
                          toilet: property.numberOfToilets,
                          latitude: property.latitude,
                          longtitude: property.longitude,
                          squarefeet: property.plotSquareFeet,
                          facing: property.selectedDirection,
                          parkingoption: property.selectedParking,
                          kitchen: property.kitchen,
                          bedroom: property.bedRooms,
                          furnishedstatus: property.selectedFurnishedStatus,
                          amount: property.amount,
                          address: property.address,
                          propertyId: property.propertyId,
                        ),
                      ),
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

class Viewage extends StatefulWidget {
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

  Viewage({
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
  _WhislitState createState() => _WhislitState();
}

class _WhislitState extends State<Viewage> {
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
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String? userName;
  String? userMobileNumber;
  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
    fetchAmenities();
    fetchLocation();
    fetchpropertyimges();
    fetchUserDetails();
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
  Future<void> updateInterestDetails() async {
    try {
      if (user != null) {
        Timestamp currentTime = Timestamp.now();

        // Create a new document reference
        DocumentReference docRef = await FirebaseFirestore.instance.collection('interested').add({
          'name': nameController.text,
          'mobile_number': mobileController.text,
          'property_id': widget.propertyId,
          'user_uid': user!.uid,
          'submitted_date': currentTime,
          // Omitting 'status', 'comment', and 'updated_date' fields here
        });

        // Get the document ID
        String docId = docRef.id;

        // Update the document to set 'status', 'comment', and 'updated_date' as empty
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
                        color: ColorUtils.primaryColor(), // Green background color
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
                          color: ColorUtils.primaryColor(),
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
                          color: ColorUtils.primaryColor(),
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
                    color: ColorUtils.primaryColor(),
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
                          color: ColorUtils.primaryColor(),
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
                          color: ColorUtils.primaryColor(),
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
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // Allows the dialog to take up more space
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
                              Text('Enter Given details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                                    width: MediaQuery.of(context).size.width * 0.5, // half the width of the parent
                                    height: 45.0, // adjust to match the height of TextFields if necessary
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          // Unfocus the keyboard
                                          FocusScope.of(context).unfocus();

                                          if (user != null) {
                                            Timestamp currentTime = Timestamp.now();
                                            DocumentReference docRef = await FirebaseFirestore.instance.collection('interested').add({
                                              'name': nameController.text,
                                              'mobile_number': mobileController.text,
                                              'property_id': widget.propertyId,
                                              'user_uid': user!.uid,
                                              'submitted_date': currentTime,
                                            });

                                            String docId = docRef.id;

                                            await docRef.update({
                                              'status': '',
                                              'comment': '',
                                              'updated_date': '',
                                            });

                                            setState(() {
                                              userName = nameController.text;
                                              userMobileNumber = mobileController.text;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Interest successfully submitted.'),
                                              ),
                                            );
                                            Navigator.of(context).pop(); // Close the dialog after successful submission
                                          }
                                        } catch (e) {
                                          print('Error updating user details: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error updating user details'),
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
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>( ColorUtils.primaryColor(),),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text('Know More'),
                ),
              ),






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
                                "Chat with Support",style: TextStyle( color: ColorUtils.primaryColor(),fontSize: 18,),
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
                    color: ColorUtils.primaryColor()),),
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
                    color: ColorUtils.primaryColor(),),),
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
                            color: ColorUtils.primaryColor(),
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Squarefeet :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.squarefeet} sq.feet",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Furnished Status :',
                              style: TextStyle(fontSize:19, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.furnishedstatus}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Parking option :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.parkingoption}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Facing Direction :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(
                              "${widget.facing}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Gated Comunity :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(" ${gatedCommunity ? 'Yes' : 'No'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),

                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Possession Status :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(" ${possessionStatus ? 'Under Construction' : 'Ready to Move'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Available from:',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(
                              selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate!) : 'No date selected',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),


                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Show Pricing As :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(" ${showPriceAs ? 'Negotiable' : 'Call for Pricing'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'Tranasction Type :',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
                            ),
                          ),
                          DataCell(
                            Text(" ${transactionType ? 'New property' : 'Resale'}",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
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
