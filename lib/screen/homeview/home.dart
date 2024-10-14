import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/jvproperty/addpropertyjvproperties.dart';
import 'package:spaceships/jvproperty/jv%20properties.dart';
import 'package:spaceships/jvproperty/propertyinventory.dart';
import 'package:spaceships/jvproperty/propertyservices.dart';
import 'package:spaceships/screen/Notification.dart';
import 'package:spaceships/screen/addview/add%20property.dart';
import 'package:spaceships/screen/category/All.dart';
import 'package:spaceships/screen/filter.dart';
import 'package:spaceships/screen/helpsupport.dart';
import 'package:spaceships/screen/homeview/featuredproperties.dart';
import 'package:spaceships/screen/profileedit/profile%20page.dart';
import 'package:spaceships/screen/registerloginforgot/loginoption.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart';
import 'propertyview.dart';
class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});
  @override
  _TestScreenState createState() => _TestScreenState();
}
class _TestScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Color customTeal = const Color(0xFF8F00FF);
  late TabController _tabController;
  User? user = FirebaseAuth.instance.currentUser;
  List<String> cat = ["Flat", "Villa", "Plot", "Commercial Space"];
  List<String> cate = ["Flat", "Villa", "Plot", "Commercial  Space","Hostel"];
  final List<Map<String, dynamic>> propertyTopics = [
    {"text": "Property Maintenance", "icon": Icons.home},
    // {"text": "Property Maintenance", "icon": Icons.home, "page": PropertyMaintenanceScreen()},
    {"text": "Sale             Deed", "icon": Icons.attach_file},
    {"text": "Rental Agreement", "icon": Icons.assignment},
    {"text": "Lease Agreement", "icon": Icons.book},
    {"text": "Property Registration", "icon": Icons.location_city},
    {"text": "Katha        Transfer", "icon": Icons.compare_arrows},
    {"text": "Property               EC", "icon": Icons.eco},
    {"text": "Property                    Tax", "icon": Icons.money},
    {"text": "BESCOM       Transfer", "icon": Icons.flash_on},
    {"text": "BWSSB       Transfer", "icon": Icons.opacity},
    {"text": "Knowledge       Base", "icon": Icons.library_books},
    {"text": "Property Checklist", "icon": Icons.playlist_add_check},
  ];
  int _selectedIndex = 0;
  String category  = '';
  String subcategory = '';
  String propertyType="";
  String propertyOwner = "";
  int yearsOld = 0;
  String furnishingType ="";
  String totalArea="";
  String dimension="";
  String latitude = "";
  String undividedshare="";
  String longitude ="";
  String superbuildup="";
  String roadController = "";
  bool isCornerArea = false;

  String possessionType = "";
  String areaType = "";
