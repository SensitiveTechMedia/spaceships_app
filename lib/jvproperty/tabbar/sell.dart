
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/category/All.dart';

class selltab extends StatefulWidget {
  @override
  _selltabState createState() => _selltabState();
}
class _selltabState extends State<selltab> with TickerProviderStateMixin {
  Color customTeal = Color(0xFF071A4B);
  late TabController _tabController;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  final PageController _pageController = PageController();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tabWidth = (width - 90) / 2;
    return Scaffold(

      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorUtils.primaryColor(),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: RoundedRectIndicator(
                          color: Colors.white,
                          radius: 10,
                        ),
                        labelColor: ColorUtils.primaryColor(),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Sold'),
                          Tab(text: 'Unsold'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSoldScreen(),
            _buildUnsoldScreen(),
          ],
        ),
      ),

    );

  }


  Widget _buildSoldScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('propert') // Ensure the collection name is correct
                  .where('category', isEqualTo: 'Buy') // Filter by selected category
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
                          color: Color.fromRGBO(160, 161, 164, 1), // Corrected RGBA value
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
                                      : ClipRRect(
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
                                    child: Center(
                                      child: Text(
                                        wishlistItem['subcategory'] ?? 'Category',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
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

  Widget _buildUnsoldScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

Container(child: Text("ndndn"),),




          SizedBox(height: 50),
        ],
      ),


    );
  }
  AppBar _buildAppBar() {
    return AppBar(
title: Text("Sell tab"),
      actions: [

      ],
    );
  }






}

class RoundedRectIndicator extends Decoration {
  final BoxPainter _painter;

  RoundedRectIndicator({required Color color, required double radius})
      : _painter = _RoundedRectPainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _RoundedRectPainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _RoundedRectPainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Rect indicator = Rect.fromLTRB(
      rect.left - 85, // Adjust the left padding if necessary
      rect.top,
      rect.right +85, // Adjust the right padding if necessary
      rect.bottom,
    );
    final RRect rRect = RRect.fromRectAndRadius(indicator, Radius.circular(radius));
    canvas.drawRRect(rRect, _paint);
  }
}
