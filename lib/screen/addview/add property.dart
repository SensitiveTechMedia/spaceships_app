import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaceships/colorcode.dart';
import 'map.dart';
class AddPropert extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<AddPropert> with TickerProviderStateMixin {
  Color customTeal = Color(0xFF8F00FF);
  List<String> cate = ["Sell", "Rent", "Lease"];

  int _selectedIndex = 0;
  void _navigateToCategory(String category) {
    if (context != null) {
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category,),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor:  ColorUtils.primaryColor(), // Example app bar background color
            title: Text(
              "Post FREE Property Ad",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How do you want to post this property?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(cate.length, (index) {
                    bool isSelected = _selectedIndex == index;
                    return CategoryItem(
                      title: cate[index],
                      icon: index == 0
                          ? Icons.all_inbox
                          : index == 1
                          ? Icons.home
                          : Icons.apartment,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        _navigateToCategory(cate[index]);
                      },
                      customTeal: customTeal,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category, });
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen> {
  Color customTeal = Color(0xFF8F00FF);
  int _selectedSubcategoryIndex = -1;
  String _selectedPropertyType = "";
  int bhkValue = 1;
  TextEditingController propertyTypeController = TextEditingController();
  Map<String, List<String>> propertyTypes = {
    "Flat": ["Property Type"],
    "Villa / Independent House": ["Independent Villa", "Gated Community Villa"],
    "Plot / Land": ["Individual Plot", "Gated Community Plot", "Agriculture Land"],
    "Commercial Space":["Commercial Shop","Independent Floor", "Shared Floor", "Independent Building",],
    "Hostel/PG/Service Apartment": ["Hostel","PG","Service Apartment", ],
  };
  List<Map<String, dynamic>> subcategories = [];

  @override
  void initState() {
    super.initState();
    switch (widget.category) {
      case "Sell":
      case "Rent":
      case "Lease":
        subcategories = [
          {"name": "Flat", "icon": Icons.apartment,},
          {"name": "Villa / Independent House","icon": Icons.villa,},
          {"name": "Plot / Land","icon": Icons.all_inbox},
          {"name": "Commercial Space","icon":Icons.woo_commerce},
          {"name": "Hostel/PG/Service Apartment","icon": Icons.hotel_sharp},
        ];
        break;
      default:
        subcategories = [];
    }
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
            title: Text('${widget.category} Category', style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Select a subcategory:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 420,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedSubcategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSubcategoryIndex = index;
                          _selectedPropertyType = ""; // Reset property type selection
                          propertyTypeController.clear(); // Clear property type input when subcategory changes
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected ? customTeal : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorUtils.primaryColor()),
                        ),
                        child: Row(
                          children: [
                            if (subcategories[index]["icon"] != null)
                              Icon(
                                subcategories[index]["icon"],
                                color: isSelected ? Colors.white : customTeal,
                              ),
                            if (subcategories[index]["icon"] != null)
                              SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                subcategories[index]["name"],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : customTeal,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (_selectedSubcategoryIndex != -1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subcategories[_selectedSubcategoryIndex]["name"] == "Villa / Independent House" ||
                        subcategories[_selectedSubcategoryIndex]["name"] == "Flat")
                      Text(
                        'Enter BHK Value:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorUtils.primaryColor(),
                        ),
                      ),
                    if (subcategories[_selectedSubcategoryIndex]["name"] == "Villa / Independent House" ||
                        subcategories[_selectedSubcategoryIndex]["name"] == "Flat")
                      SizedBox(height: 10),
                    if (subcategories[_selectedSubcategoryIndex]["name"] == "Villa / Independent House" ||
                        subcategories[_selectedSubcategoryIndex]["name"] == "Flat")
                      Row(
                        children: [
                          Container(
                            width: 36, // Adjust width to change circle size
                            height: 39, // Adjust height to change circle size
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorUtils.primaryColor(), // Background color of the circle
                            ),
                            child: IconButton(
                              icon: Icon(Icons.remove, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  if (bhkValue > 1) bhkValue--; // Decrease value, minimum 1
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$bhkValue BHK',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.primaryColor(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 36, // Adjust width to change circle size
                            height: 39, // Adjust height to change circle size
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorUtils.primaryColor(), // Background color of the circle
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white), // Icon with custom teal color
                              onPressed: () {
                                setState(() {
                                  bhkValue++; // Increase value
                                });
                              },
                              padding: EdgeInsets.all(0), // Optional: Remove default padding
                              iconSize: 24, // Adjust icon size if needed
                            ),
                          ),
                        ],
                      ),
                    if (subcategories[_selectedSubcategoryIndex]["name"] == "Villa / Independent House")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Select Property Type:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.primaryColor(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              propertyTypes["Villa / Independent House"]!.length,
                                  (index) {
                                bool isSelected = _selectedPropertyType == propertyTypes["Villa / Independent House"]![index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPropertyType = propertyTypes["Villa / Independent House"]![index];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? customTeal : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: ColorUtils.primaryColor()),
                                    ),
                                    child: Text(
                                      propertyTypes["Villa / Independent House"]![index],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : customTeal,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              if (_selectedSubcategoryIndex != -1 &&
                  subcategories[_selectedSubcategoryIndex]["name"] != "Flat" &&
                  subcategories[_selectedSubcategoryIndex]["name"] != "Villa / Independent House")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Property Type:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        propertyTypes[subcategories[_selectedSubcategoryIndex]["name"]]!.length,
                            (index) {
                          bool isSelected = _selectedPropertyType == propertyTypes[subcategories[_selectedSubcategoryIndex]["name"]]![index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPropertyType = propertyTypes[subcategories[_selectedSubcategoryIndex]["name"]]![index];
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? customTeal : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorUtils.primaryColor()),
                              ),
                              child: Text(
                                propertyTypes[subcategories[_selectedSubcategoryIndex]["name"]]![index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : customTeal,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        color: ColorUtils.primaryColor(),
                      ),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Back",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1), // Adjust the spacing between the buttons as needed
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                        color: ColorUtils.primaryColor(),
                      ),
                      child: SizedBox(
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedSubcategoryIndex == -1) {
                              _showToast("Please select a subcategory.");
                            } else {
                              String selectedSubcategory = subcategories[_selectedSubcategoryIndex]["name"];
                              String selectedPropertyType = "";

                              if (selectedSubcategory == "Flat" || selectedSubcategory == "Villa / Independent House") {
                                selectedPropertyType = '$bhkValue BHK';
                                if (selectedSubcategory == "Villa / Independent House") {
                                  String propertyType = _selectedPropertyType.isNotEmpty
                                      ? _selectedPropertyType
                                      : "Select Property Type";
                                  selectedPropertyType = '$propertyType, $selectedPropertyType'; // Combine property type and BHK value
                                }
                              } else {
                                selectedPropertyType = _selectedPropertyType.isNotEmpty
                                    ? _selectedPropertyType
                                    : "Select Property Type";
                              }

                              if (selectedPropertyType == "Select Property Type" && selectedSubcategory != "Flat" && selectedSubcategory != "Villa / Independent House") {
                                _showToast("Please select a property type.");
                              } else {
                                print("Selected Subcategory: $selectedSubcategory, Property Type: $selectedPropertyType");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PropertyDetailsScreen(
                                      category: widget.category,
                                      subcategory: selectedSubcategory,
                                      propertyType: selectedPropertyType,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    propertyTypeController.dispose();
    super.dispose();
  }
}
class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color customTeal;
  CategoryItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.customTeal,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? customTeal : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ColorUtils.primaryColor(),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : customTeal,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white : customTeal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PropertyDetailsScreen extends StatefulWidget {
  final String category;
  final String subcategory;
  final String propertyType;
  final int? bhkValue;
  PropertyDetailsScreen({
    required this.category,
    required this.subcategory,
    required this.propertyType,
    this.bhkValue,
  });
  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}
class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  TextEditingController propertyOwnerController = TextEditingController();
  TextEditingController possesiontypeController = TextEditingController();
  TextEditingController furnishingTypeController = TextEditingController();
  TextEditingController totalAreaController = TextEditingController();
  TextEditingController  dimensionController = TextEditingController();
TextEditingController roadController=TextEditingController();
TextEditingController undividedController =TextEditingController();
TextEditingController superbuildupController=TextEditingController();
  final TextEditingController balconyController=TextEditingController();
  final  TextEditingController bathroomController=TextEditingController();
  final TextEditingController amountController = TextEditingController();
  Color customTeal = Color(0xFF8F00FF);
  String paymentType = "One-Time";
  String possessionType = "Under Construction";
  String areaType = 'Sq.Ft'; // Initial value
  int yearsOld = 0;
  bool isCornerArea = false;
  bool freshproperty = true;

  List<String> areaTypes = ['Sq.Ft', 'Acre', 'Cents', 'Guntha']; // List of types
  List<String> propertyFacing = [];
  List<String> paymentTypes = ["One-Time", "Monthly", "Yearly"];
  List<String> propertyFacings = ["North", "South", "East", "West"];
  List<String> possessionTypes = ["Under Construction", "Ready-to-Move"];
  List<String> furnishingTypes = ["Semi-Furnished", "Unfurnished", "Fully Furnished"];
  List<String> categoryOptions = ["Rent", "Deposit", "Maintenance", "Others"];
  List<String> typeOptions = ["One-Time", "Monthly", "Others"];
  List<PaymentRow> paymentRows = [];

  @override
  void initState() {
    super.initState();
    paymentRows.add(PaymentRow(categoryOptions, typeOptions));
  }
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void addPaymentRow() {
    setState(() {
      paymentRows.add(PaymentRow(categoryOptions, typeOptions));
    });
  }

  void removePaymentRow(int index) {
    setState(() {
      paymentRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showBalconyAndBathroom = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Commercial Space'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool facingdata = !(widget.subcategory == 'Hostel/PG/Service Apartment');
    // bool possiontype = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Hostel/PG/Service Apartment');
    bool yearsolddata = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Hostel/PG/Service Apartment');
    bool possesion = !(widget.subcategory == 'Plot / Land'|| widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool cornerarea = !(widget.subcategory == 'Flat'|| widget.subcategory == 'Villa / Independent House'|| widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool totalarea = !( widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool undividedshare  = !( widget.subcategory == 'Villa / Independent House'||widget.subcategory == 'Plot / Land'|| widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool superbuild = !( widget.subcategory == 'Villa / Independent House'|| widget.subcategory == 'Commercial Space'|| widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment'|| widget.subcategory == 'Plot / Land');
    bool dimensionroad  = !(widget.subcategory == 'Flat'|| widget.category == 'Rent' || widget.category == 'Lease'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    bool furnishing = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Commercial Space'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    Future<void> _showToastsOneByOne(List<String> messages) async {
      for (String message in messages) {
        _showToast(message); // Show the toast message
        await Future.delayed(Duration(seconds: 1)); // Wait for 1 second (or adjust as needed)
      }
    }

    bool _validateFields() {
      List<String> missingFields = [];

      // Check if property owner or consultant is selected
      if (propertyOwnerController.text.isEmpty) {
        missingFields.add("Property Owner or Consultant");
      }

      // Check required fields based on category and subcategory
      if (widget.subcategory == 'Flat' || widget.subcategory == 'Villa / Independent House') {
        if (balconyController.text.isEmpty) {
          missingFields.add("Please enter the Number of Balconies");
        }
        if (bathroomController.text.isEmpty) {
          missingFields.add("Please enter the Number of Bathrooms");
        }
      }

      if (widget.subcategory == 'Flat' || widget.subcategory == 'Commercial Space' || widget.subcategory == 'Villa / Independent House') {
        if (freshproperty == true) {
          // Don't ask for years old data
        } else {
          if (yearsOld <= 0) { // Assuming you want to check for non-positive values
            missingFields.add("Years Old (must be greater than 0)");
          }
        }
      }


      if (widget.subcategory == 'Flat' || widget.subcategory == 'Villa / Independent House' || widget.subcategory == 'Commercial Space' || widget.subcategory == 'Plot / Land') {
        if (propertyFacing.isEmpty) {
          missingFields.add("Please Select Property Facing");
        }
      }

      if (widget.subcategory == 'Flat' || widget.subcategory == 'Commercial Space' || widget.subcategory == 'Villa / Independent House') {
        if (widget.category == 'Sell' && possesiontypeController.text.isEmpty) {
          missingFields.add("Please select Possession Type");
        }
      }

      if (widget.subcategory == 'Flat' || widget.subcategory == 'Villa / Independent House') {
        if (furnishingTypeController.text.isEmpty) {
          missingFields.add("Please select Furnishing Type");
        }
      }

      if (widget.subcategory == 'Commercial Space' || widget.subcategory == 'Plot / Land') {
        if (isCornerArea == null) { // Assuming a radio button or similar control
          missingFields.add("Please select Is this a Corner Area?");
        }
      }
      if (widget.subcategory == 'Flat' ||
          widget.subcategory == 'Villa / Independent House' ||
          widget.subcategory == 'Commercial Space' ||
          widget.subcategory == 'Plot / Land') {
        if (widget.category == 'Sell' && totalAreaController.text.isEmpty) {
          missingFields.add("Please enter the Total Area");
        }
      }

      if (widget.subcategory == 'Villa / Independent House' || widget.subcategory == 'Commercial Space' || widget.subcategory == 'Plot / Land') {
        if (widget.category == 'Sell' && dimensionController.text.isEmpty) {
          missingFields.add("Dimension");
        }

        // Check road length
        if (widget.category == 'Sell' && roadController.text.isEmpty) {
          missingFields.add("Road Length");
        }
      }

      if (widget.subcategory == 'Flat' || widget.subcategory == 'Flat') {
        if (widget.category == 'Sell' && superbuildupController.text.isEmpty) {
          missingFields.add("Please enter Superbuildup Area");
        }
      }

      if (widget.subcategory == 'Commercial Space' || widget.subcategory == 'Flat') {
        if (widget.category == 'Sell' && undividedController.text.isEmpty) {
          missingFields.add("Please enter Undivided Share");
        }
      }

      if (paymentRows.isEmpty) {
        missingFields.add("Please enter Payment Type");
      }

      if (paymentTypes.isEmpty) {
        missingFields.add("Please select Payment Type");
      }
      if (amountController.text.isEmpty) {
        missingFields.add("Please Add payment details");
      }
      if (missingFields.isNotEmpty) {
        _showToastsOneByOne(missingFields);
        return false; // Validation failed
      }

      return true; // All validations passed
    }




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
        title: Text('Property Details',style: TextStyle(color: Colors.white),),
      ),
    )
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I am a :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: propertyOwnerController.text == 'Property Owner'
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ColorUtils.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          propertyOwnerController.text = 'Property Owner';
                        });
                      },
                      child: Text(
                        'Property Owner',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                        : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorUtils.primaryColor(),
                        side: BorderSide(color: ColorUtils.primaryColor(),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          propertyOwnerController.text = 'Property Owner';
                        });
                      },
                      child: Text(
                        'Property Owner',
                        style: TextStyle(fontSize: 16, color: ColorUtils.primaryColor(),),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2), // Add spacing between ElevatedButtons
                Expanded(
                  child: Container(
                    child: propertyOwnerController.text == 'Consultant'
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ColorUtils.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          propertyOwnerController.text = 'Consultant';
                        });
                      },
                      child: Text(
                        'Consultant',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                        : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorUtils.primaryColor(),
                        side: BorderSide(color: ColorUtils.primaryColor(),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          propertyOwnerController.text = 'Consultant';
                        });
                      },
                      child: Text(
                        'Consultant',
                        style: TextStyle(fontSize: 16, color: ColorUtils.primaryColor(),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (showBalconyAndBathroom) ...[
              TextField(
                keyboardType: TextInputType.number,
                controller: balconyController,
                decoration: InputDecoration(labelText: "Enter number of Balcony",
                  hintText: 'Enter number of Balcony',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: bathroomController,
                decoration: InputDecoration(labelText: "Enter number of bathroom",
                  hintText: 'Enter  number of bathroom',
                  border: UnderlineInputBorder(),
                ),
              ),
              ],
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Payment Types :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor(),
                      ),
                    ),
                  ),
                  Container(
                    // Adjust width to change rectangle size
                    height: 35, // Adjust height to change rectangle size
                    decoration: BoxDecoration(
                      color: Colors.green, // Background color
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),topRight: Radius.circular(5)), // Adjust border radius as needed
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white), // Icon with white color
                      onPressed: addPaymentRow, // Function to call when pressed
                      padding: EdgeInsets.all(0), // Optional: Remove default padding
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  for (int i = 0; i < paymentRows.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: 150, // Adjust width as needed
                              child: DropdownButtonFormField<String>(
                                value: paymentRows[i].selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    paymentRows[i].selectedCategory = value!;
                                  });
                                },
                                items: categoryOptions.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  hintText: 'Category',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 150, // Adjust width as needed
                              child: DropdownButtonFormField<String>(
                                value: paymentRows[i].selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    paymentRows[i].selectedType = value!;
                                  });
                                },
                                items: typeOptions.map((type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  hintText: 'Type',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 100, // Adjust width as needed
                              child: TextField(
                                controller: paymentRows[i].amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Container(height: 55,
                                  decoration: BoxDecoration(color: Colors.red,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5),),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete,color: Colors.white,),
                                    onPressed: () {
                                      removePaymentRow(i);
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 10,),
                  // Container(
                  //   width: 50,  // Adjust width to change rectangle size
                  //   height: 34, // Adjust height to change rectangle size
                  //   decoration: BoxDecoration(
                  //     color: Colors.green, // Background color
                  //     borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
                  //   ),
                  //   child: IconButton(
                  //     icon: Icon(Icons.add, color: Colors.white), // Icon with white color
                  //     onPressed: addPaymentRow, // Function to call when pressed
                  //     padding: EdgeInsets.all(0), // Optional: Remove default padding
                  //   ),
                  // )

                ],
              ),
              SizedBox(height: 20),
              if (yearsolddata) ...[
    Text(
    "Is this a fresh property?",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
      color: ColorUtils.primaryColor(), // Replace with ColorUtils.primaryColor() if you have a custom color utility
    ),
    ),
    Row(
    children: [
    Radio(
    value: true,
    groupValue: freshproperty,
    onChanged: (value) {
    setState(() {
      freshproperty = value!;
    });
    },
    ),
    Text('Yes'),
    Radio(
    value: false,
    groupValue: freshproperty,
    onChanged: (value) {
    setState(() {
      freshproperty = value!;
    });
    },
    ),
    Text('No'),
    ],
    ),
    SizedBox(height: 10),

    if (!freshproperty) ...[
    Text(
    'Years old*:',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
      color: ColorUtils.primaryColor(), // Replace with ColorUtils.primaryColor() if you have a custom color utility
    ),
    ),
    SizedBox(height: 10),
    Row(
    children: [
    Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
      color: ColorUtils.primaryColor(), // Replace with your desired background color
    ),
    child: IconButton(
    icon: Icon(Icons.remove, color: Colors.white),
    iconSize: 20,
    onPressed: () {
    setState(() {
    if (yearsOld > 0) {
    yearsOld--;
    }
    });
    },
    ),
    ),
    SizedBox(width: 5),
    Text(
    '$yearsOld',
    style: TextStyle(fontSize: 18),
    ),
    SizedBox(width: 5),
    Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
      color: ColorUtils.primaryColor(), // Replace with your desired background color
    ),
    child: IconButton(
    icon: Icon(Icons.add, color: Colors.white),
    onPressed: () {
    setState(() {
    yearsOld++;
    });
    },
    ),
    ),
    ],
    ),
    ] else
    SizedBox.shrink(),
    ],

    if (facingdata) ...[
              Text(
                'Property Facing* :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                children: propertyFacings.map((facing) {
                  bool isSelected = propertyFacing.contains(facing);
                  IconData iconData;
                  switch (facing) {
                    case 'North':
                      iconData = Icons.arrow_upward;
                      break;
                    case 'South':
                      iconData = Icons.arrow_downward;
                      break;
                    case 'East':
                      iconData = Icons.arrow_forward;
                      break;
                    case 'West':
                      iconData = Icons.arrow_back;
                      break;
                    default:
                      iconData = Icons.error;
                      break;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          propertyFacing.remove(facing); // Remove if already selected
                        } else {
                          if (propertyFacing.length < 3) {
                            propertyFacing.add(facing); // Add if less than 3 selections
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: EdgeInsets.only(right: 5, ),
                      decoration: BoxDecoration(
                        color: isSelected ? customTeal : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorUtils.primaryColor(),),
                      ),
                      child: Column(
                    children: [
                          Icon(iconData, color: isSelected ? Colors.white : customTeal),
                          SizedBox(height: 1),
                          Text(
                            facing,
                            style: TextStyle(
                              color: isSelected ? Colors.white : customTeal,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              ],
    if (possesion) ...[
              Text(
                'Possession Type* :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              //////////
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: possesiontypeController.text == 'Under Construction'
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorUtils.primaryColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            possesiontypeController.text = 'Under Construction';
                          });
                        },
                        child: Text(
                          'Under Construction',
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                          : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorUtils.primaryColor(),
                          side: BorderSide(color: ColorUtils.primaryColor(),),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            possesiontypeController.text = 'Under Construction';
                          });
                        },
                        child: Text(
                          'Under Construction',
                          style: TextStyle(fontSize: 13, color: ColorUtils.primaryColor(),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2), // Add spacing between ElevatedButtons
                  Expanded(
                    child: Container(
                      child: possesiontypeController.text == 'Ready-to-move'
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorUtils.primaryColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            possesiontypeController.text = 'Ready-to-move';
                          });
                        },
                        child: Text(
                          'Ready-to-move',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                          : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorUtils.primaryColor(),
                          side: BorderSide(color: ColorUtils.primaryColor(),),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            possesiontypeController.text = 'Ready-to-move';
                          });
                        },
                        child: Text(
                          'Ready-to-move',
                          style: TextStyle(fontSize: 15, color: ColorUtils.primaryColor(),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              ],
    if (furnishing) ...[
              Text(
                'Furnishing Type :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: furnishingTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: furnishingTypeController.text == type,
                    onSelected: (selected) {
                      setState(() {
                        furnishingTypeController.text = selected ? type : "";
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
    ],
    if (cornerarea) ...[
              SizedBox(height: 20),
              Text("Is this Corner Area?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),)),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isCornerArea,
                    onChanged: (value) {
                      setState(() {
                        isCornerArea = value!;
                      });
                    },
                  ),
                  Text('Yes'),
                  Radio(
                    value: false,
                    groupValue: isCornerArea,
                    onChanged: (value) {
                      setState(() {
                        isCornerArea = value!;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),


              SizedBox(height: 10),
    ],
    if (totalarea) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(keyboardType: TextInputType.number,
                      controller: totalAreaController,
                      decoration: InputDecoration(
                        labelText: "Enter total Area",
                        hintText: 'Enter Total Area',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: areaType,
                      onChanged: (value) {
                        setState(() {
                          areaType = value!;
                        });
                      },
                      items: areaTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
    ],
    if (dimensionroad) ...[
              TextField(
                controller: dimensionController,
                decoration: InputDecoration(
                  labelText: 'Enter dimension',
                  hintText: 'Enter dimension',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: roadController,
                decoration: InputDecoration(
                  labelText: 'Road Length',
                  hintText: 'Road Length',
                  border: UnderlineInputBorder(),
                ),
              ),
              ],
              SizedBox(height: 10),
              if (undividedshare) ...[
              TextField(
                controller: undividedController,
                decoration: InputDecoration(
                  labelText: 'Undivided Share',
                  hintText: 'Undivided Share',
                  border: UnderlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),
              ],
    if (superbuild) ...[
              TextField(
                controller: superbuildupController,
                decoration: InputDecoration(
                  labelText: 'superbuildupArea',
                  hintText: 'superbuildupArea',
                  border: UnderlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
    ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                    
                        color: ColorUtils.primaryColor(), // Your custom background color (teal)
                      ),
                      child: SizedBox(
                        width: 164, // Adjust width as needed
                        height: 50, // Adjust height as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(), // Text color (white)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white), // Replace with your desired back icon
                              SizedBox(width: 8), // Adjust the spacing between icon and text as needed
                              Text(
                                "Back",
                                style: TextStyle(color: Colors.white), // Text color (white)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)), // Adjust the border radius as needed
                        color: ColorUtils.primaryColor(), // Your custom background color (teal)
                      ),
                      child: SizedBox(
                        width: 163, // Adjust width as needed
                        height: 50, // Adjust height as needed
                        child: ElevatedButton(
                          onPressed: () {
                        if (_validateFields()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddressPage(
                                    freshproperty:freshproperty,
                                    isCornerArea: isCornerArea,
                                    category: widget.category,
                                    subcategory: widget.subcategory,
                                    propertyType: widget.propertyType,
                                    propertyOwnerController: propertyOwnerController,
                    
                                    yearsOld: yearsOld,
                    
                                    furnishingTypeController: furnishingTypeController,
                                    totalAreaController: totalAreaController,
                                    dimensionController: dimensionController,
                                    undividedController: undividedController,
                                    superbuildupController: superbuildupController,
                                    roadController: roadController,
                                    paymentType: paymentType,
                                    possessionType: possessionType,
                                    areaType: areaType,
                                    propertyFacing: propertyFacing,
                                    paymentRows: paymentRows,
                                    balconyController: balconyController,
                                    bathroomController: bathroomController,
                                  ),
                            ),
                          );
                        }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(color: Colors.white), // Text color (white)
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PaymentRow {
  TextEditingController amountController = TextEditingController();
  String selectedCategory;
  String selectedType;

  PaymentRow(List<String> categoryOptions, List<String> typeOptions)
      : selectedCategory = categoryOptions.first,
        selectedType = typeOptions.first;

  Map<String, dynamic> toMap() {
    return {
      'category': selectedCategory,
      'type': selectedType,
      'amount': double.tryParse(amountController.text) ?? 0.0,
    };
  }
}
class AddressPage extends StatefulWidget {
  final String category;
  final String subcategory;
  final String propertyType;
  final bool isCornerArea;
  final bool freshproperty;
  final TextEditingController propertyOwnerController;
final TextEditingController balconyController;
final TextEditingController bathroomController;
  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final TextEditingController dimensionController;
  final TextEditingController undividedController;
  final TextEditingController superbuildupController;
  final TextEditingController roadController;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final int yearsOld;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;

  AddressPage({
    required this.isCornerArea,
    required this.freshproperty,
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.propertyOwnerController,


    required this.furnishingTypeController,
    required this.totalAreaController,
    required this.dimensionController,
    required this.undividedController,
    required this.superbuildupController,
    required this.roadController,
    required this.paymentType,
    required this.possessionType,
    required this.areaType,
    required this.propertyFacing,
    required this.paymentRows, required this.yearsOld, required this.balconyController, required this.bathroomController,

  });

  @override
  _AddressPageState createState() => _AddressPageState();
}
class _AddressPageState extends State<AddressPage> {
  final TextEditingController floorNumberController = TextEditingController();
  String floorType = ''; // Variable to store selected floor type
  final TextEditingController doorNoController = TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  List<String> floorTypes = ['Independent Floor', 'Shared Floor', 'Duplex Property'];
  String? _locationAddress;
  LatLng? _selectedLocation;
  Color customTeal = Color(0xFF8F00FF);
  @override
  Widget build(BuildContext context) {
    bool floor = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Villa / Independent House'|| widget.subcategory == 'Hostel/PG/Service Apartment');
    Future<void> _showToastsOneByOne(List<String> messages) async {
      for (String message in messages) {
        _showToast(message); // Show the toast message
        await Future.delayed(Duration(seconds: 1)); // Wait for 1 second (or adjust as needed)
      }
    }

    bool _validateFields() {
      List<String> missingFields = [];

      if (widget.subcategory == 'Commercial Space' || widget.subcategory == 'Flat') {
        if (floorNumberController.text.isEmpty) {
          missingFields.add("Please enter floor number");
        }
        if (floorType.isEmpty) {
          missingFields.add("Please enter floor type");
        }
      }
      if (widget.subcategory == 'Commercial Space' ||
          widget.subcategory == 'Plot / Land' ||
          widget.subcategory == 'Villa / Independent House' ||
          widget.subcategory == 'Flat' ||
          widget.subcategory == 'Hostel/PG/Service Apartment') {
        if (latitudeController.text.isEmpty) {
          missingFields.add("Please select your location");
        }
        if (doorNoController.text.isEmpty) {
          missingFields.add("Please enter door number");
        }
        if (addressLineController.text.isEmpty) {
          missingFields.add("Please enter address");
        }
        if (areaController.text.isEmpty) {
          missingFields.add("Please enter area");
        }
        if (landmarkController.text.isEmpty) {
          missingFields.add("Please enter landmark");
        }
      }

      if (missingFields.isNotEmpty) {
        _showToastsOneByOne(missingFields);
        return false; // Validation failed
      }

      return true; // All validations passed
    }

    return Scaffold(
      appBar:PreferredSize(
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
        title: Text('Address Details',style: TextStyle(color: Colors.white),),
      ),
    ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),
          if (floor) ...[
            TextField(
keyboardType: TextInputType.number,
              controller: floorNumberController,
              decoration: InputDecoration(labelText: "Enter floor number",
                hintText: 'Enter floor number',
                border: UnderlineInputBorder(),
              ),
            ),
            // TextField(
            //   controller: propertyTitleController,
            //   decoration: InputDecoration(
            //     labelText: "Property Title",
            //     hintText: 'Enter property title',
            //     border: UnderlineInputBorder(),
            //   ),
            // ),
            // SizedBox(height: 15),
            //
            //
            // TextField(
            //   controller: descriptionController,
            //   maxLines: 3,
            //   decoration: InputDecoration(
            //     labelText: "Enter property description",
            //     hintText: 'Enter property description',
            //     border: UnderlineInputBorder(),
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              'Floor Type*:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor(),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: floorTypes.map((type) {
                return Row(
                  children: [
                    Radio<String>(
                      value: type,
                      groupValue: floorType,
                      onChanged: (value) {
                        setState(() {
                          floorType = value!;
                        });
                      },
                    ),
                    Text(type),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ],
            Row(
              children: [
                Text(
                  'Location*:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor(),
                  ),
                ),
                SizedBox(width: 50,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                    color: ColorUtils.primaryColor(), // Your custom background color (teal)
                  ),
                  child: SizedBox(
                    width: 190, // Adjust width as needed
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        final Map<String, dynamic>? selectedLocationData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(),
                          ),
                        );
                        if (selectedLocationData != null) {
                          setState(() {
                            _locationAddress = selectedLocationData['address'];
                            _selectedLocation = LatLng(
                              selectedLocationData['latitude'],
                              selectedLocationData['longitude'],
                            );
                            latitudeController.text = _selectedLocation!.latitude.toString();
                            longitudeController.text = _selectedLocation!.longitude.toString();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryColor(), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Choose Location",
                            style: TextStyle(color: Colors.white), // Text color (white)
                          ),
                          SizedBox(width: 8), // Optional spacing between text and icon
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white, // Icon color
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            if (_locationAddress != null) ...[

              SizedBox(height: 10),
              Text(
                ' Address: $_locationAddress',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            SizedBox(height: 10),
            TextField(keyboardType: TextInputType.number,
              controller: doorNoController,
              decoration: InputDecoration(
               labelText: 'Enter door number',
                hintText: 'Enter door number',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressLineController,
              decoration: InputDecoration(
                labelText: 'Enter address line',
                hintText: 'Enter address line',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: areaController,
              decoration: InputDecoration(
             labelText: 'Enter area',
                hintText: 'Enter area',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: landmarkController,
              decoration: InputDecoration(
               labelText: 'Enter landmark',
                hintText: 'Enter landmark',
                border: UnderlineInputBorder(),
              ),
            ),

            ],
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: ColorUtils.primaryColor(), // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 164, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtils.primaryColor(), // Text color (white)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)), // Adjust the border radius as needed
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white), // Replace with your desired back icon
                            SizedBox(width: 8), // Adjust the spacing between icon and text as needed
                            Text(
                              "Back",
                              style: TextStyle(color: Colors.white), // Text color (white)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 1),
                Expanded(
                  flex: 1,
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(20)), // Adjust the border radius as needed
                      color: ColorUtils.primaryColor(), // Your custom background color (teal)
                      ),
                      child: SizedBox(
                      width: 163, // Adjust width as needed
                      height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                      if (_validateFields()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AmentiesScreen(

                  balconyController: widget.balconyController,
                  bathroomController: widget.bathroomController,
                  category: widget.category,
                  subcategory: widget.subcategory,
                  propertyType: widget.propertyType,
                  propertyOwnerController: widget.propertyOwnerController,

                  yearsOld: widget.yearsOld,
                  furnishingTypeController: widget.furnishingTypeController,
                  totalAreaController: widget.totalAreaController,
                  dimensionController: widget.dimensionController,
                  undividedController: widget.undividedController,
                  superbuildupController: widget.superbuildupController,
                  roadController: widget.roadController,
                  isCornerArea: widget.isCornerArea,
                  freshproperty:widget.freshproperty,
                  paymentType: widget.paymentType,
                  possessionType: widget.possessionType,
                  areaType: widget.areaType,
                  propertyFacing: widget.propertyFacing,
                  paymentRows: widget.paymentRows,
                  floorNumberController: floorNumberController,

                  floorType: floorType,
                  doorNoController: doorNoController,
                  addressLineController: addressLineController,
                  areaController: areaController,
                  landmarkController: landmarkController,
                  latitudeController: latitudeController,
                  longitudeController: longitudeController,
                  floorTypes: floorTypes,
                  locationAddress: _locationAddress, // Pass the selected address
                  // selectedLocation: _selectedLocation, // Pass the selected coordinates
                                ),
                          ),
                        );
                      }
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtils.primaryColor(), // Background color
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                      ),
                      ),
                      child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text(
                      "Next ",
                      style: TextStyle(color: Colors.white), // Text color (white)
                      ),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                      ),
                      ),
                      ),
                      ),
                ),
          ],
        ),
          ]),
      ),
    );
  }
}
class AmentiesScreen extends StatefulWidget {
  final String category;
  final String subcategory;
  final String propertyType;
  final TextEditingController propertyOwnerController;
final int yearsOld;
  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final TextEditingController dimensionController;
  final TextEditingController undividedController;
  final TextEditingController superbuildupController;
  final TextEditingController roadController;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;
  final TextEditingController floorNumberController;
  final TextEditingController balconyController;
  final TextEditingController bathroomController;
  final String floorType;
  final TextEditingController doorNoController;
  final TextEditingController addressLineController;
  final TextEditingController areaController;

  final TextEditingController landmarkController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final List<String> floorTypes;
  final String? locationAddress; // Accept the selected address
  final String? selectedLocation;
  final bool isCornerArea;
  final bool freshproperty;
  AmentiesScreen({
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.superbuildupController,
    required this.floorNumberController, required this.floorType, required this.doorNoController, required this.addressLineController, required this.areaController,  required this.landmarkController, required this.latitudeController, required this.longitudeController, required this.floorTypes, required this.propertyOwnerController,  required this.yearsOld, required this.furnishingTypeController,
    required this.roadController,required this.undividedController,required this.dimensionController, required this.totalAreaController, required this.paymentType, required this.possessionType, required this.areaType, required this.propertyFacing,required this.bathroomController, required this.paymentRows,  this.locationAddress, this.selectedLocation, required this.balconyController, required this.isCornerArea, required this.freshproperty,
  });

  @override
  _AmentiesScreenState createState() => _AmentiesScreenState();
}
class _AmentiesScreenState extends State<AmentiesScreen> {
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController nearbyPlaceController = TextEditingController();
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  bool parkingIncluded = false;
  Future<void> _showToastsOneByOne(List<String> messages) async {
    for (String message in messages) {
      _showToast(message); // Show the toast message
      await Future.delayed(Duration(seconds: 1)); // Wait for 1 second (or adjust as needed)
    }
  }

  bool _validateFields() {
    List<String> missingFields = [];

    if (widget.subcategory == 'Commercial Space' ||
        widget.subcategory == 'Hostel/PG/Service Apartment' ||
        widget.subcategory == 'Plot / Land' ||
        widget.subcategory == 'Villa / Independent House' ||
        widget.subcategory == 'Flat') {
      if (amenities.isEmpty) {
        missingFields.add("Please enter amenities.");
      }
      if (nearbyPlaces.isEmpty) {
        missingFields.add("Please enter nearby places details.");
      }
    }

    // Check if parking type is selected
    if (widget.subcategory == 'Commercial Space' ||
        widget.subcategory == 'Villa / Independent House' ||
        widget.subcategory == 'Flat') {
      if (parkingIncluded) {
        if (parkingType.isEmpty) {
          missingFields.add("Please select a parking type.");
        }
        // Uncomment if you want to check for car and bike parking counts
        // if (carParkingCount <= 0) {
        //   missingFields.add("Please specify the number of car parking spaces.");
        // }
        // if (bikeParkingCount <= 0) {
        //   missingFields.add("Please specify the number of bike parking spaces.");
        // }
      }
    }

    if (missingFields.isNotEmpty) {
      _showToastsOneByOne(missingFields);
      return false; // Validation failed
    }

    return true; // All validations passed
  }

  String parkingType = '';
  int carParkingCount = 0;
  int bikeParkingCount = 0;
  int nearbyDistance = 0; // Initialize nearby distance
  Color customTeal = Color(0xFF8F00FF);
  List<String> amenities = [];
  List<Map<String, dynamic>> nearbyPlaces = [];
  List<String> parkingTypes = ['Covered Parking', 'Open Parking'];

  void addNearbyPlace() {
    setState(() {
      nearbyPlaces.add({
        'place': nearbyPlaceController.text,
        'distance': nearbyDistance, // Store the nearby distance as an int
      });
      nearbyPlaceController.clear();
      nearbyDistance = 0; // Reset nearby distance
    });
  }

  void removeNearbyPlace(int index) {
    setState(() {
      nearbyPlaces.removeAt(index);
    });
  }

  void addCarParking() {
    setState(() {
      carParkingCount++;
    });
  }

  void removeCarParking() {
    setState(() {
      if (carParkingCount > 0) {
        carParkingCount--;
      }
    });
  }

  void addBikeParking() {
    setState(() {
      bikeParkingCount++;
    });
  }

  void removeBikeParking() {
    setState(() {
      if (bikeParkingCount > 0) {
        bikeParkingCount--;
      }
    });
  }

  void incrementNearbyDistance() {
    setState(() {
      nearbyDistance++;
    });
  }

  void decrementNearbyDistance() {
    setState(() {
      if (nearbyDistance > 0) {
        nearbyDistance--;
      }
    });
  }

  void addAmenity(String amenity) {
    setState(() {
      amenities.add(amenity);
      amenitiesController.clear(); // Clear the text field after adding amenity
    });
  }

  void removeAmenity(String amenity) {
    setState(() {
      amenities.remove(amenity);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool parking = !(widget.subcategory == 'Plot / Land' || widget.subcategory == 'Hostel/PG/Service Apartment');
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
        title: Text('Amenties,Nearby/Parking',style: TextStyle(color: Colors.white),),
    ),
    ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: amenities.map((amenity) {
                  return InputChip(
                    label: Text(amenity),
                    onDeleted: () {
                      removeAmenity(amenity);
                    },
                  );
                }).toList(),
              ),
              TextField(
                controller: amenitiesController,
                decoration: InputDecoration(
                  labelText: "Enter Amenties",
                  hintText: '(e.g., Swimming Pool,Gym,Garden)',
                  hintStyle: TextStyle(fontSize: 14),
                  border: UnderlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    addAmenity(value);
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Nearby :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.blueGrey, // Background color of the outer container
                  borderRadius: BorderRadius.circular(5), // Adjust border radius as needed
                ),
                child: Column(
                  children: nearbyPlaces.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> place = entry.value;
                    return Container(
                      // Optional: Adjust padding for inner content
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(place['place']),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text('${place['distance']} km'), // Display distance with 'km' suffix
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight:Radius.circular(5),bottomRight: Radius.circular(6),),
                              color: Colors.red, // Background color set to red
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                removeNearbyPlace(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),


              Container(
                decoration: BoxDecoration(
                    // color: Colors.red
                  ),

                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nearbyPlaceController,
                        decoration: InputDecoration(
                          labelText: 'e.g., School,',
                          hintText: 'e.g., School, Hospital',
                          hintStyle: TextStyle(fontSize: 11),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 39,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.primaryColor(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                            onPressed: decrementNearbyDistance,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text('$nearbyDistance km'),
                        SizedBox(width: 5,),// Display current nearby distance
                        Container(
                          width: 36,
                          height: 39,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.primaryColor(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: incrementNearbyDistance,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                        color: Colors.green,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: addNearbyPlace,
                      ),
                    ),
                  ],
                ),
              ),
            if (parking) ...[
              SizedBox(height: 20),
              Text(
                'Parking :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor(),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: parkingIncluded,
                    onChanged: (value) {
                      setState(() {
                        parkingIncluded = value ?? false;
                      });
                    },
                  ),
                  Text('Included'),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: parkingIncluded,
                    onChanged: (value) {
                      setState(() {
                        parkingIncluded = value ?? false;
                      });
                    },
                  ),
                  Text('Not Included'),
                ],
              ),
              if (parkingIncluded)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Parking Type :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor(),
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      children: parkingTypes.map((type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected: parkingType == type,
                          onSelected: (selected) {
                            setState(() {
                              parkingType = selected ? type : '';
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No of Car Parking :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor(),
                      ),
                    ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:ColorUtils.primaryColor(), // Red background color for -
              ),
              child: IconButton(
                icon: Icon(Icons.remove),
                color: Colors.white, // White icon color
                onPressed: removeCarParking,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$carParkingCount',
              style: TextStyle(fontSize: 16), // Adjust font size as needed
            ),
            SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorUtils.primaryColor(), // Green background color for +
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                color: Colors.white, // White icon color
                onPressed: addCarParking,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),
                    Text(
                      'No of Bike Parking :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.primaryColor(),
                      ),
                    ),
      Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:ColorUtils.primaryColor(), // Red background color for -
            ),
            child: IconButton(
              icon: Icon(Icons.remove),
              color: Colors.white, // White icon color
              onPressed: removeBikeParking,
            ),
          ),
          SizedBox(width: 10),
          Text(
            '$bikeParkingCount',
            style: TextStyle(fontSize: 16), // Adjust font size as needed
          ),
          SizedBox(width: 10),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorUtils.primaryColor(), // Green background color for +
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white, // White icon color
              onPressed: addBikeParking,
            ),
          ),
        ],
      ),

      ],
                ),
            ],
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        color: ColorUtils.primaryColor(), // Your custom background color (teal)
                      ),
                      child: SizedBox(
                        width: 164, // Adjust width as needed
                        height: 50, // Adjust height as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(), // Text color (white)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white), // Replace with your desired back icon
                              SizedBox(width: 8), // Adjust the spacing between icon and text as needed
                              Text(
                                "Back",
                                style: TextStyle(color: Colors.white), // Text color (white)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    flex: 1,
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)), // Adjust the border radius as needed
                        color: ColorUtils.primaryColor(), // Your custom background color (teal)
                        ),
                        child: SizedBox(
                        width: 163, // Adjust width as needed
                        height: 50, // Adjust height as needed

                      child: ElevatedButton(
                        onPressed: () {
                        if (_validateFields()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyMediaScreen(category: widget.category,
                                    subcategory: widget.subcategory,
                                    propertyType: widget.propertyType,
                                    propertyOwnerController: widget.propertyOwnerController,

                                    yearsOld: widget.yearsOld,
                                    furnishingTypeController: widget.furnishingTypeController,
                                    totalAreaController: widget.totalAreaController,
                                    dimensionController: widget.dimensionController,
                                    undividedController: widget.undividedController,
                                    superbuildupController: widget.superbuildupController,
                                    roadController: widget.roadController,
                                    isCornerArea: widget.isCornerArea,
                                    freshproperty:widget.freshproperty,
                                    paymentType: widget.paymentType,
                                    possessionType: widget.possessionType,
                                    areaType: widget.areaType,
                                    propertyFacing: widget.propertyFacing,
                                    paymentRows: widget.paymentRows,
                                    balconyController: widget.balconyController,
                                    bathroomController: widget.bathroomController,
                                    floorNumberController: widget.floorNumberController,
                                    floorType: widget.floorType,
                                    doorNoController: widget.doorNoController,
                                    addressLineController: widget.addressLineController,
                                    areaController: widget.areaController,
                                    locationaddress: widget.locationAddress,
                                    selectedlocation: widget.selectedLocation,

                                    landmarkController: widget.landmarkController,
                                    latitudeController: widget.latitudeController,
                                    longitudeController: widget.longitudeController,
                                    floorTypes: widget.floorTypes,
                                    amenities: amenities,
                                    nearbyPlaces: nearbyPlaces,
                                    parkingIncluded: parkingIncluded,
                                    parkingType: parkingType,
                                    carParkingCount: carParkingCount,
                                    bikeParkingCount: bikeParkingCount,

                                  ),
                            ),
                          );
                        }
                        },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryColor(), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Next ",
                            style: TextStyle(color: Colors.white), // Text color (white)
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),

                    ),),
                  ),],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
