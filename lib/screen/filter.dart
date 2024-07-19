import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const Screen({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

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
  List<String> selectedAmenities = [];
  List<String> selectedParking = [];
  String selectedDirection = '';
  final List<String> amenities = [
    'Swimming Pool', 'Gym', 'Garden', 'Lift', 'Air Conditioner', 'Intercom',
    'Child Play Area', 'Gas Pipeline', 'Servant Room', 'Rainwater Harvesting',
    'House Keeping', 'Visitor Parking', 'Internet Service', 'Club House',
    'Fire Safety', 'Shopping Center', 'Park', 'Sewage Treatment', 'Power Backup', 'Water Storage',
  ];

  final List<String> directions = ['North', 'South', 'East', 'West'];

  final List<String> parkingOptions = ['Open Parking', 'Closed Parking'];

  final List<String> subcategories = [
    'Flat', 'Villa / Independent House', 'Plot / Land', 'Commercial Space', 'Hostel/PG/Service Apartment',
  ];

  final List<String> propertyTypes = [
    'Individual Plot',
    'Agricultural Land',
    'Independent Villa',
    'Gated Community Villa',
    'Gated Community Plot',
    'Commercial Shop',
    'Independent Floor',
    "Shared Floor",
    "Independent Building",
    "Hostel",
    "PG",
    "Service Apartment",
  ];

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
      selectedAmenities.clear();
      selectedDirection = '';
      selectedParking.clear();
    });
    widget.onApplyFilters({
      'propertyTypes': [],
      'propertyCategories': [],
      'amenities': [],
      'facingDirections': [],
      'furnishedStatuses': [],
      'parkingOptions': [],
    });
  }

  void _applyFilters() {
    Map<String, dynamic> filters = {
      'propertyCategories': selectedOption == 'Category' ? [buySelected ? 'Buy' : rentSelected ? 'Rent' : leaseSelected ? 'Lease' : ''] : [],
      'propertyTypes': selectedPropertyType.isNotEmpty ? [selectedPropertyType] : [],
      'amenities': selectedAmenities,
      'furnishedStatuses': furnishedStatusSelected,
      'facingDirections': [directions],
      'parkingOptions': selectedParking,
    };
    widget.onApplyFilters(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Page'),
      ),
      body: Row(
        children: <Widget>[
          // Left side with grey background
          Container(
            color: Colors.grey.shade300,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
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
                      color: selectedOption == 'Category' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Text('Category', style: TextStyle(fontSize: 17)),
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
                      color: selectedOption == 'Subcategory' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Subcategory', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Property Type';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Property Type' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Property Type', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Furnished status';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Furnished status' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Furnished status', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Amenities';
                      selectedPropertyType = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Amenities' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Amenities', style: TextStyle(fontSize: 17))),
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
                      color: selectedOption == 'Direction' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Direction', style: TextStyle(fontSize: 17))),
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
                      color: selectedOption == 'Parking' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Parking', style: TextStyle(fontSize: 17))),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                    ),
                    ElevatedButton(
                      onPressed: _clearFilters,
                      child: Text('Clear Filters', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1),
          // Right side with white background
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildRightSection(),
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
    } else if (selectedOption == 'Property Type') {
      return _buildPropertyTypeSection();
    } else if (selectedOption == 'Furnished status') {
      return _buildFurnishedStatusSection();
    } else if (selectedOption == 'Amenities') {
      return _buildAmenitiesSection();
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
              Text('Buy', style: TextStyle(fontSize: 16)),
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
              Text('Rent', style: TextStyle(fontSize: 16)),
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
              Text('Lease', style: TextStyle(fontSize: 16)),
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
      children: subcategories.map((subcategory) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSubcategory = subcategory;
            });
          },
          child: Row(
            children: [
              Icon(selectedSubcategory == subcategory ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(subcategory, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPropertyTypeSection() {
    // Return property types based on the selected subcategory if needed
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: propertyTypes.map((propertyType) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPropertyType = propertyType;
            });
          },
          child: Row(
            children: [
              Icon(selectedPropertyType == propertyType ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(propertyType, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFurnishedStatusSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
          Text(status, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: amenities.map((amenity) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedAmenities.contains(amenity)) {
                selectedAmenities.remove(amenity);
              } else {
                selectedAmenities.add(amenity);
              }
            });
          },
          child: Row(
            children: [
              Icon(selectedAmenities.contains(amenity) ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(amenity, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDirectionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: directions.map((direction) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDirection = direction;
            });
          },
          child: Row(
            children: [
              Icon(selectedDirection == direction ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(direction, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParkingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: parkingOptions.map((option) {
        return GestureDetector(
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
              Icon(selectedParking.contains(option) ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(option, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
