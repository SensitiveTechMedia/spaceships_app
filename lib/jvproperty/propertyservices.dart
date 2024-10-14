import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/helpsupport.dart';

class Propertyservices extends StatefulWidget {
  const Propertyservices({super.key});

  @override
  State<Propertyservices> createState() => _PropertyservicesState();
}

class _PropertyservicesState extends State<Propertyservices> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userMobileNumber;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? selectedPropertyType;
  final List<String> propertyTypes = ["Flat", "Plot", "Villa", "Commercial"];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  final List<Map<String, dynamic>> propertyTopics = [
    {"text": "Property Maintenance", "icon": Icons.home},
    {"text": "Sale Deed", "icon": Icons.attach_file},
    {"text": "Rental Agreement", "icon": Icons.assignment},
    {"text": "Lease Agreement", "icon": Icons.book},
    {"text": "Property Registration", "icon": Icons.location_city},
    {"text": "Katha Transfer", "icon": Icons.compare_arrows},
    {"text": "Property EC", "icon": Icons.eco},
    {"text": "Property Tax", "icon": Icons.money},
    {"text": "BESCOM Transfer", "icon": Icons.flash_on},
    {"text": "BWSSB Transfer", "icon": Icons.opacity},
    {"text": "Knowledge Base", "icon": Icons.library_books},
    {"text": "Property Checklist", "icon": Icons.playlist_add_check},
  ];

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
                      ? const CircularProgressIndicator() // Show circular progress indicator if loading
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
            title: const Row(
              children: <Widget>[
                // Adjust spacing as needed
                Text("Property Services", style: TextStyle(color: Colors.white)),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0), // Adjust the value as needed
                child: Padding(
                  padding: const EdgeInsets.all(0.0), // Adjust the margin size as needed
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.question_mark_outlined, size: 20, color: ColorUtils.primaryColor()),
                      onPressed: () {
                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>SupportScreen())
                        );},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 1.6,
          ),
          itemCount: propertyTopics.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _showModalBottomSheet(propertyTopics[index]["text"]);
              },
              child: Card(
                color: ColorUtils.primaryColor(), // Set background color to custom teal
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          propertyTopics[index]["icon"],
                          color: ColorUtils.primaryColor(), // Set icon color to custom teal
                          size: 30.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        propertyTopics[index]["text"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14.0, color: Colors.white), // Set text color to white
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
