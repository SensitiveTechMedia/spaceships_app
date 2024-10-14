import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/homeview/propertyview.dart';


class Tune extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const Tune({super.key, required this.onApplyFilters});

  @override
  _TuneScreenState createState() => _TuneScreenState();
}

class _TuneScreenState extends State<Tune> {
  String selectedOption = '';
  String selectedSubcategory = '';
  String selectedPropertyType = '';
  bool buySelected = false;
  bool rentSelected = false;
  bool leaseSelected = false;
  List<String> propertyTypeSelected = [];
  List<String> furnishedStatusSelected = [];

  List<String> selectedParking = [];
  String selectedDirection = '';
  final List<String> directions = ['North', 'South', 'East', 'West'];
  final List<String> parkingOptions = ['Open Parking', 'Closed Parking'];
  final List<String> subcategories = ['Flat', 'Villa/Independent House', 'Plot/Land', 'Commercial Space', 'Hostel/PG/Service Apartment'];
  final List<String> propertyTypes = ['Individual Plot', 'Agricultural Land', 'Independent Villa', 'Gated Community Villa', 'Gated Community Plot', 'Commercial Shop', 'Independent Floor', "Shared Floor", "Independent Building", "Hostel", "PG", "Service Apartment"];
  void _clearFilters() {
    setState(() {
      buySelected = false;
      rentSelected = false;
      leaseSelected = false;
      selectedOption = '';
      selectedSubcategory = '';
      selectedPropertyType = '';
      propertyTypeSelected.clear();
      furnishedStatusSelected.clear();
      selectedDirection = '';
      selectedParking.clear();
    });
    widget.onApplyFilters({
      'propertyTypes': [],
      'subcategory' :[],
      'propertyCategories': [],
      'facingDirections': [],
      'furnishedStatuses': [],
      'parkingOptions': [],
    });
  }
  void _applyFilters() {
    Map<String, dynamic> filters = {
      'propertyCategories': selectedOption == 'Category'
          ? [buySelected ? 'Buy' : rentSelected ? 'Rent' : leaseSelected ? 'Lease' : '']
          : [],
      'subcategory': selectedSubcategory.isNotEmpty ? [selectedSubcategory] : [],
      'propertyTypes': selectedPropertyType.isNotEmpty ? [selectedPropertyType] : [],
      'furnishedStatuses': furnishedStatusSelected,
      'facingDirections': [selectedDirection],
      'parkingOptions': selectedParking,
    };
    widget.onApplyFilters(filters);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TuneResultsScreen(filters: filters),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 12,
                blurRadius: 8,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: ColorUtils.primaryColor(),
            iconTheme: const IconThemeData(color: Colors.white),
            titleSpacing: 0,
            title: const Text('Filter Page',style: TextStyle(color: Colors.white),),
            actions: const [
            ],
          ),
        ),
      ),
      body: Row(
        children: <Widget>[

          // Left side with grey background
          Container(
            color: Colors.grey.shade300,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Category';
                      selectedSubcategory = '';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Category' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Text('Category', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Subcategory';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Subcategory' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Center(child: Text('Subcategory', style: TextStyle(fontSize: 15))),
                  ),
                ),
                const VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'PropertyType';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'PropertyType' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Center(child: Text('Property Type', style: TextStyle(fontSize: 14))),
                  ),
                ),
                const VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Furnishedstatus';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Furnishedstatus' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Center(child: Text('Furnished status', style: TextStyle(fontSize: 14))),
                  ),
                ),


                const VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Direction';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Direction' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Center(child: Text('Direction', style: TextStyle(fontSize: 14))),
                  ),
                ),
                const VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Parking';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Parking' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: const Center(child: Text('Parking', style: TextStyle(fontSize: 14))),
                  ),
                ),
                const VerticalDivider(thickness: 5),
                const Expanded(child: SizedBox()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Border radius of 5
                        ),
                      ),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                    ),

                  ],
                ),
              ],
            ),
          ),

          const VerticalDivider(thickness: 1),
          // Right side with white background

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: _buildRightSection(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Border radius of 5
                    ),
                  ),
                  child: const Text('Clear Filters', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildRightSection() {
    if (selectedOption == 'Category') {
      return _buildCategorySection();
    } else if (selectedOption == 'Subcategory') {
      return _buildSubcategorySection();
    } else if (selectedOption == 'PropertyType') {
      return _buildPropertyTypeSection();
    } else if (selectedOption == 'Furnishedstatus') {
      return _buildFurnishedStatusSection();
    } else if (selectedOption == 'Direction') {
      return _buildDirectionSection();
    } else if (selectedOption == 'Parking') {
      return _buildParkingSection();
    } else {
      return const Center(child: Text('Select the required'));
    }
  }

  Widget _buildCategorySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30,),
        GestureDetector(
          onTap: () {
            setState(() {
              buySelected = !buySelected;
              if (buySelected) {
                rentSelected = false;
                leaseSelected = false;
              }
            });
          },
          child: Row(
            children: [
              Icon(buySelected ? Icons.check_box : Icons.check_box_outline_blank),
              const SizedBox(width: 8),
              const Text('Buy', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              rentSelected = !rentSelected;
              if (rentSelected) {
                buySelected = false;
                leaseSelected = false;
              }
            });
          },
          child: Row(
            children: [
              Icon(rentSelected ? Icons.check_box : Icons.check_box_outline_blank),
              const SizedBox(width: 8),
              const Text('Rent', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              leaseSelected = !leaseSelected;
              if (leaseSelected) {
                buySelected = false;
                rentSelected = false;
              }
            });
          },
          child: Row(
            children: [
              Icon(leaseSelected ? Icons.check_box : Icons.check_box_outline_blank),
              const SizedBox(width: 8),
              const Text('Lease', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildSubcategorySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20), // Add space at the top
        ...subcategories.map((subcategory) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSubcategory = subcategory;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      selectedSubcategory == subcategory
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    const SizedBox(width: 8),
                    Text(subcategory, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }),
      ],
    );
  }



  Widget _buildPropertyTypeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20), // Add space at the top
        ...propertyTypes.map((propertyType) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPropertyType = propertyType;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      selectedPropertyType == propertyType
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    const SizedBox(width: 8),
                    Text(propertyType, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }),
      ],
    );
  }


  Widget _buildFurnishedStatusSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30,),
        _buildFurnishedStatusOption('Furnished'),
        const SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        _buildFurnishedStatusOption('Unfurnished'),
        const SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        _buildFurnishedStatusOption('Semi-furnished'),
      ],
    );
  }

  Widget _buildFurnishedStatusOption(String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (furnishedStatusSelected.contains(status)) {
            furnishedStatusSelected.remove(status);
          } else {
            furnishedStatusSelected = [status];
          }
        });
      },
      child: Row(
        children: [
          Icon(furnishedStatusSelected.contains(status) ? Icons.check_box : Icons.check_box_outline_blank),
          const SizedBox(width: 8),
          Text(status, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }



  Widget _buildDirectionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20), // Add space at the top
        ...directions.map((direction) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDirection = direction;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      selectedDirection == direction
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    const SizedBox(width: 8),
                    Text(direction, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }),
      ],
    );
  }


  Widget _buildParkingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20), // Add space at the top
        ...parkingOptions.map((option) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedParking.contains(option)) {
                      selectedParking.remove(option);
                    } else {
                      selectedParking.add(option);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      selectedParking.contains(option)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    const SizedBox(width: 8),
                    Text(option, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }),
      ],
    );
  }

}

