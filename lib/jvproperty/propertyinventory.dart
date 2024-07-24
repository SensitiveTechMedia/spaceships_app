import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/Common/Constants/color_helper.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/jvproperty/addpropertyjvproperties.dart';
import 'package:spaceships/jvproperty/tabbar/inventory.dart';
import 'package:spaceships/screen/category/All.dart';

class PropertyInventory extends StatefulWidget {
  @override
  State<PropertyInventory> createState() => _PropertyInventoryState();
}

class _PropertyInventoryState extends State<PropertyInventory> with TickerProviderStateMixin {
  List<String> categories = ["Inventory","Sell", "Lease", "Rent" ];
  Color customTeal = Color(0xFF8F00FF);
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabLength(_selectedIndex), vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getTabLength(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
      case 1:
      case 2:
      case 3:
        return 2;
      default:
        return 0;
    }
  }

  List<Widget> _buildTabs() {
    switch (_selectedIndex) {
      case 0:
        return [Tab(text: 'Inventory out'), Tab(text: 'Pending')];

      case 1:
        return [Tab(text: 'Sold'), Tab(text: 'Unsold')];

      case 2:
        return [Tab(text: 'Leaseout'), Tab(text: 'Pending')];

      case 3:
        return [Tab(text: 'Rent Out'), Tab(text: 'Pending')];
      default:
        return [];
    }
  }

  List<Widget> _buildTabViews() {
    switch (_selectedIndex) {
      case 0:
        return [_buildPropertyList('Inventory out'), _buildPropertyList('Pending')];
      case 1:

        return [_buildSoldScreen('Sold'), _buildPropertyList('Unsold')];
      case 2:

        return [_buildPropertyList('Leaseout'), _buildPropertyList('Pending')];
      case 3:
        return [_buildPropertyList('Rent Out'), _buildPropertyList('Pending')];

      default:
        return [];
    }
  }
  Widget _buildSoldScreen(String category) {
    print('Selected Category: $category');
    if (category != 'Buy' && category != 'Sold') {
      return Center(child: Text('Invalid category'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('propert')
                .where('category', isEqualTo: "Buy") // Use dynamic category
                .snapshots(),
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
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No properties found'));
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  var wishlistItem = doc.data() as Map<String, dynamic>;

                  return Container(

                    child: ListTile(
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
                            // Display images
                            Container(
                              width: 140,
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (wishlistItem['PropertyImages'] as List).length,
                                itemBuilder: (context, imgIndex) {
                                  return Container(
                                    width: 140,
                                    height: 140,
                                    margin: EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
                                        wishlistItem['PropertyImages'][imgIndex],
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
                                  );
                                },
                              ),
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

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }





  Widget _buildPropertyList(String subcategory) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('propert')
          .where('category', isEqualTo: categories[_selectedIndex])

          .snapshots(),
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
    );
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
            title: Text(
              "Property Inventory",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 38,
                ),
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
          SizedBox(height: 25),
          // Padding(
          //   padding: EdgeInsets.only(left: 15.0, right: 15.0), // Adjust horizontal padding as needed
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: TextFormField(
          //       readOnly: true,
          //       onTap: () {},
          //       decoration: InputDecoration(
          //         filled: true,
          //         fillColor: Theme.of(context).colorScheme.onPrimary,
          //         border: OutlineInputBorder(
          //           borderSide: BorderSide.none,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         prefixIcon: GestureDetector(
          //           onTap: () {},
          //           child: Icon(
          //             Icons.search,
          //             color: ColorUtils.primaryColor(),
          //           ),
          //         ),
          //         suffixIcon: UnconstrainedBox(
          //           child: Row(
          //             children: [
          //               Container(
          //                 width: 1,
          //                 color: ColorCodes.grey.withOpacity(0.4),
          //               ),
          //             ],
          //           ),
          //         ),
          //         constraints: BoxConstraints(maxHeight: 80, maxWidth: double.infinity), // Ensure it takes full width
          //         contentPadding: EdgeInsets.only(top: 10),
          //         focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           borderSide: BorderSide.none,
          //         ),
          //         hintText: 'Search ',
          //         hintStyle: TextStyle(
          //           fontWeight: FontWeight.w300,
          //           fontSize: 14,
          //           color: ColorUtils.primaryColor(),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: List.generate(categories.length, (index) {
                  bool isSelected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _tabController.dispose();
                        _tabController = TabController(length: _getTabLength(_selectedIndex), vsync: this);
                        _tabController.index = 0; // Reset to first tab on category change
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 80,
                      margin: EdgeInsets.symmetric(horizontal: 5),
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
                            index == 0
                                ? Icons.all_inbox
                                : index == 1
                                ? Icons.apartment
                                : index == 2
                                ? Icons.home
                                : index == 3
                                ? Icons.landscape
                                : index == 4
                                ? Icons.home_max_rounded
                                : Icons.villa,
                            color: isSelected ? Colors.white : customTeal,
                          ),
                          SizedBox(height: 5),
                          Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white : customTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          if (_selectedIndex < categories.length)
            SizedBox(height: 10,),
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: _buildTabs(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: ColorUtils.primaryColor(),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54, // Ensures no underline is present// Unselected text color
                ),

                SizedBox(height: 10,),
                Container(
                  height: 450, // Adjust the height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: _buildTabViews(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
