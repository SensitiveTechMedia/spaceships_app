//
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:spaceships/colorcode.dart';
//
// import 'package:spaceships/screen/homeview/home.dart';
// import 'package:spaceships/screen/profileedit/profile%20page.dart';
// import 'package:spaceships/screen/wishlistfilter/whislist%20screen.dart';
//
//
//
// class FilterScreen extends StatefulWidget {
//   final Function(Map<String, dynamic> filters) onApplyFilters;
//
//   FilterScreen({
//     required this.onApplyFilters,
//   });
//
//   @override
//   _FilterScreenState createState() => _FilterScreenState();
// }
//
// class _FilterScreenState extends State<FilterScreen> {
//
//   List<String> selectedPropertyTypes = [];
//   List<String> selectedPropertyCategories = [];
//   List<String> selectedAmenities = [];
//   List<String> selectedFacingDirections = [];
//   List<String> selectedFurnishedStatuses = [];
//   List<String> selectedParkingOptions = [];
//
//   void _clearFilters() {
//     setState(() {
//       selectedPropertyTypes.clear();
//       selectedPropertyCategories.clear();
//       selectedAmenities.clear();
//       selectedFacingDirections.clear();
//       selectedFurnishedStatuses.clear();
//       selectedParkingOptions.clear();
//     });
//
//     // Apply empty filters to reset and fetch all properties
//     widget.onApplyFilters({
//       'propertyTypes': [],
//       'propertyCategories': [],
//       'amenities': [],
//       'facingDirections': [],
//       'furnishedStatuses': [],
//       'parkingOptions': [],
//     });
//   }
//
//   void _applyFilters() {
//     // Create the filters mapamen
//     Map<String, dynamic> filters = {
//       'propertyTypes': selectedPropertyTypes,
//       'propertyCategories': selectedPropertyCategories,
//       'amenities': selectedAmenities,
//       'facingDirections': selectedFacingDirections,
//       'furnishedStatuses': selectedFurnishedStatuses,
//       'parkingOptions': selectedParkingOptions,
//     };
//
//     // Apply selected filters and fetch filtered properties
//     widget.onApplyFilters(filters);
//
//     // Close the filter screen and navigate to filtered properties screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FilteredPropertiesScreen(
//           filters: filters,
//         ),
//       ),
//     );
//   }
//   int _selectedIndex = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white,),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
//             );
//
//           },
//         ),
//         backgroundColor: ColorUtils.primaryColor(),
//         title: Text('Filter Properties',style: TextStyle(color: Colors.white),),
//         actions: [
//           // TextButton(
//           //   onPressed: _applyFilters,
//           //   child: Text(
//           //     'Apply',
//           //     style: TextStyle(color: Colors.white),
//           //   ),
//           // ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildCheckboxList(
//               'Select Property Types',
//               ['Rent', 'Sell'],
//               selectedPropertyTypes,
//             ),
//             SizedBox(height: 16.0),
//             _buildCheckboxList(
//               'Select Property Categories',
//               ['Residential', 'Commercial'],
//               selectedPropertyCategories,
//             ),
//             SizedBox(height: 16.0),
//             _buildCheckboxList(
//               'Amenities',
//               [
//                 'Swimming Pool',
//                 'Gym',
//                 'Garden',
//                 'Lift',
//                 'Air Conditioner',
//                 'Intercom',
//                 'Child Play Area',
//                 'Gas Pipeline',
//                 'Servant Room',
//                 'Rainwater Harvesting',
//                 'House Keeping',
//                 'Visitor Parking',
//                 'Internet Service',
//                 'Club House',
//                 'Fire Safety',
//                 'Shopping Center',
//                 'Park',
//                 'Sewage Treatment',
//                 'Power Backup',
//                 'Water Storage',
//               ],
//               selectedAmenities,
//             ),
//             SizedBox(height: 16.0),
//             _buildCheckboxList(
//               'Select Facing Directions',
//               [
//                 'North', 'South', 'East', 'West', 'North East', 'South East', 'North West', 'South West',
//               ],
//               selectedFacingDirections,
//             ),
//             SizedBox(height: 16.0),
//             _buildCheckboxList(
//               'Select Furnished Statuses',
//               ['Furnished', 'Unfurnished', 'Semi-Furnished'],
//               selectedFurnishedStatuses,
//             ),
//             SizedBox(height: 16.0),
//             _buildCheckboxList(
//               'Select Parking Options',
//               ['Bike', 'Car'],
//               selectedParkingOptions,
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: _applyFilters,
//                   child: Text('Apply Filters', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
//                 ),
//                 ElevatedButton(
//                   onPressed: _clearFilters,
//                   child: Text('Clear Filters', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//       ),
//
//     );
//   }
//
//   Widget _buildCheckboxList(String title, List<String> options, List<String> selectedValues) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8.0),
//         Wrap(
//           spacing: 10.0,
//           runSpacing: 10.0,
//           children: options.map((option) {
//             return FilterChip(
//               label: Text(option),
//               selected: selectedValues.contains(option),
//               onSelected: (isSelected) {
//                 setState(() {
//                   if (isSelected) {
//                     selectedValues.add(option);
//                   } else {
//                     selectedValues.remove(option);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
//
// Future<List<Map<String, String>>> fetchFilteredProperties(Map<String, dynamic> filters) async {
//   CollectionReference properties = FirebaseFirestore.instance.collection('property');
//
//   Query query = properties;
//
//   // Apply a basic filter to reduce the initial dataset size
//   if (filters['propertyTypes'].isNotEmpty) {
//     query = query.where('property', whereIn: filters['propertyType']);
//   }
//   if (filters['propertyCategories'].isNotEmpty) {
//     query = query.where('propertyType', whereIn: filters['propertyCategories']);
//   }
//
//   QuerySnapshot querySnapshot = await query.get();
//
//   List<Map<String, String>> allProperties = querySnapshot.docs.map((doc) {
//     List<String> selectedAmenities = [];
//     if (doc['selectedAmenities'] is List) {
//       selectedAmenities = List<String>.from(doc['selectedAmenities']);
//     }
//
//     return {
//       'propertyId': doc.id, // Add propertyId here
//       'image': (doc['propertyImages'] is List && doc['propertyImages'].isNotEmpty)
//           ? doc['propertyImages'][0] as String
//           : 'https://via.placeholder.com/150',
//       'title': doc['propertyName'] as String,
//       'propertyType': doc['propertyType'] as String? ?? '',
//       'facingDirection': doc['selectedDirection'] as String? ?? '',
//       'furnishedStatus': doc['selectedFurnishedStatus'] as String? ?? '',
//       'parkingOption': doc['selectedParking'] as String? ?? '',
//       'plotSquareFeet': doc['plotSquareFeet']?.toString() ?? 'N/A',
//       'sittingRoom': doc['sittingRoom']?.toString() ?? 'N/A',
//       'balcony': doc['balcony']?.toString() ?? 'N/A',
//       'bathrooms': doc['bathrooms']?.toString() ?? 'N/A',
//       'kitchen': doc['kitchen']?.toString() ?? 'N/A',
//       'bedRooms': doc['bedRooms']?.toString() ?? 'N/A',
//       'numberOfToilets': doc['numberOfToilets']?.toString() ?? 'N/A',
//       'numberOfFloors': doc['numberOfFloors']?.toString() ?? 'N/A',
//       'latitude': doc['latitude']?.toString() ?? '0',
//       'longitude': doc['longitude']?.toString() ?? '0',
//       'selectedAmenities': selectedAmenities.join(', '),
//       'amount': doc['amount'] as String? ?? '',
//       'address': doc['address'] as String? ?? '',
//     };
//   }).toList();
//
//   // Perform additional filtering locally
//   List<Map<String, String>> filteredProperties = allProperties.where((property) {
//     bool matchesCategories = filters['propertyCategories'].isEmpty || filters['propertyCategories'].contains(property['propertyType']);
//     bool matchesFacingDirections = filters['facingDirections'].isEmpty || filters['facingDirections'].contains(property['facingDirection']);
//     bool matchesFurnishedStatuses = filters['furnishedStatuses'].isEmpty || filters['furnishedStatuses'].contains(property['furnishedStatus']);
//     bool matchesParkingOptions = filters['parkingOptions'].isEmpty || filters['parkingOptions'].contains(property['parkingOption']);
//     bool matchesAmenities = filters['amenities'].isEmpty || filters['amenities'].every((amenity) => property['selectedAmenities']?.contains(amenity) ?? false);
//
//     return matchesCategories && matchesFacingDirections && matchesFurnishedStatuses && matchesParkingOptions && matchesAmenities;
//   }).toList();
//   filteredProperties.forEach((property) {
//     print('Property Title: ${property['title']}, Property ID: ${property['propertyId']}');
//     print('Property Title: ${property['title']}, Property ID: ${property['propertyId']}, Square Feet: ${property['longitude']}');
//   });
//
//   return filteredProperties;
// }
//
// class FilteredPropertiesScreen extends StatelessWidget {
//   final Map<String, dynamic> filters;
//
//   FilteredPropertiesScreen({
//     required this.filters,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, String>>>(
//       future: fetchFilteredProperties(filters),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(backgroundColor:   ColorUtils.primaryColor(),
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white,),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
//                   );
//
//                 },
//               ),
//               title: Text('Filtered Properties',style: TextStyle(color: Colors.white),),
//             ),
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white,),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
//                   );
//
//                 },
//               ),
//               title: Text('Filtered Properties'),
//             ),
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white,),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
//                   );
//
//                 },
//               ),
//               backgroundColor:   ColorUtils.primaryColor(),
//               title: Text('Filtered Properties',style: TextStyle(color: Colors.white),),
//             ),
//             body: Center(
//               child: Text('No properties found.'),
//             ),
//           );
//         }
//
//         List<Map<String, String>> filteredProperties = snapshot.data!;
//
//         return Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white,),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen(username: '')),
//                 );
//
//               },
//             ),
//             backgroundColor:   ColorUtils.primaryColor(),
//             title: Text('Filtered Properties',style: TextStyle(color: Colors.white),),
//           ),
//           body: ListView.builder(
//             itemCount: filteredProperties.length,
//             itemBuilder: (context, index) {
//               var property = filteredProperties[index];
//
//
//               return ListTile(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                       builder: (context) => FilterPropertyDetailsViewScreen(property: property),
//                   ),
//                   );
//                 },
//                 title: Container(
//                   height: 150,
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(160, 161, 164, 1000),
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(width: 8),
//                       Stack(
//                         children: [
//                           Container(
//                             width: 140,
//                             height: 140,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20.0),
//                               color: Colors.grey,
//                               image: property['image'] != null && property['image']!.isNotEmpty
//                                   ? DecorationImage(
//                                 image: NetworkImage(property['image']!),
//                                 fit: BoxFit.cover,
//                               )
//                                   : null,
//                             ),
//                             child: property['image'] == null || property['image']!.isEmpty
//                                 ? Icon(Icons.image, size: 50)
//                                 : null,
//                           ),
//
//                         ],
//                       ),
//                       SizedBox(width: 15.0),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 20),
//                             FittedBox(
//                               fit: BoxFit.scaleDown,
//                               child: Text(
//                                 property['title'] ?? 'No Title',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color:  ColorUtils.primaryColor(),
//                                   fontSize: 24,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 4.0),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   color: ColorUtils.primaryColor(),
//                                   size: 20,
//                                 ),
//                                 FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   child: Text(
//                                     property['address'] ?? 'No Address',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: ColorUtils.primaryColor(),
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20.0),
//                             Text(
//                               '₹${property['amount'] ?? 'No Amount'}/month',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: ColorUtils.primaryColor(),
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
//
// class FilterPropertyDetailsViewScreen extends StatelessWidget {
//
//   final Map<String, dynamic> property;
//   FilterPropertyDetailsViewScreen({required this.property});
//   GoogleMapController? _mapController;
//
//   @override
//
//   Widget build(BuildContext context) {
//     LatLng propertyLocation = LatLng(
//       double.parse(property['latitude'] ?? '0'),
//       double.parse(property['longitude'] ?? '0'),
//     );
//     String formatDate(String? dateString) {
//       if (dateString == null) {
//         return 'No date provided';
//       }
//       try {
//         DateTime date = DateTime.parse(dateString);
//         return DateFormat('yyyy-MM-dd').format(date);
//       } catch (e) {
//         return 'Invalid date';  // Handle any parsing errors
//       }
//     }
//
//
//     bool isInWishlist = false;
//     List<String> amenities = [];
//     return Scaffold(
//
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//
//                Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   height: 500,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.0),
//                     color: Colors.grey,
//                     image: property['image'] != null && property['image']!.isNotEmpty
//                         ? DecorationImage(
//                       image: NetworkImage(property['image']!),
//                       fit: BoxFit.cover,
//                     )
//                         : null,
//                   ),
//                   child: property['image'] == null || property['image']!.isEmpty
//                       ? Icon(Icons.image, size: 50)
//                       : null,
//                 ),
//               ),
//                 Positioned(
//                   bottom: 30,
//                   left: 40,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: ColorUtils.primaryColor(), // Green background color
//                       borderRadius: BorderRadius.circular(20.0), // Border radius
//                     ),
//                     child: Text(
//                       property['title'] ?? 'No Title',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white, // Text color
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 20,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: CircleAvatar(
//                       radius: 25,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         size: 25,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 16,
//                   child: Row(
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 25,
//                         backgroundColor: Colors.white,
//                         child: IconButton(
//                           onPressed: () {
//                             // Handle share action
//                           },
//                           icon: SvgPicture.asset(
//                             'assets/images/ShareIcon.svg',
//                             width: 24,
//                             height: 24,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 25),
//                       CircleAvatar(
//                         radius: 25,
//                         backgroundColor: isInWishlist ? Colors.red : Colors.green,
//                         child: IconButton(
//                           onPressed: () {
//                             // saveToWishlist();
//                           },
//                           icon: SvgPicture.asset(
//                             'assets/images/HeartIcon.svg',
//                             width: 24,
//                             height: 24,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//       ]
//             ),
//             SizedBox(height: 20.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       property['title'] ?? 'No Title',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: ColorUtils.primaryColor(),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       ' ${property['amount'] ?? 'No Amount'}',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: ColorUtils.primaryColor(),
//                       ),
//                       textAlign: TextAlign.right,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(width: 18),
//                 Icon(
//                   Icons.location_on,
//                   color: ColorUtils.primaryColor(),
//                   size: 20,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 5),
//                     child: Text(
//                       property['address'] ?? 'No Address',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: ColorUtils.primaryColor(),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(right: 20),
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       "per month",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: ColorUtils.primaryColor(),
//                       ),
//                       textAlign: TextAlign.right,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 10),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Center(
//                 child: Container(
//                   width: double.infinity,
//                   child: Divider(
//                     height: 15,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: EdgeInsets.all(10), // Adjust the amount of outer padding as needed
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.2), // Adjust opacity as needed
//                   borderRadius: BorderRadius.circular(10), // Adjust radius as needed
//                 ),
//                 padding: EdgeInsets.all(15), // Add padding for space around the container content
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey,
//                       child:  Image.asset(
//                         "assets/images/logos.png",
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//
//
//                     SizedBox(width: 25),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child:SvgPicture.asset(
//                         'assets/images/ChatIcon.svg',
//                         width: 40,  // Adjust width and height as needed
//                         height: 34,
//                       ),
//
//                     ),
//                     Expanded(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 8),
//                             child: Text(
//                               "Chat with Support",style: TextStyle( color: ColorUtils.primaryColor(),fontSize: 18,),
//                             ),
//                           ),
//
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   // Sitting Room Container
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/sofa.svg', // Path to sitting room SVG asset
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['sittingRoom'] ?? 't',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Bathroom Container
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/balcony.svg', // Path to bathroom SVG asset
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['balcony'] ?? '',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/kitchen.svg',
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['kitchen'] ?? 'No Address',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Another Bed Container
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/Bed.svg', // Path to bathroom SVG asset
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['bedRooms'] ?? 'No Addess',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   //
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/BathRoom.svg', // Path to bathroom SVG asset
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['bathrooms'] ?? 'No Address',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/images/toilet.svg', // Path to bathroom SVG asset
//                             width: 24,
//                             height: 24,
//                             color: Color.fromRGBO(139, 200, 62, 1.0),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             property['numberOfToilets'] ?? 'No Address',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Container(
//                 child: Text("Location details",style: TextStyle(fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: ColorUtils.primaryColor(),),),
//               ),
//             ),
//
//             Padding(
//               padding: EdgeInsets.only(left: 10.0, right: 10.0),
//               child: Container(
//                 width: 300,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: propertyLocation,
//                       zoom: 15,
//                     ),
//                     markers: {
//                       Marker(
//                         markerId: MarkerId('property_location'),
//                         position: propertyLocation,
//                       ),
//                     },
//                     onMapCreated: (GoogleMapController controller) {
//                       _mapController = controller;
//                     },
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Container(
//                 child: Text("Amenties",style: TextStyle(fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: ColorUtils.primaryColor(),),),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   // Displaying fetched amenities
//                   for (String selectedAmenity in property['selectedAmenities'].split(','))
//                     Padding(
//                       padding: EdgeInsets.only(left: 10),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: ColorUtils.primaryColor(),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: Center(
//                           child: Text(
//                             selectedAmenity.trim(), // Ensure to trim whitespace
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   border: Border.all(
//                     color: Colors.grey, // You can adjust border color here
//                     width: 1.0,
//                   ),
//                 ),
//                 child: DataTable(
//                   columnSpacing: 10.0,
//                   columns: [
//                     DataColumn(
//                       label: Text(
//                         'Detail',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorUtils.primaryColor(),),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Value',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                       ),
//                     ),
//                   ],
//                   rows: [
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Squarefeet :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             ' ${property['plotSquareFeet'] ?? 'Not specified'}',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Furnished Status :',
//                             style: TextStyle(fontSize:19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             ' ${property['furnishedStatus'] ?? 'Not specified'}',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Parking option :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             ' ${property['parkingOption'] ?? 'Not specified'}',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Facing Direction :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             ' ${property['facingDirection'] ?? 'Not specified'}',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Gated Comunity :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             property['GatedCommunity'] == true ? 'Yes' : 'No',  // Or replace 'No' with any default value you want
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//
//
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Possession Status :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text('${property['possessionStatus'] ??'Under Construction'}',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Available from:',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             formatDate(property['selectedDate']),
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Show Pricing As :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             property['ShowPriceAs'] == true ? 'Negotiable' : 'Call for Pricing',  // Or replace 'No' with any default value you want
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                     DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             'Tranasction Type :',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                         DataCell(
//     Text(  property['ShowPriceAs'] == true ?  'New property' : 'Resale',
//                             style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,  color: ColorUtils.primaryColor(),),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height:100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.0),
//                   color: Colors.grey,
//                   image: property['image'] != null && property['image']!.isNotEmpty
//                       ? DecorationImage(
//                     image: NetworkImage(property['image']!),
//                     fit: BoxFit.cover,
//                   )
//                       : null,
//                 ),
//                 child: property['image'] == null || property['image']!.isEmpty
//                     ? Icon(Icons.image, size: 50)
//                     : null,
//               ),
//             ),
//
//
//
//
//             SizedBox(height: 8.0),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:spaceships/screen/filter.dart';

class Screen extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const Screen({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<Screen> {
  String selectedOption = '';

  // Track selection states
  bool buySelected = false;
  bool rentSelected = false;
  List<String> propertyTypeSelected = [];
  List<String> furnishedStatusSelected = [];
  List<String> selectedAmenities = [];
  String selectedDirection = '';
  List<String> selectedParking = [];

  final List<String> amenities = [
    'Swimming Pool',
    'Gym',
    'Garden',
    'Lift',
    'Air Conditioner',
    'Intercom',
    'Child Play Area',
    'Gas Pipeline',
    'Servant Room',
    'Rainwater Harvesting',
    'House Keeping',
    'Visitor Parking',
    'Internet Service',
    'Club House',
    'Fire Safety',
    'Shopping Center',
    'Park',
    'Sewage Treatment',
    'Power Backup',
    'Water Storage',
  ];

  final List<String> directions = [
    'North',
    'South',
    'East',
    'West',
    'North East',
    'South East',
    'North West',
    'South West',
  ];

  final List<String> parkingOptions = [
    'Bike',
    'Car',
  ];

  void _clearFilters() {
    setState(() {
      buySelected = false;
      rentSelected = false;
      propertyTypeSelected.clear();
      furnishedStatusSelected.clear();
      selectedAmenities.clear();
      selectedDirection = '';
      selectedParking.clear();
    });
    widget.onApplyFilters({
      'propertyTypes': [],
      'propertyCategories': [],
      'amenities': [],
      'facingDirections': [],
      'furnishedStatuses': [],
      'parkingOptions': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Page'),
      ),
      body: Row(
        children: <Widget>[
          // Left side with grey background
          Container(
            color: Colors.grey.shade300,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Property';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 35.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Property' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Text('Property', style: TextStyle(fontSize: 17)),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Property Type';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Property Type' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Property Type', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Furnished status';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Furnished status' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Furnished status', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Amenities';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Amenities' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Amenities', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Direction';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Direction' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Direction', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Parking';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      color: selectedOption == 'Parking' ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                    ),
                    child: Center(child: Text('Parking', style: TextStyle(fontSize: 17))),
                  ),
                ),
                VerticalDivider(thickness: 5),
                Expanded(child: SizedBox()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Apply Filters', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                    ),
                    ElevatedButton(
                      onPressed: _clearFilters,
                      child: Text('Clear Filters', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1),
          // Right side with white background
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildRightSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    if (selectedOption == 'Property') {
      return _buildPropertySection();
    } else if (selectedOption == 'Property Type') {
      return _buildPropertyTypeSection();
    } else if (selectedOption == 'Furnished status') {
      return _buildFurnishedStatusSection();
    } else if (selectedOption == 'Amenities') {
      return _buildAmenitiesSection();
    } else if (selectedOption == 'Direction') {
      return _buildDirectionSection();
    } else if (selectedOption == 'Parking') {
      return _buildParkingSection();
    } else {
      return Center(child: Text('Select the required'));
    }
  }

  Widget _buildPropertySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              buySelected = !buySelected;
              if (buySelected) rentSelected = false;
            });
          },
          child: Row(
            children: [
              Icon(buySelected ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text('Buy', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              rentSelected = !rentSelected;
              if (rentSelected) buySelected = false;
            });
          },
          child: Row(
            children: [
              Icon(rentSelected ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text('Rent', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildPropertyTypeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildPropertyTypeOption('Home'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildPropertyTypeOption('Villa'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildPropertyTypeOption('Apartment'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildPropertyTypeOption('PG'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildPropertyTypeOption('Office'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildPropertyTypeOption(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (propertyTypeSelected.contains(type)) {
            propertyTypeSelected.remove(type);
          } else {
            propertyTypeSelected = [type];
          }
        });
      },
      child: Row(
        children: [
          Icon(propertyTypeSelected.contains(type) ? Icons.check_box : Icons.check_box_outline_blank),
          SizedBox(width: 8),
          Text(type, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFurnishedStatusSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFurnishedStatusOption('Furnished'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildFurnishedStatusOption('Unfurnished'),
        SizedBox(height: 5),
        Divider(
          height: 10,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        _buildFurnishedStatusOption('Semi-furnished'),
      ],
    );
  }

  Widget _buildFurnishedStatusOption(String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (furnishedStatusSelected.contains(status)) {
            furnishedStatusSelected.remove(status);
          } else {
            furnishedStatusSelected = [status];
          }
        });
      },
      child: Row(
        children: [
          Icon(furnishedStatusSelected.contains(status) ? Icons.check_box : Icons.check_box_outline_blank),
          SizedBox(width: 8),
          Text(status, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return ListView.builder(
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedAmenities.contains(amenities[index])) {
                selectedAmenities.remove(amenities[index]);
              } else {
                selectedAmenities.add(amenities[index]);
              }
            });
          },
          child: Row(
            children: [
              Icon(selectedAmenities.contains(amenities[index]) ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(amenities[index], style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirectionSection() {
    return ListView.builder(
      itemCount: directions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDirection = directions[index];
            });
          },
          child: Row(
            children: [
              Icon(selectedDirection == directions[index] ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(directions[index], style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParkingSection() {
    return ListView.builder(
      itemCount: parkingOptions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedParking.contains(parkingOptions[index])) {
                selectedParking.remove(parkingOptions[index]);
              } else {
                selectedParking.add(parkingOptions[index]);
              }
            });
          },
          child: Row(
            children: [
              Icon(selectedParking.contains(parkingOptions[index]) ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Text(parkingOptions[index], style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    Map<String, dynamic> filters = {
      'propertyTypes': propertyTypeSelected,
      'amenities': selectedAmenities,
      'furnishedStatuses': furnishedStatusSelected,
      'facingDirections': [selectedDirection],
      'parkingOptions': selectedParking,
    };
    widget.onApplyFilters(filters);

    // Close the filter screen and navigate to filtered properties screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FilteredPropertiesScreen(
    //       filters: filters,
    //     ),
    //   ),
    // );
  }
}
