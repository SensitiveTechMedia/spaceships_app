import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/category/All.dart';
import 'package:spaceships/screen/filter.dart';
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
                  return Center(child: LoadingAnimationWidget.dotsTriangle(
                    color: ColorUtils.primaryColor(),
                    size: 50,
                  ),);
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
                            builder: (context) =>Vieage(
                              videoUrl: List<String>.from(wishlistItem['videos'] ?? []),
                              landmark: wishlistItem['landmark'] ?? '',
                              latitude: wishlistItem['latitude'] ?? '',
                              locationAddress: wishlistItem['locationaddress'] ?? '',
                              longitude: wishlistItem['longitude'] ?? '',
                              nearbyPlaces: List<Map<String, dynamic>>.from(wishlistItem['nearbyPlaces'] ?? []),
                              parkingIncluded: wishlistItem['parkingIncluded'] ?? '',
                              //         paymentType: wishlistItem[' paymentType'] ?? '',
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
                              dimension: wishlistItem['dimension']??'',
                              doorNo: wishlistItem['doorNo']??'',

                              floorType: wishlistItem['floorType']??'',
                              floorNumber: wishlistItem['floorNumber']??'',
                              furnishingType: wishlistItem['furnishingType']??'',
                              isCornerArea: wishlistItem['isCornerArea'] ?? false,
                              featuredStatus: wishlistItem['featuredStatus'] ?? false,
                              //
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
                              ),
                              child: wishlistItem['PropertyImages'] == null || wishlistItem['PropertyImages'].isEmpty
                                  ? Icon(Icons.image, size: 50)
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      wishlistItem['PropertyImages'][0],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: LoadingAnimationWidget.fourRotatingDots(
                                              color: ColorUtils.primaryColor(),
                                              size: 50,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(child: Icon(Icons.error));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                                  bottom: 8,
                                  left: 10,
                                  child: Container(
                                    width: 85,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorUtils.primaryColor(),
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



