import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaceships/screen/addview/map.dart';
import 'package:spaceships/screen/homeview/home.dart';
class PropertyViewScreen extends StatelessWidget {
  final String uid;
  Color customTeal = Color(0xFF8F00FF);
  PropertyViewScreen({required this.uid});

  void _deleteProperty(BuildContext context, DocumentReference ref) async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this property?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Perform deletion if confirmed
                try {
                  await ref.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Property deleted successfully!')),
                  );
                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete property: $e')),
                  );
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: customTeal,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
              );

            },
          ),
          title: Text('My Properties',style: TextStyle(color: Colors.white),),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('propert')
              .where('uid', isEqualTo: uid) // Filter properties by user UID
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No properties found.'));
            }

            // Display properties
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;



                String propertyName = data['propertyTitle'];
                String propertyType = data['subcategory'];
                List<String> propertyImages = List<String>.from(data['PropertyImages']);

                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Property Images
                      SizedBox(
                        width: 150.0, // Fixed width for images
                        height: 150.0, // Fixed height for images
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: propertyImages.length,
                          itemBuilder: (context, imgIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                propertyImages[imgIndex],
                                width: 150.0,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),

                      ),
                      // Right side - Property Details and Actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                propertyName,
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(propertyType),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProperty(
                                            propertySnapshot: document

                                        ),
                                      ),
                                    );

    },
                                  child: Text('Edit'),
                                ),
                                SizedBox(width: 8.0),
                                TextButton(
                                  onPressed: () {
                                    _deleteProperty(context, document.reference); // Pass context and reference
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),);
  }
}
class EditProperty extends StatefulWidget {
  final DocumentSnapshot? propertySnapshot;

