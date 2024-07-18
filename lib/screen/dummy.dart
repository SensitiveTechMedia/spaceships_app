
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spaceships/screen/addview/map.dart';

class EditPropertyPage extends StatefulWidget {
  final DocumentSnapshot? propertySnapshot;

  EditPropertyPage({Key? key, this.propertySnapshot}) : super(key: key);

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? selectedType;
  String? selectedMode;
  String? selectedOption;
  List<File> propertyImages = [];
  List<String> residentialOptions = ['House', 'Villa', 'Apartment'];
  List<String> commercialOptions = ['Office', 'Retail', 'Warehouse', 'PG'];
  String _selectedDirection = '';
  String _selectedFurnishedStatus = '';
  String _selectedParking = '';
  DateTime? _selectedDate;
  LatLng? _selectedLocation;
  String _locationAddress = '';
  bool? _commonArea;
  bool? _ShowPriceAs;
  bool? _PossessionStatus;
  bool? _TransactionType;
  bool? _GatedCommunity;

  TextEditingController propertyNameController = TextEditingController();
  TextEditingController propertyDescriptionController = TextEditingController();
  TextEditingController officeNameController = TextEditingController();
  TextEditingController officeDescriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberOfBedroomsController = TextEditingController();
  TextEditingController numberOfFloorsController = TextEditingController();
  TextEditingController numberOfBathroomsController = TextEditingController();
  TextEditingController sittingRoomController = TextEditingController();
  TextEditingController balconyController = TextEditingController();
  TextEditingController kitchenController = TextEditingController();
  TextEditingController numberOfToiletsController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController plotSquareFeetController = TextEditingController();

