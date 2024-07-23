import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/Common/Constants/color_helper.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/jvproperty/addpropertyjvproperties.dart';
import 'package:spaceships/jvproperty/tabbar/inventory.dart';
import 'package:spaceships/jvproperty/tabbar/lease.dart';
import 'package:spaceships/jvproperty/tabbar/rent.dart';
import 'package:spaceships/jvproperty/tabbar/sell.dart';
import 'package:spaceships/screen/category/All.dart';


class PropertyInventory extends StatefulWidget {
  const PropertyInventory({Key? key}) : super(key: key);

  @override
  State<PropertyInventory> createState() => _PropertyInventoryState();
}

class _PropertyInventoryState extends State<PropertyInventory> {
  List<String> categories = ["Sell", "Lease", "Rent", "Inventory"];
  Color customTeal = Color(0xFF8F00FF);
  int _selectedIndex = 0;

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
        title: Text("Property Inventory",style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle, size: 38,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JvAddProperty()),
              );
              // Implement search functionality here
            },
          ),
        ],
      ),
    ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 25,),
      Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0), // Adjust horizontal padding as needed
      child: GestureDetector(
        onTap: () {

        },
        child: TextFormField(
          readOnly: true,
          onTap: () {

          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: GestureDetector(
              onTap: () {

              },
              child: Icon(Icons.search,  color: ColorUtils.primaryColor(),),
            ),
            suffixIcon: UnconstrainedBox(
              child: Row(
                children: [
                  Container(
                    width: 1,
                    color: ColorCodes.grey.withOpacity(0.4),
                  ),
                ],
              ),
            ),
            constraints: BoxConstraints(maxHeight: 80, maxWidth: double.infinity), // Ensure it takes full width
            contentPadding: EdgeInsets.only(top: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'Search ',
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: ColorUtils.primaryColor(),
            ),
          ),
        ),
      ),
    ),
    // GridView section
    Padding(
    padding: const EdgeInsets.all(2.0),
    child: GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4, // Number of tiles in each row
    mainAxisSpacing: 0.0, // Space between rows
    crossAxisSpacing: 0.0, // Space between columns
    childAspectRatio: 1.0, // Aspect ratio of each tile
    ),
    itemCount: categories.length,
    itemBuilder: (BuildContext context, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
    onTap: () {
    setState(() {
    _selectedIndex = index;
    });
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) {
    switch (index) {
    case 0:
    return selltab();
    case 1:
    return leasetab();
    case 2:
    return renttab();
    case 3:
    return inventorytab();
    default:
    return selltab();
    }
    },
    ),
    );
    },
    child: Card(
    color: isSelected? customTeal : customTeal,
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    CircleAvatar(
    backgroundColor: Colors.white, // White background
    child: Icon(
    index == 0
    ? Icons.all_inbox
        : index == 1
    ? Icons.home
        : index == 2
    ? Icons.home
        : Icons.apartment,
      color: ColorUtils.primaryColor(), // Teal colored icon
    size: 25.0,
    ),
    ),
    SizedBox(height: 8.0),
    Text(
    categories[index],
    style: TextStyle(
    color: isSelected? Colors.white : Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 15.0,
    ),
    ),
    ],
    ),
    ),
    ),
    );                  }),
    ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('propert').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: ColorUtils.primaryColor(),
                    size: 50,
                  ),
                );
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
                          builder: (context) => Vieage(
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
                                ),
                                child: wishlistItem['PropertyImages'] == null || wishlistItem['PropertyImages'].isEmpty
                                    ? Center(child: Icon(Icons.image, size: 50))
                                    : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
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
                                    ),
                                  ],
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