class PropertyMediaScreen extends StatefulWidget {
  final String category;
  final String subcategory;
  final String propertyType;

  final TextEditingController propertyOwnerController;

  final int yearsOld;
  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final TextEditingController dimensionController;
  final TextEditingController undividedController;
  final TextEditingController superbuildupController;
  final TextEditingController roadController;
  final bool isCornerArea;
  final bool freshproperty;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;
  final TextEditingController floorNumberController;
  final TextEditingController balconyController;
  final TextEditingController bathroomController;
  final String floorType;
  final TextEditingController doorNoController;
  final TextEditingController addressLineController;
  final TextEditingController areaController;
  final String? locationaddress;
  final String? selectedlocation;
  final TextEditingController landmarkController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final List<String> floorTypes;
  final List<String> amenities;
  final List<Map<String, dynamic>> nearbyPlaces;
  final bool parkingIncluded;
  final String parkingType;
  final int carParkingCount;
  final int bikeParkingCount;

  PropertyMediaScreen({
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.propertyOwnerController,

    required this.yearsOld,
    required this.furnishingTypeController,
    required this.totalAreaController,
    required this.dimensionController,
    required this.undividedController,
    required this.superbuildupController,
    required this.roadController,
    required this.paymentType,
    required this.possessionType,
    required this.areaType,
    required this.propertyFacing,
    required this.paymentRows,
    required this.floorNumberController,
    required this.balconyController,
    required this.bathroomController,
    required this.floorType,
    required this.doorNoController,
    required this.addressLineController,
    required this.areaController,
    required this.landmarkController,
    required this.latitudeController,
    required this.longitudeController,
    required this.floorTypes,
    required this.amenities,
    required this.nearbyPlaces,
    required this.parkingIncluded,
    required this.parkingType,
    required this.carParkingCount,
    required this.bikeParkingCount,
    required this.locationaddress,
    required this.selectedlocation, required this.isCornerArea,
    required this.freshproperty,
  });