bool featuredStatus = false;
  int _selecteIndex = 0;
  final int _selecteddIndex = 0;
  int _seletedIndex = 0;
  String floorNumber = "";
  String balcony = "";
  String bathroom = "";
  String floorType = ""; String doorNo = "";
  String addressLine = "";
  String area = "";
  String locationaddress = "";
  String landmark = "";
  bool parkingIncluded=false;
  String parkingType = "";
  int carParkingCount= 0;
 int bikeParkingCount= 0;
  List<String> paymentRows = [];
  List<String> propertyvideo = [];
  List<String> propertyImages = [];
  List<int> getFeaturedPropertyIndices() {
    List<int> featuredIndices = [];
    for (int i = 0; i < filteredfeaturedStatus.length; i++) {
      if (filteredfeaturedStatus[i]) {
        featuredIndices.add(i);
      }
    }
    return featuredIndices;
  }

  late User _user;
  String _userName = '';
  String _usermobile = '';
  String _userEmail = '';
  String _userImage = '';
  String? userName;
  String? userMobileNumber;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? selectedPropertyType;
  final List<String> propertyTypes = ["Flat", "Plot", "Villa", "Commercial"];
  List<String> filteredcategory = [];
  List<String> filteredsubcategory = [];
  List<String> filteredpropertyType = [];
  List<String> filteredpropertyOwner = [];
  List<int> filteredyearsOld = [];
  List<String> filteredfurnishingType = [];
  List<String> filteredtotalArea = [];
  List<String> filtereddimension = [];
  List<String> filteredundividedshare = [];
  List<String> filteredsuperbuildup = [];
  List<String> filteredlatitude = [];
  List<String> filteredlongtitude = [];
  List<String> filteredroadController = [];
  List<bool> filteredisCornerArea = [];
  List<bool> filteredfeaturedStatus = [];

  List<String> filteredpossessionType = [];
  List<String> filteredareaType = [];
  List<String> filteredpropertyFacing = [];
  List<Map<String, dynamic>> filteredpaymentRows = [];
  List<String> filteredpropertyId = [];
  List<String> filteredfloorNumber = [];
  List<String> filteredbalcony = [];
  List<String> filteredbathroom = [];
  List<String> filteredfloorType = [];
  List<String> filtereddoorNo = [];
  List<String> filteredaddressLine = [];
  List<String> filteredarea = [];
  List<String> filteredlocationaddress = [];
  // List<String> filteredselectedlocation = [];
  List<String> filteredlandmark = [];
  List<String> filteredamenities = [];
  List<Map<String, dynamic>> filterednearbyPlaces = [];
  List<bool> filteredparkingIncluded = [];
  List<String> filteredparkingType = [];
  List<int> filteredcarParkingCount = [];
  List<int> filteredbikeParkingCount = [];
  List<String> filteredPropertyImages = [];
  List<String> filteredPropertyvideo = [];
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  Timer? _timer;
  late Future<List<Map<String, dynamic>>> _bannerFuture;
  DateTime? currentBackPressTime;
  @override
  void initState() {
    super.initState();
    fetchUserDetail();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    fetchProperties();
    fetchUserDetails();
    _bannerFuture = _fetchBanners();
    _startAutoScroll();
  }
  Future<void> fetchUserDetail() async {
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
  Future<List<Map<String, dynamic>>> _fetchBanners() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('banners').get();
    List<Map<String, dynamic>> banners = snapshot.docs.map((doc) {
      List<String> imageUrls = List<String>.from(doc['images']); // Get all images from the 'images' array
      // Filter out invalid or empty URLs
      imageUrls.removeWhere((url) => url.isEmpty || !url.startsWith('http'));
      return {
        'imageUrls': imageUrls,
      };
    }).toList();

    return banners;
  }
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page?.toInt() ?? _pageController.initialPage;
        if (nextPage == (_pageController.positions.first.maxScrollExtent / MediaQuery.of(context).size.width).round()) {
          nextPage = 0; // Go back to the first page
          _pageController.jumpToPage(nextPage);
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  void _navigateToSearchScreen(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen(


      ),),);
  }

  Future<void> fetchUserDetails() async {
    try {
      _user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
      if (userData.exists) {
        setState(() {
          _userName = userData['name'];
          _usermobile = userData['number'];
          _userEmail = userData['email'];
          _userImage = userData['profile_picture'];
        });
      }
        } catch (e) {
      print("Error fetching user data: $e");
    }
  }
  void applyFilters(Map<String, dynamic> filters) {
    setState(() {
      // Example filter application logic
      propertyImages = propertyImages.where((image) {
        // Add your filter conditions here
        return true; // Replace with actual filter logic
      }).toList();




    });
  }


  void _navigateToWishlistScreen(BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WishlistScreen()),
    );
  }
  void navigateToProfileScreen (BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? '')),
    );
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> fetchProperties() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await getAllProperties();

      List<String> category = [];
      List<String> subcategory = [];
      List<String> images = [];
      List<String> videos = [];
      List<String> propertyType = [];
      List<String> propertyOwner = [];
      List<int?> yearsOld = [];
      List<String> furnishingType = [];
      List<String> totalArea = [];
      List<String> postuid = [];
      List<String> dimension = [];
      List<String> undividedshare = [];
      List<String> latitude = [];
      List<String> longitude = [];
      List<String> superbuildup = [];
      List<String> roadController = [];
      List<bool> isCornerArea = [];
      List<bool> featuredStatus = [];

      List<String> possessionType = [];
      List<String> areaType = [];
      List<String> propertyId = [];
      List<String> propertyFacing = [];
      List<Map<String, dynamic>> paymentRows = [];
      List<String> floorNumber = [];
      List<String> balcony = [];
      List<String> bathroom = [];
      List<String> floorType = [];
      List<String> doorNo = [];
      List<String> addressLine = [];
      List<String> area = [];
      List<String> locationaddress = [];
      List<String> landmark = [];
      List<String> amenities = [];
      List<Map<String, dynamic>>nearbyPlaces = [];

      List<bool> parkingIncluded = [];
      List<String> parkingType = [];
      List<int> carParkingCount = [];
      List<int> bikeParkingCount = [];
      for (var doc in querySnapshot.docs) {
        List<dynamic>? imageUrls = doc['PropertyImages'];
        List<dynamic>? videoUrls = doc['videos'];

        images.addAll(imageUrls?.map((url) => url.toString()) ?? []);
        videos.addAll(videoUrls?.map((url) => url.toString()) ?? []);

        // Fetching other data types
        category.add(doc['category'] ?? '');
        subcategory.add(doc['subcategory'] ?? '');
        propertyType.add(doc['propertyType'] ?? '');
        propertyOwner.add(doc['propertyOwner'] ?? '');
        postuid.add(doc['uid'] ?? '');

        // Handling yearsOld (nullable int)
        dynamic yearsOldData = doc['yearsOld'];
        int? yearsOldValue;
        if (yearsOldData is int) {
          yearsOldValue = yearsOldData;
        } else if (yearsOldData is String) {
          yearsOldValue = int.tryParse(yearsOldData);
        } else {
          yearsOldValue = null; // or handle default case
        }
        yearsOld.add(yearsOldValue);

        furnishingType.add(doc['furnishingType'] ?? '');
        totalArea.add(doc['totalArea'] ?? '');
        latitude.add(doc['latitude'] ?? '');

        longitude.add(doc['longitude'] ?? '');

        dimension.add(doc['dimension'] ?? '');

        undividedshare.add(doc['undividedshare'] ?? '');

        superbuildup.add(doc['superbuildup'] ?? '');
        roadController.add(doc['roadController'] ?? '');
        isCornerArea.add(doc['isCornerArea'] ?? false);
        featuredStatus.add(doc['featuredStatus'] ?? false);

        propertyId.add(doc['propertyId'] ?? '');
        possessionType.add(doc['possessionType'] ?? '');
        areaType.add(doc['areaType'] ?? '');
        propertyFacing.addAll(List<String>.from(doc['propertyFacing'] ?? []));
        List<dynamic>? paymentRowsData = doc['paymentRows'];
        if (paymentRowsData != null) {
          paymentRows.addAll(paymentRowsData.map((row) => row as Map<String, dynamic>));
        }
        floorNumber.add(doc['floorNumber'] ?? '');
        balcony.add(doc['balcony'] ?? '');
        bathroom.add(doc['bathroom'] ?? '');
        floorType.add(doc['floorType'] ?? '');
        doorNo.add(doc['doorNo'] ?? '');
        addressLine.add(doc['addressLine'] ?? '');
        area.add(doc['area'] ?? '');
        locationaddress.add(doc['locationaddress'] ?? '');
        landmark.add(doc['landmark'] ?? '');
        parkingIncluded.add(doc['parkingIncluded'] ?? false);
        parkingType.add(doc['parkingType'] ?? '');

        carParkingCount.add(doc['carParkingCount'] ?? 0);
        bikeParkingCount.add(doc['bikeParkingCount'] ?? 0);
        amenities.addAll(List<String>.from(doc['amenities'] ?? []));


        List<dynamic>? nearbyPlacesData = doc['nearbyPlaces'];
        if (nearbyPlacesData != null) {
          nearbyPlaces.addAll(nearbyPlacesData.map((row) => row as Map<String, dynamic>));
        }


      }

      setState(() {
        filteredcategory = category;
        filteredsubcategory = subcategory;
        filteredpropertyType = propertyType;
        filteredpropertyOwner = propertyOwner;
        filteredyearsOld = yearsOld.whereType<int>().toList(); // Convert Iterable<int> to List<int>
        filteredfurnishingType = furnishingType;
        filteredtotalArea = totalArea;
        filtereddimension = dimension;
        filteredundividedshare = undividedshare;
        filteredsuperbuildup = superbuildup;
        filteredlatitude = latitude;
        filteredlongtitude = longitude;
        filteredroadController = roadController;
        filteredisCornerArea = isCornerArea;
        filteredfeaturedStatus = featuredStatus;

        filteredpossessionType = possessionType;
        filteredareaType = areaType;
        filteredpropertyFacing = propertyFacing;
        filteredpaymentRows = paymentRows;
        filteredpropertyId = propertyId;
        filteredfloorNumber = floorNumber;
        filteredbalcony = balcony;
        filteredbathroom = bathroom;
        filteredfloorType = floorType;
        filtereddoorNo = doorNo;
        filteredaddressLine = addressLine;
        filteredarea = area;
        filteredlocationaddress = locationaddress;
        filteredlandmark = landmark;
        filteredamenities = amenities;
        filterednearbyPlaces = nearbyPlaces;
        filteredparkingIncluded = parkingIncluded;
        filteredparkingType = parkingType;
        filteredbikeParkingCount = bikeParkingCount;
        filteredcarParkingCount = carParkingCount;
        filteredPropertyImages = images;
        filteredPropertyvideo = videos;

        _isLoading = false;
      });

    } catch (e) {
      print('Error fetching properties: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _navigateToSellCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JvAddProperty(),
      ),
    );
    }
  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.primaryColor(),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.transparent, // Set transparent to use custom background
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        _signOut().then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginOptionScreen()),
                              (route) => false,
                        ));
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.primaryColor(),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.transparent, // Set transparent to use custom background
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 0.5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Need some help?"),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text("Give us a call at +1234567890"),
                          SizedBox(width: 5),
                          // SvgPicture.asset(
                          //   'assets/images/call.svg', // Replace with your SVG asset path
                          //   height: 30, // Adjust height as needed
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }





  void _showModalBottomSheet(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
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
                  Text('Enter Given Details for $title', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedPropertyType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: 'Property Type',
                    ),
                    items: propertyTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPropertyType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: mobileController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: 'Mobile Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: 'Comments',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 15),
                  _isLoading
                      ? Container(     child: LoadingAnimationWidget.stretchedDots(
                    color: ColorUtils.primaryColor(),
                    size: 50,
                  ),) // Show circular progress indicator if loading
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 45.0,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            try {
                              setState(() {
                                _isLoading = true; // Start loading
                              });

                              // Prepare data to be stored
                              Map<String, dynamic> formData = {
                                'propertyType': selectedPropertyType,
                                'name': nameController.text.trim(),
                                'mobileNumber': mobileController.text.trim(),
                                'comments': commentController.text.trim(),
                                'timestamp': FieldValue.serverTimestamp(),
                                'userId': user!.uid,
                                'selectedTitle': title,
                              };

                              // Add to Firestore collection
                              await FirebaseFirestore.instance.collection('property_services').add(formData);

                              setState(() {
                                _isLoading = false; // Stop loading
                              });

                              // Close modal after submission
                              Navigator.of(context).pop();
                            } catch (e) {
                              print('Error submitting details: $e');
                              setState(() {
                                _isLoading = false; // Stop loading on error
                              });
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
                            backgroundColor: WidgetStateProperty.all<Color>(ColorUtils.primaryColor()),
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
          );
        },
      ),
    );
  }

