import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/homeview/home.dart';
import 'package:spaceships/screen/profileedit/editprofile.dart';
import 'package:spaceships/screen/search%20screen.dart';
import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart';


import '../../Controller/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ThemeController themeController = Get.put(ThemeController());
  User? _user;

  String _userName = '';
  String _userEmail = '';
  String _userImage = '';
  int _selectedIndex = 3;
  @override
  void initState() {
    super.initState();
    // getUser();
  }
  void _navigateToSearchScreen(BuildContext context) {
    // Navigate to SearchScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    // Navigate to SearchScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen(username: '',)),
    );
  }

  void _navigateToWishlistScreen(BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WishlistScreen()),
    );
  }
  void navigateToProfileScreen (BuildContext context) {
    // Navigate to WishlistScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? '')),
    );
  }
  // Future<void> getUser() async {
  //   try {
  //     _user = FirebaseAuth.instance.currentUser;
  //     if (_user != null) {
  //       final userData = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
  //       if (userData.exists) {
  //         setState(() {
  //           _userName = userData['name'];
  //           _userEmail = userData['email'];
  //           _userImage = userData['profile_picture'];
  //
  //           // Add a print statement to check the _userImage variable
  //           print("Profile picture URL: $_userImage");
  //         });
  //       } else {
  //         print("User data not found");
  //       }
  //     } else {
  //       print("User not logged in");
  //     }
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //   }
  // }








  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(username: '')),
      );
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.1,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:  ColorUtils.primaryColor(),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              themeController.toggleTheme();
            },
            child: CircleAvatar(
              maxRadius: 23,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: themeController.isDarkMode.value
                  ? Icon(
                Icons.brightness_2,
                color:  ColorUtils.primaryColor(),
              )
                  : Icon(
                Icons.sunny,
                color:  ColorUtils.primaryColor(),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.035,
          ),
          CircleAvatar(
            maxRadius: 23,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            child: SvgPicture.asset(
              "assets/images/Setting.svg",
              color:  ColorUtils.primaryColor(),
            ),
          ),
          SizedBox(
            width: width * 0.035,
          ),
        ],
      ),
      body:StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return Center(child: Text("User not found"));
      }

      final userData = snapshot.data!;
      _userName = userData['name'] ?? '';
      _userEmail = userData['email'] ?? '';
      _userImage = userData['avatarUrl'] ?? '';
      return DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 350,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                scrolledUnderElevation: 0.1,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorUtils.primaryColor(),
                            maxRadius: 56,
                            backgroundImage: NetworkImage(_userImage),
                            // Use a default image if the user's profile picture is not available
                            child: _userImage.isEmpty
                                ? Text(
                              _userName.isNotEmpty
                                  ? _userName[0].toUpperCase()
                                  : 'hi',
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            )
                                : null,
                          ),


                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (
                                      context) => const EditProfileScreen()),
                                );
                              },
                              child: CircleAvatar(
                                maxRadius: 17,
                                backgroundColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .surface,
                                child: CircleAvatar(
                                  backgroundColor: ColorUtils.primaryColor(),
                                  maxRadius: 15,
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 17,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .surface,
                                  ),
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                      ),
                      Text(
                        _userEmail,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                      ),


                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: width * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorUtils.primaryColor(),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "30",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ColorUtils.primaryColor(),
                                    ),
                                  ),
                                  Text(
                                    "Listings",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: ColorUtils.primaryColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorUtils.primaryColor(),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ColorUtils.primaryColor(),
                                    ),
                                  ),
                                  Text(
                                    "Sold",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: ColorUtils.primaryColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(Routes.allReviewScreen);
                            },
                            child: Container(
                              width: width * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorUtils.primaryColor(),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      "28",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorUtils.primaryColor(),
                                      ),
                                    ),
                                    Text(
                                      "Reviews",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: ColorUtils.primaryColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(15),
                  child: Container(
                    width: width * 0.95,
                    height: height * 0.08,
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 15),
                      child: TabBar(
                        overlayColor: WidgetStateProperty.all<Color>(
                          ColorUtils.primaryColor(),
                        ),
                        indicator: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surface,
                        ),
                        indicatorWeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        indicatorColor: Colors.white,
                        labelColor: ColorUtils.primaryColor(),
                        unselectedLabelColor: Theme
                            .of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        tabs: const [
                          Tab(text: 'Transaction'),
                          Tab(text: 'Listings'),
                          Tab(text: 'Sold'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: const SingleChildScrollView(
            child: Text("hdhdh"),
          ),

        ),
      );
      bottomNavigationBar:
      Container(
        color: const Color.fromRGBO(143, 0, 255, 1.0),
        height: 55,
        child: FlashyTabBar(
          backgroundColor: const Color.fromRGBO(143, 0, 255, 1.0).withOpacity(
              0),
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) {
            if (index == 3) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileScreen(email: FirebaseAuth.instance.currentUser?.email ?? ''),
              //   ),
              // );
            } else {
              setState(() {
                _selectedIndex = index;
                switch (_selectedIndex) {
                  case 0:
                    _navigateToHomeScreen(context);
                  case 1:
                    _navigateToSearchScreen(context);
                    break;
                  case 2:
                    _navigateToWishlistScreen(context);
                    break;
                  case 3:
                  // navigateToProfileScreen(context);
                    break;
                  default:
                    break;
                }
              });
            }
          },
          items: [
            FlashyTabBarItem(
              icon: SvgPicture.asset(
                "assets/images/Subtract.svg",
                height: 24,
                color: Colors.white,
              ),
              // inactiveColor: Colors.white,
              title: const Text(""),
              activeColor: Colors.white,

            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: SvgPicture.asset(
                height: 24,
                "assets/images/SearchIcon.svg",
                color: Colors.white,
              ),
              inactiveColor: Colors.white,
              title: const Text(""),

            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: SvgPicture.asset(
                "assets/images/Heart.svg",
                height: 24,

                color: Colors.white,
              ),
              inactiveColor: Colors.white,
              title: const Text(""),

            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: SvgPicture.asset(
                "assets/images/ProfileIcon.svg",
                height: 34,

                color: Colors.white,
              ),
              inactiveColor: Colors.white,

              title: const Text(""),

            ),
          ],
        ),
      );
    }

    ),

    ),
      );
  }
}
