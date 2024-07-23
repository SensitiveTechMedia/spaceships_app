import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share/share.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

import 'homeview/propertyview.dart'; // If using Firestore

class Screen extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const Screen({Key? key, required this.onApplyFilters}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<Screen> {
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
      builder: (context) => FilteredResultsScreen(filters: filters),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 12,
                blurRadius: 8,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: ColorUtils.primaryColor(),
            iconTheme: IconThemeData(color: Colors.white),
            titleSpacing: 0,
            title: Text('Filter Page',style: TextStyle(color: Colors.white),),
            actions: [
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
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Category';
                      selectedSubcategory = '';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 35.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Category' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Text('Category', style: TextStyle(fontSize: 14)),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Subcategory';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Subcategory' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Subcategory', style: TextStyle(fontSize: 15))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'PropertyType';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'PropertyType' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Property Type', style: TextStyle(fontSize: 14))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Furnishedstatus';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Furnishedstatus' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Furnished status', style: TextStyle(fontSize: 14))),
                  ),
                ),


                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Direction';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Direction' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Direction', style: TextStyle(fontSize: 14))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Parking';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Parking' ? Colors.purple.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Parking', style: TextStyle(fontSize: 14))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                Expanded(child: SizedBox()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Apply Filters', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Border radius of 5
                        ),
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ),

          VerticalDivider(thickness: 1),
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
                  child: Text('Clear Filters', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Border radius of 5
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
      return Center(child: Text('Select the required'));
    }
  }

  Widget _buildCategorySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30,),
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
              SizedBox(width: 8),
              Text('Buy', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        SizedBox(height: 5),
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
              SizedBox(width: 8),
              Text('Rent', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        SizedBox(height: 5),
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
              SizedBox(width: 8),
              Text('Lease', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildSubcategorySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30), // Add space at the top
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
                    SizedBox(width: 8),
                    Text(subcategory, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ],
    );
  }



  Widget _buildPropertyTypeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30), // Add space at the top
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
                    SizedBox(width: 8),
                    Text(propertyType, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ],
    );
  }


  Widget _buildFurnishedStatusSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30,),
        _buildFurnishedStatusOption('Furnished'),
        SizedBox(height: 5),
        Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
        _buildFurnishedStatusOption('Unfurnished'),
        SizedBox(height: 5),
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
          SizedBox(width: 8),
          Text(status, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }



  Widget _buildDirectionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30), // Add space at the top
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
                    SizedBox(width: 8),
                    Text(direction, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ],
    );
  }


  Widget _buildParkingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30), // Add space at the top
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
                    SizedBox(width: 8),
                    Text(option, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ],
    );
  }

}

class FilteredResultsScreen extends StatelessWidget {
  final Map<String, dynamic> filters;
  const FilteredResultsScreen({Key? key, required this.filters}) : super(key: key);
  Future<List<Map<String, dynamic>>> fetchFilteredData(Map<String, dynamic> filters) async {
    print("Fetching filtered data with filters: $filters");

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('propert').get();
    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    List<Map<String, dynamic>> filteredData = [];

    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Checking document: ${doc.id} with data: $data");

      bool matchesFilter = false; // Start with false

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
        List<dynamic> docFacingDirections = data['propertyFacing'] as List<dynamic>;
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
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 12,
                blurRadius: 8,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: ColorUtils.primaryColor(),
            iconTheme: IconThemeData(color: Colors.white),
            titleSpacing: 0,
            title: Text('Filter Properties',style: TextStyle(color: Colors.white),),
            actions: [
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFilteredData(filters),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final filteredData = snapshot.data ?? [];

          if (filteredData.isEmpty) {
            return Center(child: Text('No properties found.'));
          }

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final property = filteredData[index];
              print("Displaying property: $property");
              String propertyId = 'property$index';
              return ListTile(

                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                onTap: () {
                  // Inside the ListTile's onTap

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Whislits(propertyId: property['propertyId'] ?? 'unknown'),
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
                              image: property['PropertyImages'] != null && property['PropertyImages']!.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(property['PropertyImages']![0]),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: property['PropertyImages'] == null || property['PropertyImages']!.isEmpty
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
                                  property['propertyType'],
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
                                property['propertyType'] ?? 'No Title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtils.primaryColor(),
                                  fontSize: 24,
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

                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ],
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