class TuneResultsScreen extends StatelessWidget {
  final Map<String, dynamic> filters;

  const TuneResultsScreen({super.key, required this.filters});

  Future<List<Map<String, dynamic>>> fetchFilteredData(Map<String, dynamic> filters) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }
    final userId = user.uid;

    print("Fetching filtered data with filters: $filters");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .get();

    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    List<Map<String, dynamic>> filteredData = [];

    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Checking document: ${doc.id} with data: $data");

      bool matchesFilter = false;

      if (filters['propertyTypes'] != null && filters['propertyTypes'].isNotEmpty) {
        matchesFilter |= filters['propertyTypes'].contains(data['propertyType']);
      }
      if (filters['subcategory'] != null && filters['subcategory'].isNotEmpty) {
        matchesFilter |= filters['subcategory'].contains(data['subcategory']);
      }
      if (filters['propertyCategories'] != null && filters['propertyCategories'].isNotEmpty) {
        matchesFilter |= filters['propertyCategories'].contains(data['category']);
      }
      if (filters['furnishedStatuses'] != null && filters['furnishedStatuses'].isNotEmpty) {
        matchesFilter |= filters['furnishedStatuses'].contains(data['furnishingType']);
      }
      if (filters['facingDirections'] != null && filters['facingDirections'].isNotEmpty) {
        List<dynamic> docFacingDirections = data['propertyFacing'] as List<dynamic>? ?? [];
        matchesFilter |= (filters['facingDirections'] as List<String>).any((direction) => docFacingDirections.contains(direction));
      }
      if (filters['parkingOptions'] != null && filters['parkingOptions'].isNotEmpty) {
        matchesFilter |= filters['parkingOptions'].contains(data['parkingType']);
      }

      print("Document matches filter: $matchesFilter");
      if (matchesFilter) {
        filteredData.add(data);
      }
    }

    print("Filtered data: $filteredData");
    return filteredData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 12,
                blurRadius: 8,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: ColorUtils.primaryColor(),
            iconTheme: const IconThemeData(color: Colors.white),
            titleSpacing: 0,
            title: const Text('Filter Properties', style: TextStyle(color: Colors.white)),
            actions: const [],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFilteredData(filters),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final filteredData = snapshot.data ?? [];

          if (filteredData.isEmpty) {
            return const Center(child: Text('No properties found.'));
          }

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final property = filteredData[index];
              print("Displaying property: $property");
              String propertyId = property['propertyId'] ?? 'unknown';
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Tuneview(propertyId: property['propertyId'] ?? 'unknown'),
                    ),
                  );
                },
                title: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(160, 161, 164, 1000), // Corrected color opacity
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
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey,
                                image: (property['imageUrl'] != null && property['imageUrl'] != "")
                                    ? DecorationImage(
                                  image: NetworkImage(property['imageUrl']!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: (property['imageUrl'] == null || property['imageUrl'] == "")
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
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(143, 0, 255, 0.55),
                                ),
                                child: Center(
                                  child: Text(
                                    property['propertyType'],
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  property['propertyType'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primaryColor(),
                                    fontSize: 24,
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
                                      property['addressLine'] ?? 'No Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.primaryColor(),
                                        fontSize: 15,
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
      ),
    );
  }
}