  List<String> _facingDirections = [
    'North',
    'South',
    'East',
    'West',
    'NorthEast',
    'SouthEast',
    'NorthWest',
    'SouthWest',
  ];
  List<String> _furnishedStatuses = [
    'Furnished',
    'Unfurnished',
    'Semi-Furnished'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.propertySnapshot != null) {
      initializeFields();
    }
  }

  void initializeFields() {
    DocumentSnapshot snapshot = widget.propertySnapshot!;
    selectedType = snapshot['propertyType'];
    selectedMode = snapshot['property'];
    selectedOption = snapshot['category'];

    propertyNameController.text = snapshot['propertyName'];
    propertyDescriptionController.text = snapshot['description'];
    officeNameController.text = snapshot['officeName'];
    officeDescriptionController.text = snapshot['officeDescription'];
    locationController.text = snapshot['location'];
    addressController.text = snapshot['address'];
    numberOfBedroomsController.text = snapshot['bedRooms'];
    numberOfFloorsController.text = snapshot['numberOfFloors'];
    numberOfBathroomsController.text = snapshot['bathrooms'];
    sittingRoomController.text = snapshot['sittingRoom'];
    balconyController.text = snapshot['balcony'];
    kitchenController.text = snapshot['kitchen'];
    numberOfToiletsController.text = snapshot['numberOfToilets'];
    amountController.text = snapshot['amount'];
    plotSquareFeetController.text = snapshot['plotSquareFeet'];

    _commonArea = snapshot['commonArea'];
    _ShowPriceAs = snapshot['ShowPriceAs'];
    _PossessionStatus = snapshot['PossessionStatus'];
    _TransactionType = snapshot['TransactionType'];
    _GatedCommunity = snapshot['GatedCommunity'];

    _selectedDirection = snapshot['selectedDirection'];
    _selectedFurnishedStatus = snapshot['selectedFurnishedStatus'];
    _selectedParking = snapshot['selectedParking'];

    _selectedDate = snapshot['selectedDate'] != null
        ? DateTime.parse(snapshot['selectedDate'])
        : null;

    if (snapshot['selectedLocation'] != null &&
        snapshot['latitude'] != null &&
        snapshot['longitude'] != null) {
      _selectedLocation = LatLng(snapshot['latitude'], snapshot['longitude']);
      _locationAddress = snapshot['locationAddress'];
    }

    // Initialize amenities checkboxes
    // List<String> selectedAmenities = List<String>.from(
    //     snapshot['selectedAmenities'] ?? []);
    // _amenities.forEach((key, value) {
    //   if (selectedAmenities.contains(key)) {
    //     _amenities[key] = true;
    //   } else {
    //     _amenities[key] = false;
    //   }
    // });

    // Load existing property images if available
    List<dynamic> imageUrls = snapshot['propertyImages'] ?? [];
    imageUrls.forEach((imageUrl) {
      propertyImages.add(File(imageUrl));
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        propertyImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitProperty() async {
    String propertyName = propertyNameController.text.trim();
    String propertyDescription = propertyDescriptionController.text.trim();
    String officeName = officeNameController.text.trim();
    String officeDescription = officeDescriptionController.text.trim();
    String location = locationController.text.trim();
    String address = addressController.text.trim();
    String numberOfBedrooms = numberOfBedroomsController.text.trim();
    String numberOfFloors = numberOfFloorsController.text.trim();
    String numberOfBathrooms = numberOfBathroomsController.text.trim();
    String sittingRoom = sittingRoomController.text.trim();
    String balcony = balconyController.text.trim();
    String kitchen = kitchenController.text.trim();
    String numberOfToilets = numberOfToiletsController.text.trim();
    String amount = amountController.text.trim();
    String plotSquareFeet = plotSquareFeetController.text.trim();

    // Prepare property data
    Map<String, dynamic> propertyData = {
      'selectedMode': selectedMode,
      'propertyName': propertyName,
      'description': propertyDescription,
      'officeName': officeName,
      'officeDescription': officeDescription,
      'location': location,
      'address': address,
      'bedRooms': numberOfBedrooms,
      'numberOfFloors': numberOfFloors,
      'bathrooms': numberOfBathrooms,
      'sittingRoom': sittingRoom,
      'balcony': balcony,
      'kitchen': kitchen,
      'numberOfToilets': numberOfToilets,
      'amount': amount,
      'plotSquareFeet': plotSquareFeet,
      'commonArea': _commonArea,
      'ShowPriceAs': _ShowPriceAs,
      'PossessionStatus': _PossessionStatus,
      'TransactionType': _TransactionType,
      'GatedCommunity': _GatedCommunity,
      'selectedDirection': _selectedDirection,
      'selectedFurnishedStatus': _selectedFurnishedStatus,
      'selectedParking': _selectedParking,
      'selectedDate': _selectedDate != null ? _selectedDate!.toIso8601String() : null,
      'selectedLocation': _selectedLocation != null,
      'latitude': _selectedLocation?.latitude,
      'longitude': _selectedLocation?.longitude,
      'locationAddress': _locationAddress,
      'propertyImages': [], // Initialize empty list to store image URLs
    };

    // Check if 'propertyImages' key exists in the snapshot data
    if (widget.propertySnapshot?.data() is Map<String, dynamic> &&
        (widget.propertySnapshot?.data() as Map<String, dynamic>)
            .containsKey('propertyImages') &&
        (widget.propertySnapshot?.data() as Map<String, dynamic>)['propertyImages'] is List) {
      // Iterate through the property images and add them to the 'propertyImages' list in the map
      (widget.propertySnapshot?.data() as Map<String, dynamic>)['propertyImages'].forEach((imageUrl) {
        propertyData['propertyImages'].add(imageUrl);
      });
    }

    // Convert amenities map to a list of selected amenities
    List<String> selectedAmenities = [];
    // _amenities.forEach((key, value) {
    //   if (value) {
    //     selectedAmenities.add(key);
    //   }
    // });
    propertyData['selectedAmenities'] = selectedAmenities;

    try {
      // Upload new images to Firebase Storage and update the URLs in propertyData
      List<String> uploadedImageUrls = await uploadImagesToStorage();
      propertyData['propertyImages'].addAll(uploadedImageUrls);

      if (widget.propertySnapshot != null) {
        // Update existing property
        await FirebaseFirestore.instance.collection('property').doc(widget.propertySnapshot!.id).update(propertyData);
      } else {
        // Add new property
        await FirebaseFirestore.instance.collection('property').add(propertyData);
      }
      Navigator.of(context).pop(); // Navigate back after successful submission
    } catch (error) {
      print('Error saving property: $error');
      // Handle error if necessary
    }
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> uploadedImageUrls = [];

    for (File imageFile in propertyImages) {
      String fileName = imageFile.path.split('/').last; // Get filename from path
      Reference storageReference = FirebaseStorage.instance.ref().child('property_images/$fileName');

      try {
        await storageReference.putFile(imageFile);
        String downloadUrl = await storageReference.getDownloadURL();
        uploadedImageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image $fileName: $e');
      }
    }

    return uploadedImageUrls;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Property'),

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMode = 'Buy';
                      selectedOption = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: selectedMode == 'Buy' ? Colors.blue : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset("assets/sell.jpg"),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Buy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMode = 'Rent';
                      selectedOption = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: selectedMode == 'Rent' ? Colors.blue : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset("assets/rent.jpg"),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Rent",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Space between the rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Residential';
                      selectedOption = null; // Reset selected option
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Adjust radius as needed
                      border: Border.all(
                        color: selectedType == 'Residential' ? Colors.blue : Colors.black,
                        width: 1, // Adjust border width as needed
                      ),
                    ),
                    child: Text(
                      'Residential',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedType == 'Residential' ? Colors.blue : Colors.black,
                        fontWeight: selectedType == 'Residential' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Commercial';
                      selectedOption = null; // Reset selected option
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Adjust radius as needed
                      border: Border.all(
                        color: selectedType == 'Commercial' ? Colors.blue : Colors.black,
                        width: 1, // Adjust border width as needed
                      ),
                    ),
                    child: Text(
                      'Commercial',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedType == 'Commercial' ? Colors.blue : Colors.black,
                        fontWeight: selectedType == 'Commercial' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedType != null)
              ...[
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: (selectedType == 'Residential' ? residentialOptions : commercialOptions).map((String value) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == value ? Colors.green : Colors.red,
                      ),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],

            if (selectedOption != null && commercialOptions.contains(selectedOption!)) ...[
              SizedBox(height: 10), // Space between the options and text fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: officeNameController,
                  decoration: InputDecoration(
                    labelText: 'Office Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: officeDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Office Description',
                  ),
                  maxLines: 3,
                ),
              ),
              // Add other fields specific to commercial options if needed
            ],
            if (selectedOption != null && residentialOptions.contains(selectedOption!)) ...[
              SizedBox(height: 10), // Space between the options and text fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: propertyNameController,
                  decoration: InputDecoration(
                    labelText: 'Property Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: propertyDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Property Description',
                  ),
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Country',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'State',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'City',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Landmark',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Zipcode',
                  ),
                ),
              ),
              ElevatedButton(
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
                    });
                  }
                },
                child: Text('Select Location'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: numberOfBedroomsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Bedrooms',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: numberOfFloorsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Floors',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: numberOfBathroomsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Bathrooms',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: sittingRoomController,
                  decoration: InputDecoration(
                    labelText: 'Sitting Room',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: balconyController,
                  decoration: InputDecoration(
                    labelText: 'Balcony',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: kitchenController,
                  decoration: InputDecoration(
                    labelText: 'Kitchen',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: numberOfToiletsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Toilets',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    Text('Is There Any Common Area?'),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _commonArea,
                            onChanged: (bool? value) {
                              setState(() {
                                _commonArea = value;
                              });
                            },
                          ),
                          Text('Yes'),
                          Radio<bool>(
                            value: false,
                            groupValue: _commonArea,
                            onChanged: (bool? value) {
                              setState(() {
                                _commonArea = value;
                              });
                            },
                          ),
                          Text('No'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: [
                    Text('Is There Any Gated Community?'),
                    Expanded(
                      child: Column(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _GatedCommunity,
                            onChanged: (bool? value) {
                              setState(() {
                                _GatedCommunity = value;
                              });
                            },
                          ),
                          Text('Yes'),
                          Radio<bool>(
                            value: false,
                            groupValue: _GatedCommunity,
                            onChanged: (bool? value) {
                              setState(() {
                                _GatedCommunity = value;
                              });
                            },
                          ),
                          Text('No'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Text('Property Area', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: plotSquareFeetController,
                  decoration: InputDecoration(
                    labelText: 'Plot Area',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Total Area',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Carpet Area',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Super Area',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Possession Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [

                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _PossessionStatus,
                            onChanged: (bool? value) {
                              setState(() {
                                _PossessionStatus = value;
                              });
                            },
                          ),
                          Text('Under Construction'),
                          Radio<bool>(
                            value: false,
                            groupValue: _PossessionStatus,
                            onChanged: (bool? value) {
                              setState(() {
                                _PossessionStatus = value;
                              });
                            },
                          ),
                          Text('Ready to Move'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text('Transaction Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [

                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _TransactionType,
                            onChanged: (bool? value) {
                              setState(() {
                                _TransactionType = value;
                              });
                            },
                          ),
                          Text('New Property'),
                          Radio<bool>(
                            value: false,
                            groupValue: _TransactionType,
                            onChanged: (bool? value) {
                              setState(() {
                                _TransactionType = value;
                              });
                            },
                          ),
                          Text('Resale'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Text('Pricing Details ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Expected price ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Price per sq.ft',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Maintanence charge ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Maintanence Period ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Token/Broking charge ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextField(

                  decoration: InputDecoration(
                    labelText: 'Other Amout ',
                  ),
                ),
              ),
              Text('Show Price As', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [

                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _ShowPriceAs,
                            onChanged: (bool? value) {
                              setState(() {
                                _ShowPriceAs = value;
                              });
                            },
                          ),
                          Text('Negotiable'),
                          Radio<bool>(
                            value: false,
                            groupValue: _ShowPriceAs,
                            onChanged: (bool? value) {
                              setState(() {
                                _ShowPriceAs = value;
                              });
                            },
                          ),
                          Text('Call for Pricing'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text('Select Direction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _facingDirections.map((direction) {
                  return ChoiceChip(
                    label: Text(direction),
                    selected: _selectedDirection == direction,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDirection = direction;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Select Furnished Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _furnishedStatuses.map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: _selectedFurnishedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFurnishedStatus = status;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Select Parking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              SizedBox(height: 10),
              Text('Select Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Wrap(
              //   spacing: 8.0,
              //   children: _amenities.keys.map((amenity) {
              //     return ChoiceChip(
              //       label: Text(amenity),
              //       selected: _amenities[amenity]!,
              //       onSelected: (selected) {
              //         setState(() {
              //           _amenities[amenity] = selected;
              //         });
              //       },
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add Property Images'),
              ),
              SizedBox(height: 10),
              if (propertyImages.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: propertyImages.map((image) {
                    return Stack(
                      children: [
                        Image.network(
                          image.path, // Assuming image is a URL here
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                propertyImages.remove(image);
                              });
                            },
                            child: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProperty,
              child: Text('Submit'),
            ),

          ],

        ),
      ),
    );
  }
}