  @override
  _PropertyMediaScreenState createState() => _PropertyMediaScreenState();
}
class _PropertyMediaScreenState extends State<PropertyMediaScreen> {
  List<File> propertyImages = [];
  List<String> uploadedVideos = [];
  File? selectedVideoFile;
  final ImagePicker _picker = ImagePicker();
  Color customTeal = Color(0xFF8F00FF);
  bool isUploadingVideo = false; // Track video uploading state
  bool isSubmitting = false; // Track property submission state
  Future<void> _showToastsOneByOne(List<String> messages) async {
    for (String message in messages) {
      _showToast(message); // Show the toast message
      await Future.delayed(Duration(seconds: 1)); // Wait for 1 second (or adjust as needed)
    }
  }

  bool _validateFields() {
    List<String> missingFields = [];

    if (widget.subcategory == 'Commercial Space' ||
        widget.subcategory == 'Plot / Land' ||
        widget.subcategory == 'Villa / Independent House' ||
        widget.subcategory == 'Hostel/PG/Service Apartment' ||
        widget.subcategory == 'Flat') {
      if (propertyImages.isEmpty) {
        missingFields.add("Please select image.");
      }
      if (uploadedVideos.isEmpty) {
        missingFields.add("Please upload video.");
      }
    }

    if (missingFields.isNotEmpty) {
      _showToastsOneByOne(missingFields);
      return false; // Validation failed
    }

    return true; // All validations passed
  }