class Tuneview extends StatefulWidget {
  final String propertyId;
  Color customTeal = const Color(0xFF8F00FF);
  Tuneview({super.key, 
    required this.propertyId,
  });
  @override
  _TuneviewState createState() => _TuneviewState();
}
class _TuneviewState extends State<Tuneview> {
  late Future<Map<String, dynamic>> propertyFuture;
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
    propertyFuture = fetchProperty();
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
  Future<Map<String, dynamic>> fetchProperty() async {
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
        future: propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No property data found.'));
          } else {
            Map<String, dynamic> property = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      if (property['PropertyImages'] != null && property['PropertyImages'].isNotEmpty)
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
                                    itemCount: property['PropertyImages'].length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        property['PropertyImages'][index],
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
                                  " ${property['category']}",
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
                                  " ${property['subcategory']}", // Conditionally change text here
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
                                  " ${property['propertyType']}", // Conditionally change text here
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
                                '${_currentImageIndex + 1} / ${property['PropertyImages'].length}',
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
                              " ${property['propertyOwner']}",
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
                                " ${property['addressLine']}",
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
                                        " ${property['balcony'] } balcony",
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
                                        " ${property['bathroom']} bathroom",
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
                                    double.tryParse(property['latitude'] ?? '0.0') ?? 0.0,
                                    double.tryParse(property['longitude'] ?? '0.0') ?? 0.0,
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
                                      double.tryParse(property['latitude'] ?? '0.0') ?? 0.0,
                                      double.tryParse(property['longitude'] ?? '0.0') ?? 0.0,
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
                                        "${property['yearsOld']} year old",
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
                                        " ${property['dimension']} ",
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
                                        " ${property['undividedshare']}  undivided share",
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
                                        "${property['totalArea']}  ${property['areaType']}",
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
                                        "${property['furnishingType']}",
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
                                        "${property['superbuildup']}",
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
                                        " ${property['roadController']}",
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
                                        property['parkingIncluded'] ? 'Included' : 'Not Included',
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
                                        "${property['parkingType']}",
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
                                        "${property['carparking']}",
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
                                        "${property['bikeParkingCount']}",
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
                                      Text("  ${property['possessionType']}",

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

                                      Text(" ${property['floorNumber']}",
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
                                      Text(" ${property['floorType']}",
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
                                    Text(" ${property['doorNo']}",
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
                                    Text(" ${property['addressLine']}",
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
                                    Text(" ${property['area']}",
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
                                    Text(" ${property['locationaddress']}",
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
                                    Text(" ${property['landmark']}",
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
                      ...property['nearbyPlaces'].map<Widget>((place) {
                        return Text("${place['place']} (${place['distance']} km)");
                      }).toList(),
                      const Text("Payment Rows:"),
                      ...property['paymentRows'].map<Widget>((payment) {
                        return Text("${payment['category']}: ${payment['amount']} (${payment['type']})");
                      }).toList(),

                      //
                      // ...property['videos'].map<Widget>((video) {
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
//