  EditProperty({Key? key, this.propertySnapshot}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<EditProperty> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Color customTeal = Color(0xFF071A4B);
  List<String> cate = ["Buy", "Rent", "Lease"];
  String? category;
  int _selectedIndex = 0;
  void _navigateToCategory(String category) {
    if (context != null) {
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category,   propertySnapshot: widget.propertySnapshot,),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    category = widget.propertySnapshot?['category'] ?? '';
  }
  void initializeFields() {
    DocumentSnapshot snapshot = widget.propertySnapshot!;
    category = snapshot['category'];

  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Property"),
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
                  color: customTeal,
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
  final DocumentSnapshot? propertySnapshot;

  CategoryScreen({required this.category, this.propertySnapshot });

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Color customTeal = Color(0xFF071A4B);
  int _selectedSubcategoryIndex = -1;
  String _selectedPropertyType = "";
  int bhkValue = 1;
  TextEditingController propertyTypeController = TextEditingController();
  Map<String, List<String>> propertyTypes = {
    "Flat": ["Property Type"],
    "Villa / Independent House": ["Independent Villa", "Gated Community"],
    "Plot / Land": ["Individual Plot", "Gated Community Plot", "Agriculture Land"],
    "Commercial Space/Hostel/PG/Service Apartment": ["Independent Floor", "Shared Floor", "Independent Building", "Commercial Shop"],
  };
  List<Map<String, dynamic>> subcategories = [];

  void initializeFields() {
    if (widget.propertySnapshot != null) {
      DocumentSnapshot snapshot = widget.propertySnapshot!;

      // Initialize _selectedSubcategoryIndex based on the subcategory name in snapshot
      _selectedSubcategoryIndex = subcategories.indexWhere((subcategory) =>
      subcategory["category"] == snapshot['subcategory']);

      // Initialize _selectedPropertyType based on propertyType in snapshot
      _selectedPropertyType = snapshot['propertyType'];

      // Initialize bhkValue if _selectedPropertyType is "1 BHK"
      if (_selectedPropertyType == "1 BHK") {
        bhkValue = 1;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFields();
    updateSubcategories(); // Add this method call
  }

  void updateSubcategories() {
    switch (widget.category) {
      case "Buy":
      case "Rent":
      case "Lease":
        setState(() {
          subcategories = [
            {"name": "Flat", "icon": Icons.apartment,},
            {"name": "Villa / Independent House","icon": Icons.villa,},
            {"name": "Plot / Land","icon": Icons.all_inbox},
            {"name": "Commercial Space/Hostel/PG/Service Apartment","icon": Icons.hotel_sharp},
          ];
          _selectedSubcategoryIndex = -1; // Reset selected index
          _selectedPropertyType = ""; // Reset property type
          propertyTypeController.clear(); // Clear text field input
        });
        break;
      default:
        setState(() {
          subcategories = [];
        });
    }
  }

  @override
  void didUpdateWidget(covariant CategoryScreen oldWidget) {
    if (oldWidget.category != widget.category) {
      updateSubcategories();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.category} Category'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                'Select a subcategory:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customTeal,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 350,
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
                          bhkValue = 1; // Reset bhkValue when subcategory changes
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected ? customTeal : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: customTeal),
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
              if (_selectedSubcategoryIndex != -1 &&
          subcategories[_selectedSubcategoryIndex]["name"] == "Flat") // Show text field only when "Flat" is selected
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Property Type:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customTeal,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: customTeal),
                  onPressed: () {
                    setState(() {
                      if (bhkValue > 1) bhkValue--; // Decrease value, minimum 1
                    });
                  },
                ),
                Text(
                  '$bhkValue BHK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: customTeal,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: customTeal),
                  onPressed: () {
                    setState(() {
                      bhkValue++; // Increase value
                    });
                  },
                ),
              ],
            ),
          ],
        ),

        if (_selectedSubcategoryIndex != -1 &&
    subcategories[_selectedSubcategoryIndex]["name"] != "Flat") // Show property types list for other subcategories
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Property Type:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: customTeal,
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
                    bhkValue = 1; // Reset bhkValue when property type changes
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? customTeal : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: customTeal),
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
    Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
    color: customTeal, // Your custom background color (teal)
    ),
    child: SizedBox(
    width: 140, // Adjust width as needed
    height: 50, // Adjust height as needed
    child: ElevatedButton(
    onPressed: () {
    Navigator.of(context).pop();
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: customTeal, // Text color (white)
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


    Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
    color: customTeal, // Your custom background color (teal)
    ),
    child: SizedBox(
    width                      : 140, // Adjust width as needed
      height: 50, // Adjust height as needed
      child: ElevatedButton(
        onPressed: () {
          if (_selectedSubcategoryIndex != -1) {
            String selectedSubcategory = subcategories[_selectedSubcategoryIndex]["name"];
            String selectedPropertyType = subcategories[_selectedSubcategoryIndex]["name"] == "Flat"
                ? '$bhkValue BHK'
                : _selectedPropertyType.isNotEmpty
                ? _selectedPropertyType
                : "Select Property Type";

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
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: customTeal, // Background color
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
            Icon(Icons.arrow_forward, color: Colors.white), // Replace with your desired forward icon
          ],
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
              color: customTeal,
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

  PropertyDetailsScreen({
    required this.category,
    required this.subcategory,
    required this.propertyType,
  });
  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}
class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  TextEditingController propertyOwnerController = TextEditingController();
  TextEditingController propertyTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController furnishingTypeController = TextEditingController();
  TextEditingController totalAreaController = TextEditingController();
  Color customTeal = Color(0xFF071A4B);
  String paymentType = "One-Time";
  String possessionType = "Under Construction";
  String areaType = 'Sq.Ft'; // Initial value
  int yearsOld = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
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
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: propertyOwnerController,
                decoration: InputDecoration(
                  labelText: 'Ex.Property Owner, Middle Agent/broker, etc.',
                  hintText: 'Ex.Property Owner, Middle Agent/broker, etc.',
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Property Title :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: propertyTitleController,
                decoration: InputDecoration(
                  labelText: "Property Title",
                  hintText: 'Enter property title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Enter property description",
                  hintText: 'Enter property description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Types :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
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
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                removePaymentRow(i);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addPaymentRow,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Years old* :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (yearsOld > 0) {
                          yearsOld--;
                        }
                      });
                    },
                  ),
                  Text(
                    '$yearsOld',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        yearsOld++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Property Facing* :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? customTeal : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: customTeal),
                      ),
                      child: Column(
                        children: [
                          Icon(iconData, color: isSelected ? Colors.white : customTeal),
                          SizedBox(height: 4),
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
              Text(
                'Possession Type* :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: possessionType,
                onChanged: (value) {
                  setState(() {
                    possessionType = value!;
                  });
                },
                items: possessionTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Furnishing Type :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
              Text(
                'Total Area :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(keyboardType: TextInputType.number,
                      controller: totalAreaController,
                      decoration: InputDecoration(
                        labelText: "Enter total Area",
                        hintText: 'Enter Total Area',
                        border: OutlineInputBorder(),
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Text color (white)
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressPage(

                                category: widget.category,
                                subcategory: widget.subcategory,
                                propertyType: widget.propertyType,
                                propertyOwnerController: propertyOwnerController,
                                propertyTitleController: propertyTitleController,
                                descriptionController: descriptionController,
                                yearsOld: yearsOld,
                                furnishingTypeController: furnishingTypeController,
                                totalAreaController: totalAreaController,
                                paymentType: paymentType,
                                possessionType: possessionType,
                                areaType: areaType,
                                propertyFacing: propertyFacing,
                                paymentRows: paymentRows,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Background color
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


  final TextEditingController propertyOwnerController;
  final TextEditingController propertyTitleController;
  final TextEditingController descriptionController;

  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final int yearsOld;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;

  AddressPage({
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.propertyOwnerController,
    required this.propertyTitleController,
    required this.descriptionController,

    required this.furnishingTypeController,
    required this.totalAreaController,
    required this.paymentType,
    required this.possessionType,
    required this.areaType,
    required this.propertyFacing,
    required this.paymentRows, required this.yearsOld,
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

  List<String> floorTypes = ['Independent Floor', 'Shared Floor', 'Duplex Property'];
  String? _locationAddress;
  LatLng? _selectedLocation;
  Color customTeal = Color(0xFF071A4B);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Floor Number:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: floorNumberController,
                decoration: InputDecoration(labelText: "Enter floor number",
                  hintText: 'Enter floor number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Floor Type*:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
              Text(
                'Location*:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              TextField(keyboardType: TextInputType.number,
                controller: doorNoController,
                decoration: InputDecoration(
                  labelText: 'Enter door number',
                  hintText: 'Enter door number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: addressLineController,
                decoration: InputDecoration(
                  labelText: 'Enter address line',
                  hintText: 'Enter address line',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: areaController,
                decoration: InputDecoration(
                  labelText: 'Enter area',
                  hintText: 'Enter area',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: landmarkController,
                decoration: InputDecoration(
                  labelText: 'Enter landmark',
                  hintText: 'Enter landmark',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                  color: customTeal, // Your custom background color (teal)
                ),
                child: SizedBox(
                  width: 450, // Adjust width as needed
                  height: 50,
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
                      backgroundColor: customTeal, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the border radius as needed
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add Location",
                          style: TextStyle(color: Colors.white), // Text color (white)
                        ),

                      ],
                    ),
                  ),
                ),
              ),if (_locationAddress != null) ...[
                SizedBox(height: 10),
                Text(
                  ' Address: $_locationAddress',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Text color (white)
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmentiesScreen(


                                category: widget.category,
                                subcategory: widget.subcategory,
                                propertyType: widget.propertyType,
                                propertyOwnerController: widget.propertyOwnerController,
                                propertyTitleController: widget.propertyTitleController,
                                descriptionController: widget.descriptionController,
                                yearsOld: widget.yearsOld,
                                furnishingTypeController: widget.furnishingTypeController,
                                totalAreaController: widget.totalAreaController,
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Background color
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
  final TextEditingController propertyTitleController;
  final TextEditingController descriptionController;
  final int yearsOld;
  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;
  final TextEditingController floorNumberController;
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
  AmentiesScreen({
    required this.category,
    required this.subcategory,
    required this.propertyType, required this.floorNumberController, required this.floorType, required this.doorNoController, required this.addressLineController, required this.areaController,  required this.landmarkController, required this.latitudeController, required this.longitudeController, required this.floorTypes, required this.propertyOwnerController, required this.propertyTitleController, required this.descriptionController, required this.yearsOld, required this.furnishingTypeController, required this.totalAreaController, required this.paymentType, required this.possessionType, required this.areaType, required this.propertyFacing, required this.paymentRows,  this.locationAddress, this.selectedLocation,
  });

  @override
  _AmentiesScreenState createState() => _AmentiesScreenState();
}
class _AmentiesScreenState extends State<AmentiesScreen> {
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController nearbyPlaceController = TextEditingController();
  bool parkingIncluded = false;
  String parkingType = '';
  int carParkingCount = 0;
  int bikeParkingCount = 0;
  int nearbyDistance = 0; // Initialize nearby distance
  Color customTeal = Color(0xFF071A4B);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amenities :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
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
                  border: OutlineInputBorder(),
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
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: nearbyPlaces.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> place = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: Text(place['place']),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('${place['distance']} km'), // Display distance with 'km' suffix
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeNearbyPlace(index);
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
              Row(
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
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: decrementNearbyDistance,
                      ),
                      Text('$nearbyDistance km'), // Display current nearby distance
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: incrementNearbyDistance,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addNearbyPlace,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Parking :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
                        color: Colors.blue,
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
                        color: Colors.blue,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: removeCarParking,
                        ),
                        SizedBox(width: 10),
                        Text('$carParkingCount'),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: addCarParking,
                        ),

                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No of Bike Parking :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: removeBikeParking,
                        ),
                        SizedBox(width: 10),
                        Text('$bikeParkingCount'),

                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: addBikeParking,
                        ),

                      ],
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Text color (white)
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      color: customTeal, // Your custom background color (teal)
                    ),
                    child: SizedBox(
                      width: 140, // Adjust width as needed
                      height: 50, // Adjust height as needed

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyMediaScreen(   category: widget.category,
                                subcategory: widget.subcategory,
                                propertyType: widget.propertyType,
                                propertyOwnerController: widget.propertyOwnerController,
                                propertyTitleController: widget.propertyTitleController,
                                descriptionController: widget.descriptionController,
                                yearsOld: widget.yearsOld,
                                furnishingTypeController: widget.furnishingTypeController,
                                totalAreaController: widget.totalAreaController,
                                paymentType: widget.paymentType,
                                possessionType: widget.possessionType,
                                areaType: widget.areaType,
                                propertyFacing: widget.propertyFacing,
                                paymentRows: widget.paymentRows,
                                floorNumberController: widget.floorNumberController,
                                floorType: widget.floorType,
                                doorNoController: widget.doorNoController,
                                addressLineController: widget.addressLineController,
                                areaController: widget.areaController,
                                locationaddress: widget.locationAddress,
                                selectedlocation:widget.selectedLocation,

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
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: customTeal, // Background color
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

                    ),),],
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
  final TextEditingController propertyTitleController;
  final TextEditingController descriptionController;
  final int yearsOld;
  final TextEditingController furnishingTypeController;
  final TextEditingController totalAreaController;
  final String paymentType;
  final String possessionType;
  final String areaType;
  final List<String> propertyFacing;
  final List<PaymentRow> paymentRows;
  final TextEditingController floorNumberController;
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
    required this.propertyTitleController,
    required this.descriptionController,
    required this.yearsOld,
    required this.furnishingTypeController,
    required this.totalAreaController,
    required this.paymentType,
    required this.possessionType,
    required this.areaType,
    required this.propertyFacing,
    required this.paymentRows,
    required this.floorNumberController,
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
    required this.selectedlocation,
  });

  @override
  _PropertyMediaScreenState createState() => _PropertyMediaScreenState();
}
class _PropertyMediaScreenState extends State<PropertyMediaScreen> {
  List<File> propertyImages = [];
  List<String> uploadedVideos = [];
  File? selectedVideoFile;
  final ImagePicker _picker = ImagePicker();
  Color customTeal = Color(0xFF071A4B);
  bool isUploadingVideo = false; // Track video uploading state
  bool isSubmitting = false; // Track property submission state
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

  void _submitProperty() async {
    setState(() {
      isSubmitting = true; // Start submitting indicator
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? currentUser = FirebaseAuth.instance.currentUser; // Get the current logged-in user
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

      // Generate a new document reference with an auto-generated ID
      DocumentReference propertyRef = await firestore.collection('propert').add({
        'category': widget.category,
        'subcategory': widget.subcategory,
        'propertyType': widget.propertyType,
        'propertyOwner': widget.propertyOwnerController.text,
        'propertyTitle': widget.propertyTitleController.text,
        'description': widget.descriptionController.text,
        'yearsOld': widget.yearsOld,
        'furnishingType': widget.furnishingTypeController.text,
        'totalArea': widget.totalAreaController.text,
        'paymentType': widget.paymentType,
        'possessionType': widget.possessionType,
        'areaType': widget.areaType,
        'propertyFacing': widget.propertyFacing,
        'paymentRows': widget.paymentRows.map((row) => row.toMap()).toList(),
        'floorNumber': widget.floorNumberController.text,
        'floorType': widget.floorType,
        'doorNo': widget.doorNoController.text,
        'addressLine': widget.addressLineController.text,
        'area': widget.areaController.text,
        'locationaddress': widget.locationaddress,
        'selectedlocation': widget.selectedlocation,
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
        "propertyId" : " ",
        // Optionally add more fields as needed
      });

      // Retrieve the auto-generated property ID
      String propertyId = propertyRef.id;
      await propertyRef.update({'propertyId': propertyId});
      print('Generated Property ID: $propertyId');

      setState(() {
        isSubmitting = false; // Stop submitting indicator
      });

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
      appBar: AppBar(
        title: Text('Property Media Upload'),
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
                  color: customTeal,
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
                      backgroundColor: customTeal,
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
                  color: customTeal,
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
                      backgroundColor: customTeal,
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
                    color: Colors.blue,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: customTeal,
                    ),
                    child: SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },

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
                  Container(
                    child: SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _submitProperty,

                        child: isSubmitting
                            ? CircularProgressIndicator() // Show loading indicator
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Submit ",
                              style: TextStyle(color: Colors.white),
                            ),

                          ],
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

