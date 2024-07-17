
import 'package:flutter/material.dart';
import 'package:spaceships/colorcode.dart';

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





        ],
      ),




    );
  }

  Widget _buildUnsoldScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [






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
