import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/filter.dart';
import 'package:spaceships/screen/videoplayer.dart';

class Featured extends StatefulWidget {

  @override
  _AllPageState createState() => _AllPageState();
}
class _AllPageState extends State<Featured> {
  Color customTeal = Color(0xFF8F00FF);


  @override
  void initState() {
    super.initState();


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
            backgroundColor: ColorUtils.primaryColor(), // Example app bar background color
            title: Text(
              "Featured properties",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Screen(onApplyFilters: (Map<String, dynamic> filters) {  },

                    )),
                  );
                  print('Icon button pressed');
                },
              ),
            ],
          ),
        ),
      ),


      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('propert')
                  .where('featuredStatus', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No properties found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var wishlistItem = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPage(
                              videoUrl: List<String>.from(wishlistItem['videos'] ?? []),
                              landmark: wishlistItem['landmark'] ?? '',
                              latitude: wishlistItem['latitude'] ?? '',
                              locationAddress: wishlistItem['locationaddress'] ?? '',
                              longitude: wishlistItem['longitude'] ?? '',
                              nearbyPlaces: List<Map<String, dynamic>>.from(wishlistItem['nearbyPlaces'] ?? []),
                              parkingIncluded: wishlistItem['parkingIncluded'] ?? '',
                              parkingType: wishlistItem['parkingType'] ?? '',
                              possessionType: wishlistItem['possessionType'] ?? '',
                              postUid: wishlistItem['propertyId'] ?? '',
                              propertyFacing: List<String>.from(wishlistItem['propertyFacing'] ?? []),
                              paymentRows: List<Map<String, dynamic>>.from(wishlistItem['paymentRows'] ?? []),
                              roadController: wishlistItem['roadController'] ?? '',
                              superbuildup: wishlistItem['superbuildup'] ?? '',
                              totalArea: wishlistItem['totalArea'] ?? '',
                              undividedShare: wishlistItem['undividedshare'] ?? '',
                              yearsOld: wishlistItem['yearsOld'] ?? '',
                              category: wishlistItem['category'] ?? '',
                              subcategory: wishlistItem['subcategory'] ?? '',
                              propertyType: wishlistItem['propertyType'] ?? '',
                              propertyOwner: wishlistItem['propertyOwner'] ?? '',
                              addressLine: wishlistItem['addressLine'] ?? '',
                              amenities: List<String>.from(wishlistItem['amenities'] ?? []),
                              area: wishlistItem['area'] ?? '',
                              bikeParkingCount: wishlistItem['bikeParkingCount'] ?? '',
                              carParkingCount: wishlistItem['carParkingCount'] ?? '',
                              dimension: wishlistItem['dimension'] ?? '',
                              doorNo: wishlistItem['doorNo'] ?? '',
                              floorType: wishlistItem['floorType'] ?? '',
                              floorNumber: wishlistItem['floorNumber'] ?? '',
                              furnishingType: wishlistItem['furnishingType'] ?? '',
                              isCornerArea: wishlistItem['isCornerArea'] ?? false,
                              featuredStatus: wishlistItem['featuredStatus'] ?? false,
                              balcony: wishlistItem['balcony'] ?? '',
                              bathroom: wishlistItem['bathroom'] ?? '',
                              propertyId: wishlistItem['propertyId'] ?? '',
                              imageUrl: wishlistItem['PropertyImages'] ?? '',
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
                                    image: wishlistItem['PropertyImages'] != null &&
                                        wishlistItem['PropertyImages'].isNotEmpty
                                        ? DecorationImage(
                                      image: NetworkImage(wishlistItem['PropertyImages'][0]),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: wishlistItem['PropertyImages'] == null ||
                                      wishlistItem['PropertyImages'].isEmpty
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
                                      color: Color.fromRGBO(43, 84, 112, 55),
                                    ),
                                    child: Text(
                                      wishlistItem['subcategory'] ?? 'cat',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
                                      wishlistItem['propertyType'] ?? 'No Title',
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
                                          wishlistItem['area'] ?? 'No Address',
                                          style: TextStyle(
                                            color: ColorUtils.primaryColor(),
                                            fontSize: 10,
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
          ),



        ],
      ),
    );
  }
}



