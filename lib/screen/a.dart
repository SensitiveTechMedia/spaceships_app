// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PropertyListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('jvform').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         // Assuming your data structure matches your Firestore document structure
//         List<DocumentSnapshot> documents = snapshot.data!.docs;
//
//         return ListView.separated(
//           itemCount: documents.length,
//           separatorBuilder: (context, index) => SizedBox(height: 10),
//           itemBuilder: (context, index) {
//             var data = documents[index].data() as Map<String, dynamic>;
//
//             return GestureDetector(
//               onTap: () async {
//                 // Handle onTap action
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[400]!),
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.0),
//                         color: Colors.blue, // Replace with your primary color
//                       ),
//                       alignment: Alignment.center,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Land Size: ${data['landSize']} of size'),
//                           Text('Approach Road Width: ${data['approachRoadWidth']}'),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width * 0.2,
//                           height: MediaQuery.of(context).size.width * 0.15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: NetworkImage(data['imageUrl'] ?? ''),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: data['imageUrl'] == null
//                               ? Icon(Icons.error, color: Colors.red) // Display an error icon if image fails to load
//                               : null,
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(
//                                       text: 'Landlord: ${data['ratioToLandlord']} ',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                         color: Colors.grey[800],
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: 'Ratio Builder: ${data['ratioToBuilder']}',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(
//                                       text: 'Goodwill: ${data['goodwill']}',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                         color: Colors.grey[800],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 4),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(
//                                       text: 'Refundable: ${data['refundableAdvance']} ',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                         color: Colors.grey[800],
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: data['cartcount'], // Assuming cartcount is part of your data
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 14,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(
//                                       text: "Distance: ",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12,
//                                         color: Colors.grey[800],
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: "${data['locationDistance']} km",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 14,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 2),
//                               RichText(
//                                 textAlign: TextAlign.center,
//                                 text: TextSpan(
//                                   text: "Status: ",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                     color: Colors.grey[800],
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: data['status'],
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Divider(
//                                 color: Colors.grey[400],
//                                 thickness: 2,
//                               ),
//                               SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('Terms and Conditions: ${data['termsAndConditions']}'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