  void removePhoto(int index) {
    setState(() {
      propertyImages.removeAt(index);
    });
  }
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('propertyImages/$fileName');
      final firebase_storage.UploadTask uploadTask = storageReference.putFile(imageFile);
      final firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // Handle error gracefully
    }
  }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        propertyImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickVideo() async {
    setState(() {
      isUploadingVideo = true; // Start uploading indicator
    });

    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File videoFile = File(pickedFile.path);
        if (await videoFile.exists()) {
          String videoUrl = await uploadVideo(videoFile); // Upload video and get URL
          setState(() {
            uploadedVideos.add(videoUrl);
            isUploadingVideo = false; // Stop uploading indicator
          });
        } else {
          print('Selected video file does not exist: ${videoFile.path}');
          setState(() {
            isUploadingVideo = false; // Stop uploading indicator on error
          });
        }
      } else {
        setState(() {
          isUploadingVideo = false; // Stop uploading indicator if no file picked
        });
      }
    } catch (e) {
      print('Error picking video: $e');
      setState(() {
        isUploadingVideo = false; // Stop uploading indicator on error
      });
    }
  }

  Future<String> uploadVideo(File videoFile) async {
    try {
      if (!videoFile.existsSync()) {
        throw Exception('Video file does not exist.');
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('propertyVideos/$fileName');
      final firebase_storage.UploadTask uploadTask = storageReference.putFile(videoFile);
      final firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String videoUrl = await snapshot.ref.getDownloadURL();
      return videoUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return ''; // Handle error gracefully
    }
  }

  void removeVideo(int index) {
    setState(() {
      uploadedVideos.removeAt(index);
    });
  }
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void _submitProperty() async {
    if (!_validateFields()) {
      return; // Stop if validation fails
    }

      setState(() {
        isSubmitting = true; // Start submitting indicator
      });

      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        User? currentUser = FirebaseAuth.instance
            .currentUser; // Get the current logged-in user
        if (currentUser == null) {
          throw Exception('No user is logged in');
        }
        String currentUserId = currentUser.uid; // Get the current user's UID

        List<String> imageUrls = [];
        for (File imageFile in propertyImages) {
          String imageUrl = await uploadImage(imageFile);
          imageUrls.add(imageUrl);
        }

        List<String> videoUrls = [];
        for (String videoUrl in uploadedVideos) {
          videoUrls.add(videoUrl);
        }
        String categoryToStore = widget.category == 'Sell' ? 'Buy' : widget.category;
        // Generate a new document reference with an auto-generated ID
        DocumentReference propertyRef = await firestore.collection('propert')
            .add({
          'category': categoryToStore,
          'subcategory': widget.subcategory,
          'propertyType': widget.propertyType,
          'propertyOwner': widget.propertyOwnerController.text,
          'yearsOld': widget.yearsOld,
          'furnishingType': widget.furnishingTypeController.text,
          'totalArea': widget.totalAreaController.text,
          "dimension": widget.dimensionController.text,
          "undividedshare": widget.undividedController.text,
          "superbuildup": widget.superbuildupController.text,
          "roadController": widget.roadController.text,
          "isCornerArea": widget.isCornerArea,
"freshproperty":widget.freshproperty,
          'possessionType': widget.possessionType,
          'areaType': widget.areaType,
          'propertyFacing': widget.propertyFacing,
          'paymentRows': widget.paymentRows.map((row) => row.toMap()).toList(),
          'floorNumber': widget.floorNumberController.text,
          'balcony': widget.balconyController.text,
          'bathroom': widget.bathroomController.text,
          'floorType': widget.floorType,
          'doorNo': widget.doorNoController.text,
          'addressLine': widget.addressLineController.text,
          'area': widget.areaController.text,
          'locationaddress': widget.locationaddress,
          'createdAt': Timestamp.now(),
          'landmark': widget.landmarkController.text,
          'latitude': widget.latitudeController.text,
          'longitude': widget.longitudeController.text,
          'amenities': widget.amenities,
          'nearbyPlaces': widget.nearbyPlaces,
          'parkingIncluded': widget.parkingIncluded,
          'parkingType': widget.parkingType,
          'carParkingCount': widget.carParkingCount,
          'bikeParkingCount': widget.bikeParkingCount,
          'PropertyImages': imageUrls,
          'videos': videoUrls,
          'uid': currentUserId,
          'featuredStatus': false,
          "propertyId": " ",
          // Optionally add more fields as needed
        });

        // Retrieve the auto-generated property ID
        String propertyId = propertyRef.id;
        await propertyRef.update({'propertyId': propertyId});
        print('Generated Property ID: $propertyId');

        setState(() {
          isSubmitting = false; // Stop submitting indicator
        });
        Fluttertoast.showToast(
          msg: "Property uploaded successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Property submitted successfully!');
      } catch (e) {
        print('Error submitting property: $e');
        setState(() {
          isSubmitting = false; // Stop submitting indicator on error
        });
      }

  }


  @override
  Widget build(BuildContext context) {
    print('Building PropertyMediaScreen with ${propertyImages.length} images');
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
        title: Text('Property Media Upload',style: TextStyle(color: Colors.white),),
    ),
    ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Button to pick images
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorUtils.primaryColor(),
                ),
                child: SizedBox(
                  width: 450,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(
                      'Add Property Images',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtils.primaryColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Display selected images
              if (propertyImages.isNotEmpty) ...[
                Wrap(
                  spacing: 8.0,
                  children: propertyImages.map((image) {
                    return Stack(
                      children: [
                        Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              removePhoto(propertyImages.indexOf(image));
                            },
                            child: Container(
                              color: Colors.red,
                              child: Icon(Icons.clear, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              // Button to pick video
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorUtils.primaryColor(),
                ),
                child: SizedBox(
                  width: 450,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isUploadingVideo ? null : _pickVideo,
                    child: isUploadingVideo
                        ? CircularProgressIndicator() // Show loading indicator
                        : Text(
                      'Upload Video',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtils.primaryColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display uploaded videos
              if (uploadedVideos.isNotEmpty) ...[
                Text(
                  'Uploaded Videos:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.primaryColor(),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: uploadedVideos.asMap().entries.map((entry) {
                    int index = entry.key;
                    String videoUrl = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: Center(
                            child: SvgPicture.asset("assets/images/video.svg"),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              removeVideo(index);
                            },
                            child: Container(
                              color: Colors.red,
                              child: Icon(Icons.clear, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              // Buttons to navigate back or submit property
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        color: ColorUtils.primaryColor(),
                      ),
                      child: SizedBox(
                        width: 163,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Back",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                        color: ColorUtils.primaryColor(),
                      ),
                      child: SizedBox(
                        width: 163,
                        height: 50,
                        child: ElevatedButton(

                          onPressed: isSubmitting ? null : _submitProperty,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorUtils.primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: isSubmitting
                              ? CircularProgressIndicator() // Show loading indicator
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Submit ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.verified, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