class ViewPage extends StatelessWidget {
  final List<String> videoUrl;
  final String landmark;
  final String latitude;
  final String locationAddress;
  final String longitude;
  final List<dynamic> nearbyPlaces;
  final bool parkingIncluded;
  // final String paymentType;
  final String parkingType;
  final String possessionType;
  final String postUid;
  final List<String> propertyFacing;
  final List<Map<String, dynamic>> paymentRows;
  final String roadController;
  final String superbuildup;
  final String totalArea;
  final String undividedShare;
  final int yearsOld;
  final String category;
  final String subcategory;
  final String propertyType;
  final String propertyOwner;
  final String addressLine;
  final List<dynamic> amenities;
  final String area;
  final int bikeParkingCount;
  final int carParkingCount;
  final String dimension;
  final String doorNo;
  final bool featuredStatus;
  final String floorType;
  final String floorNumber;
  final String furnishingType;
  final bool isCornerArea;
  final String balcony;
  final String bathroom;
  final String propertyId;
  final List<dynamic> imageUrl;

  ViewPage({
    required this.videoUrl,
    required this.landmark,
    required this.latitude,
    required this.locationAddress,
    required this.longitude,
    required this.nearbyPlaces,
    required this.parkingIncluded,
    // required this.paymentType,
    required this.parkingType,
    required this.possessionType,
    required this.postUid,
    required this.propertyFacing,
    required this.roadController,
    required this.superbuildup,
    required this.totalArea,
    required this.undividedShare,
    required this.yearsOld,
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.propertyOwner,
    required this.addressLine,
    required this.amenities,
    required this.area,
    required this.bikeParkingCount,
    required this.carParkingCount,
    required this.dimension,
    required this.doorNo,
    required this.featuredStatus,
    required this.floorType,
    required this.floorNumber,
    required this.furnishingType,
    required this.isCornerArea,
    required this.balcony,
    required this.bathroom,
    required this.propertyId,
    required this.imageUrl, required this.paymentRows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            if (imageUrl.isNotEmpty)
              Container(
                height: 200,
                child: PageView.builder(
                  itemCount: imageUrl.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrl[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            SizedBox(height: 16),


            Text(
              'Property Type: $propertyType',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Owner: $propertyOwner'),
            Text('Address: $locationAddress'),
            Text('years old: $yearsOld'),
            Text('category: $category'),
            Text('subcategory: $subcategory'),

            // Text('Landmark: $landmark'),
            // Text('Area: $area'),
            // Text('Subcategory: $subcategory'),
            Text('Furnishing Type: $furnishingType'),
            Text('Floor Type: $floorType'),
            Text('Total Area: $totalArea'),
            Text('Super Built-up: $superbuildup'),
            Text('undivided share: $undividedShare'),
            // Text('Years Old: $yearsOld'),
            SizedBox(height: 16),

            // Amenities
            Text(
              'Amenities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...amenities.map((amenity) => Text(amenity)).toList(),
            // SizedBox(height: 16),


            Text(
              'Nearby Places:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...nearbyPlaces.map((place) {
              return Text("${place['place']} (${place['distance']} km)");
            }).toList(),
            // SizedBox(height: 16),
            //
            // // Parking Information
            Text('Parking Included: ${parkingIncluded ? "Yes" : "No"}'),
            Text('Parking Type: $parkingType'),
            Text('possessionType: $possessionType'),
            Text('Property Facing:'),
            ...propertyFacing.map((facing) {
              return ListTile(
                title: Text(facing),
              );
            }).toList(),
            Text('Road length: $roadController'),
            Text('Area: $area'),
            Text('Bike Parking Count: $bikeParkingCount'),
            Text('Car Parking Count: $carParkingCount'),
            SizedBox(height: 16),
            Text('Payment Details:'),
            ...paymentRows.map((payment) {
              return ListTile(
                title: Text('Category: ${payment['category']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${payment['amount']}'),
                    Text('Type: ${payment['type']}'),
                  ],
                ),
              );
            }).toList(),
            // Additional Information
            Text(
              'Additional Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Address line: $addressLine'),
            Text('Door No: $doorNo'),
            Text('Dimension: $dimension'),
            Text('Floor Number: $floorNumber'),
            Text('Balcony: $balcony'),
            Text('Bathroom: $bathroom'),
            Text('Is Corner Area: ${isCornerArea ? "Yes" : "No"}'),
            Text('Featured Status: ${featuredStatus ? "Yes" : "No"}'),
            SizedBox(height: 16),

            Text('Videos:'),
            ...videoUrl.map((url) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoPlayerWidget(videoUrl: url),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