// Example method to get all properties
  Future<QuerySnapshot> getAllProperties() async {
    // Your logic to get all properties.
    // For example, if you're using Firebase Firestore:
    CollectionReference properties = FirebaseFirestore.instance.collection('propert');
    return await properties.get();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Double Tap to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tabWidth = (width - 90) / 2;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        drawer: _buildDrawer(context),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust spacing evenly
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: _navigateToSellCategory,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: customTeal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Sell',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
      
                              ),
                            ),
                            const SizedBox(width: 5), // Adjust the width between buttons
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 0,selecteddIndex: 1,)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor:    ColorUtils.primaryColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Buy',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                              ),
                            ),
                            const SizedBox(width: 5), // Adjust the width between buttons
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 0,selecteddIndex: 2,)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor:    ColorUtils.primaryColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Rent',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                              ),
                            ),
                            const SizedBox(width: 5), // Adjust the width between buttons
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 0, selecteddIndex: 3,)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: ColorUtils.primaryColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Lease',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust horizontal padding as needed
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchScreen()),
                          );
                        },
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchScreen()),
                            );
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.onPrimary,
                            border: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.red),
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                                );
                              },
                              child: Icon(Icons.search, color: ColorUtils.primaryColor()),
                            ),
                            suffixIcon: UnconstrainedBox(
                              child: Row(
                                children: [
                                  Container(
                                    width: 1,
                                    color: ColorUtils.primaryColor(),
                                    // color: ColorCodes.grey.withOpacity(0.4),
                                  ),
                                  SizedBox(width: width * 0.04),
                                  IconButton(
                                    icon: Icon(Icons.tune,    color: ColorUtils.primaryColor(),),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Screen(onApplyFilters: (Map<String, dynamic> filters) {  },
      
                                        )),
                                      );
                                    },
                                  ),
                                  SizedBox(width: width * 0.02),
                                ],
                              ),
                            ),
                            constraints: const BoxConstraints(maxHeight: 80, maxWidth: double.infinity), // Ensure it takes full width
                            contentPadding: const EdgeInsets.only(top: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue),
                              // borderSide: BorderSide.none,
                            ),
                            hintText: 'Search House, Apartment, etc',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
      
      
      
      
      
            ],
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(cate.length, (index) {
                        bool isSelected = _selecteIndex == index;
      
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selecteIndex = index; // Update the selected index
                            });
      
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 1,selecteddIndex: 0,)),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 2,selecteddIndex: 0,)),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 3,selecteddIndex: 0,)),
                                );
                                break;
                              case 3:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 4,selecteddIndex: 0,)),
                                );
                                break;
                              case 4:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 5,selecteddIndex: 0,)),
                                );
                                break;
                              case 5:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 6,selecteddIndex: 0,)),
                                );
                                break;
                              case 6:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AllPage(selecteIndex: 7,selecteddIndex: 0,)),
                                );
                                break;
      
                              default:
                                break;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              width: 100, // Fixed width
                              height: 80, // Fixed height
                              decoration: BoxDecoration(
      
                                // color: isSelected ? customTeal : Colors.white,
                                borderRadius: BorderRadius.circular(5), // Updated border radius
                                border: Border.all(
                                  // color: isSelected ? customTeal : Colors.white,
                                  color: isSelected ? customTeal : customTeal, // Blue for unselected, customTeal for selected
                                  width: 1, // Adjust border width as needed
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    index == 0
                                        ? Icons.apartment
                                        : index == 1
                                        ? Icons.home
                                        : index == 2
                                        ? Icons.landscape
                                        : index == 3
                                        ? Icons.home_max_rounded
                                        : Icons.villa,
                                    color: isSelected ? customTeal : customTeal,
                                  ),
                                  const SizedBox(height: 5), // Added space between icon and text
                                  Text(
                                    cate[index],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? Colors.black : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
      
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _bannerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(
                      child: Container(
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: ColorUtils.primaryColor(),
                          size: 50,
                        ),
                      ),),);
                }
      
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }
      
                final banners = snapshot.data;
      
                if (banners == null || banners.isEmpty) {
                  return const Center(child: Text('No banners available'));
                }
      
                return Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        final imageUrls = banner['imageUrls'] as List<String>;
      
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, imageIndex) {
                            final imageUrl = imageUrls[imageIndex];
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width - 20, // Adjust width as needed
                                  height: 200,
    loadingBuilder: (context, child, progress) {
    if (progress == null) {
    return child;
    } else {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: ColorUtils.primaryColor(),
        size: 50,
      ),
    ); }
    },
    ),
                              )

                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      
      
      const SizedBox(
        height: 10,
      ),
                Container(height: 15,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                Container(
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Property Services',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(), // Adds space between "Property Services" and "View All"
                        GestureDetector(
                          onTap: () {
                            // Navigate to the next page here
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>const Propertyservices()));
                          },
                          child: Row(
                            children: [
                              Text(
                                "View All ",
                                style: TextStyle(color: ColorUtils.primaryColor()),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorUtils.primaryColor(),
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      
                Container(height: 10,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(height: 1,),
          Container(
           color: Theme.of(context).colorScheme.onPrimary,
            child: Padding(
              padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: propertyTopics.map((topic) {
                    bool isSingleLine = topic["text"].length <= 5; // Adjust the character limit as needed
                    return GestureDetector(
                        onTap: () {
                      _showModalBottomSheet(topic["text"]);
                    },
                    child: SizedBox(
                      width: 100, // Adjust the width as needed
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              backgroundColor: ColorUtils.primaryColor(),
                              radius: 27,
                              child: CircleAvatar(
                                backgroundColor: ColorUtils.primaryColor(), // Example color
                                radius: 27,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white, // Example color
                                  radius: 26,
                                  child: Icon(topic["icon"], size: 25, color: ColorUtils.primaryColor(),), // Adjust icon size and color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4), // Adjust vertical spacing as needed
                          Text(
                            topic["text"],
                            maxLines: isSingleLine ? 1 : 4, // Show single line if text is short, otherwise allow 2 lines
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis, // Use ellipsis if text overflows
                            style: const TextStyle(fontSize: 13,  height: 1.3,),
                          ),
                        ],
                      ),
                    ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      
                Container(height: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
      
      
            const SizedBox(height: 20),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Properties',
                        style: TextStyle(   color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
      
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Featured()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 84.0),
                          child: Text(
                            "View All ",
                            style: TextStyle(   color: ColorUtils.primaryColor(),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Icon(Icons.arrow_forward_ios,      color: ColorUtils.primaryColor(),size: 15,),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:5),
                SizedBox(
                  height: 150, // Adjust height according to your content
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredpropertyId.length,
                    itemBuilder: (context, index) {
                      return _buildPropertyItem(index);
                    },
                  ),
                ),
      
                const SizedBox(height: 25),
      
      
      
                Container( color: Theme.of(context).colorScheme.onPrimary,
                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0,bottom: 25.0,left: 15.0,right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                            spreadRadius: 1, // How far the shadow spreads
                            // Softening effect
                            offset: const Offset(0, 0), // Horizontal and vertical offsets
                          ),
                        ],
                        border: Border.all(
                          color: ColorUtils.primaryColor(), // Set border color to red
                          width: 0.5, // Set border width
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
      
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // Makes the container span the full width of the screen
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.primaryColor(),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0),),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Want to ",
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "Sell/Rent ",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Text(
                                        "your property?",
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    SvgPicture.asset("assets/images/tick.svg"),
                                    const SizedBox(width: 4),
                                    const Text("Publish your property for FREE"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    SvgPicture.asset("assets/images/tick.svg"),
                                    const SizedBox(width: 4),
                                    const Text("Get Verified Tenant / Buyers"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    SvgPicture.asset("assets/images/tick.svg"),
                                    const SizedBox(width: 4),
                                    const Text("Showcase your property Instantly to public"),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Spacer(), // Pushes the button to the right
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const AddPropert()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        shadowColor: Colors.white, // Add shadow color
                                        elevation: 0, // Adjust elevation as needed
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            color: ColorUtils.primaryColor(),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Post your property",
                                            style: TextStyle(
                                              color: ColorUtils.primaryColor(),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                  ),
                ),
      
                const SizedBox(height: 0),
              ],
            ),
      
      
      
      
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(143, 0, 255, 1.0),
          height: 55,
          child: FlashyTabBar(
            backgroundColor: const Color.fromRGBO(143, 0, 255, 1.0).withOpacity(0),
            selectedIndex: _seletedIndex,
            showElevation: true,
            onItemSelected: (index) {
              if (index == 0) {
      
              } else {
                setState(() {
                  _seletedIndex = index;
                  switch (_seletedIndex) {
                    case 0:
                      break;
                    case 1:
                      _navigateToSearchScreen(context);
                      break;
                    case 2:
                      _navigateToWishlistScreen(context);
                      break;
                    case 3:
                      navigateToProfileScreen(context);
      
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



  Widget _buildPropertyItem(int index) {
    List<int> featuredIndices = getFeaturedPropertyIndices();

    // Check if index is out of range for featured properties
    if (index >= featuredIndices.length) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(' '),
        ),
      );
    }

    int featuredIndex = featuredIndices[index];

    String imageUrl = filteredPropertyImages[featuredIndex];
    String videoUrl = filteredPropertyvideo[featuredIndex];
    String category = filteredcategory[featuredIndex];
    String subcategory = filteredsubcategory[featuredIndex];
    String propertyType = filteredpropertyType[featuredIndex];
    String propertyOwner = filteredpropertyOwner[featuredIndex];
    int yearsOld = filteredyearsOld[featuredIndex];
    String furnishingType = filteredfurnishingType[featuredIndex];
    String totalArea = filteredtotalArea[featuredIndex];
    String dimension = filtereddimension[featuredIndex];
    String postuid = filteredpropertyId[featuredIndex];
    String undividedshare = filteredundividedshare[featuredIndex];
    String latitude = filteredlatitude[featuredIndex];
    String longitude = filteredlongtitude[featuredIndex];
    String superbuildup = filteredsuperbuildup[featuredIndex];
    String roadController = filteredroadController[featuredIndex];
    bool isCornerArea = filteredisCornerArea[featuredIndex];
    bool featuredStatus = filteredfeaturedStatus[featuredIndex];
    String propertyId = filteredpropertyId[featuredIndex];

    String possessionType = filteredpossessionType[featuredIndex];
    String areaType = filteredareaType[featuredIndex];
    List<String> propertyFacing = filteredpropertyFacing;
    String floorNumber = filteredfloorNumber[featuredIndex];
    String balcony = filteredbalcony[featuredIndex];
    String bathroom = filteredbathroom[featuredIndex];
    String floorType = filteredfloorType[featuredIndex];
    String doorNo = filtereddoorNo[featuredIndex];
    String addressLine = filteredaddressLine[featuredIndex];
    String area = filteredarea[featuredIndex];
    String locationaddress = filteredlocationaddress[featuredIndex];
    String landmark = filteredlandmark[featuredIndex];
    List<String> amenities = filteredamenities;
    List<Map<String, dynamic>> nearbyPlaces = filterednearbyPlaces;
    bool parkingIncluded = filteredparkingIncluded[featuredIndex];
    String parkingType = filteredparkingType[featuredIndex];
    int carParkingCount = filteredcarParkingCount[featuredIndex];
    int bikeParkingCount = filteredbikeParkingCount[featuredIndex];

    // Check if imageUrl is not empty or null
    if (imageUrl.isEmpty) {
      // Placeholder or fallback image
      imageUrl = 'https://picsum.photos/250?image=9'; // Replace with your fallback image URL
    }
    if (videoUrl.isEmpty) {
      videoUrl = 'No video available'; // You can use a specific placeholder URL or message
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyView(
              imageUrl: imageUrl,
              category: category,
              subcategory: subcategory,
              propertyType: propertyType,
              propertyOwner: propertyOwner,
              yearsOld: yearsOld,
              furnishingType: furnishingType,
              totalArea: totalArea,
              dimension: dimension,
              postuid: postuid,
              undividedshare: undividedshare,
              superbuildup: superbuildup,
              roadController: roadController,
              isCornerArea: isCornerArea,
              featuredStatus: featuredStatus,
              propertyId: propertyId,

              possessionType: possessionType,
              areaType: areaType,
              propertyFacing: propertyFacing,
              floorNumber: floorNumber,
              balcony: balcony,
              bathroom: bathroom,
              floorType: floorType,
              doorNo: doorNo,
              addressLine: addressLine,
              area: area,
              locationaddress: locationaddress,
              landmark: landmark,
              amenities: amenities,
              nearbyPlaces: nearbyPlaces,
              parkingIncluded: parkingIncluded,
              parkingType: parkingType,
              carParkingCount: carParkingCount,
              bikeParkingCount: bikeParkingCount,
              latitude: latitude.toString(), // Convert String to String
              longitude: longitude.toString(),
              videoUrl: [videoUrl],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 0),
        width: 280,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
            bottomLeft: Radius.circular(1),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: Stack(
          children: [
            // Image background
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
            // Black overlay with opacity
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
            Positioned(
              top: 45,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  area,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      category == 'Sell' ? 'buy' : category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 3,),
                    Text(
                      propertyType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   top: 15,
            //   left: 60,
            //   right: 0,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(0),
            //         bottomRight: Radius.circular(15),
            //       ),
            //     ),
            //     child:
            //   ),
            // ),
            // Text
            Positioned(
              bottom: 0,
              left: 190,
              child: SizedBox(
                height: 50,
                width: 90,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/ArrowIcon.svg",
                    width: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
          _animationController.forward();
        },
      ),
      actions: [
        GestureDetector(
        onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen( )));
    },


    child: CircleAvatar(
    maxRadius: 25,
    backgroundColor: Theme.of(context).colorScheme.surface,
    child: Stack(
    children: [
    Icon(
    Icons.notifications_none,
    color: Theme.of(context).colorScheme.primary,
    ),
    Positioned(
    right: 3,
    top: 2,
    child: CircleAvatar(
    maxRadius: 5,
    backgroundColor: Theme.of(context).colorScheme.surface,
    child: CircleAvatar(
    maxRadius: 3,
    backgroundColor:    ColorUtils.primaryColor(),
    ),
    ),
    )
    ],
    ),
    ),

    ),

    const SizedBox(width: 8,),

        // SizedBox(width: 8,),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ColorUtils.primaryColor(),
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: ColorUtils.primaryColor(),
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_userImage),
                    radius: 34,
                    child: _userImage.isEmpty
                        ? Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : 'S',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Text(
                          _usermobile,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home',isBold: true, () {}),
            // _buildDrawerItem(Icons.landscape, 'My Properties', () {
            //   final user = FirebaseAuth.instance.currentUser;
            //   if (user != null) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => PropertyViewScreen(uid: user.uid)),
            //     );
            //   }
            // }),
            _buildDrawerItem(Icons.inventory, 'My Properties', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PropertyInventory()),
              );
            }, isBold: true),
            _buildDrawerItem(Icons.design_services, 'JV Properties', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JVPropertiesForm()),
              );
            }, isBold: true),
            _buildDrawerItem(Icons.real_estate_agent_outlined, 'Property Services', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Propertyservices()),
              );
            }, isBold: true),
            // _buildDrawerItem(Icons.support_agent_outlined, 'Agents Corner', () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Agentcorner()),
            //   );
            // }, isBold: true),
            // _buildDrawerItem(Icons.real_estate_agent_outlined, 'Rental Helicopters', () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Propertyservices()),
            //   );
            // }, isBold: true),
            // _buildDrawerItem(Icons.real_estate_agent_outlined, '5 Star Villas', () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Propertyservices()),
            //   );
            // }, isBold: true),
            // _buildDrawerItem(Icons.real_estate_agent_outlined, 'Event Halls', () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Propertyservices()),
            //   );
            // }, isBold: true),
            // _buildDrawerItem(Icons.real_estate_agent_outlined, 'Daily Rentals', () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Propertyservices()),
            //   );
            // }, isBold: true),

            _buildDrawerItem(Icons.help, 'Help & Support',isBold: true, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportScreen()),
              );
            }),
            _buildDrawerItem(Icons.logout, 'Logout',isBold: true, () {
              _showLogoutBottomSheet(context);
            }),
            const SizedBox(height: 280,),
            Container(
              color: ColorUtils.primaryColor(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to Privacy Policy screen
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Terms & Service screen
                    },
                    child: const Text(
                      'Terms & Services',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
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

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap, {bool isBold = false}) {
    return ListTile(
      leading: Icon(icon,    color: ColorUtils.primaryColor(),),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(   color: ColorUtils.primaryColor(), fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 14),
          ),
          Icon(
            Icons.navigate_next,
            color: customTeal,
          ), // This adds the ">" icon
        ],
      ),
      onTap: onTap,
    );
  }


}


class ImageLoader extends StatefulWidget {
  final String imageUrl;

  const ImageLoader({super.key, required this.imageUrl});

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: _loaded
          ? Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        key: ValueKey(widget.imageUrl),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            // Image is fully loaded
            Future.delayed(Duration.zero, () {
              if (mounted) {
                setState(() {
                  _loaded = true;
                });
              }
            });
            return child;
          } else {
            // Still loading
            return Container(

                child: LoadingAnimationWidget.inkDrop(
                  color: ColorUtils.primaryColor(),
                  size: 50,
                ),

            );
          }
        },
      )
          : Container(
        key: const ValueKey('placeholder'),
        child: Container(
            child: LoadingAnimationWidget.inkDrop(
              color: ColorUtils.primaryColor(),
              size: 50,
            ),

        ),
      ),
    );
  }
}

