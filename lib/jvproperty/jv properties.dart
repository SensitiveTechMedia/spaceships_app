import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaceships/colorcode.dart';


class JVPropertiesForm extends StatefulWidget {
  @override
  _JVPropertiesFormState createState() => _JVPropertiesFormState();
}

class _JVPropertiesFormState extends State<JVPropertiesForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor:   Theme.of(context).colorScheme.onPrimary,
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
        titleSpacing: 0,
        title: Text('JV Properties',style: TextStyle(color: Colors.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5.0),
                    Icon(Icons.add_circle, color: ColorUtils.primaryColor()),
                    SizedBox(width: 3.0),
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 16.0, color: ColorUtils.primaryColor()),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jvform')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Extract the list of documents from snapshot
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 20),
            child: ListView.separated(
              itemCount: documents.length,
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () async {
                    // Handle onTap action
                  },
                  child: Container(
                    padding: const EdgeInsets.only(),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.primaryColor(),),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),),
                            color:  ColorUtils.primaryColor(), // Replace with your primary color
                          ),
                          alignment: Alignment.center,
                          child: Row(
mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text('${data['ratioToBuilder']}% Share in',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.white),),
                              Text(' ${data[ 'landSize']} Sq. Ft.',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.white),),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 8),
                            Container(
                              width: 125,
                              height: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),),
                                image: DecorationImage(
                                  image: NetworkImage(data['imageUrl'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: data['imageUrl'] == null
                                  ? Icon(Icons.error, color: Colors.red) // Display an error icon if image fails to load
                                  : null,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     RichText(
                                  //       textAlign: TextAlign.center,
                                  //       text: TextSpan(
                                  //         text: 'Ratio to Landlord: ${data['ratioToLandlord']} ',
                                  //         style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 18,
                                  //           color: Colors.grey[800],
                                  //         ),
                                  //         children: [
                                  //
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(height: 4),


                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Goodwill: ${data['goodwill']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Road width: ${data['approachRoadWidth']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Site Dimension: ${data['']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'Refundable: ${data['refundableAdvance']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),


SizedBox(height: 15,),
                                  // Divider(
                                  //   color: Colors.grey[400],
                                  //   thickness: 2,
                                  // ),


                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),
                             bottomRight: Radius.circular(8.0),),
                            color: ColorUtils.primaryColor(), // Replace with your primary color
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text('Other Details: ${data['termsAndConditions']}',style: TextStyle(color: Colors.white),),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                );

              },

            ),
          );
        },
      ),
    );
  }
}


class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController landSizeController = TextEditingController();
  TextEditingController approachRoadWidthController = TextEditingController();
  TextEditingController ratioToLandlordController = TextEditingController();
  TextEditingController ratioToBuilderController = TextEditingController();
  TextEditingController goodwillController = TextEditingController();
  TextEditingController refundableAdvanceController = TextEditingController();
  TextEditingController termsAndConditionsController = TextEditingController();
  File? _imageFile; // Variable to hold the selected image file
  bool _isLoading = false; // Variable to track loading state

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Function to upload form data to Firestore
  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    String? uid = user?.uid;

    // Create a document reference for the form data
    DocumentReference formRef = await firestore.collection('jvform').add({
      'landSize': landSizeController.text,
      'approachRoadWidth': approachRoadWidthController.text,
      'ratioToLandlord': ratioToLandlordController.text,
      'ratioToBuilder': ratioToBuilderController.text,
      'goodwill': goodwillController.text,
      'refundableAdvance': refundableAdvanceController.text,
      'termsAndConditions': termsAndConditionsController.text,
      'imageUrl': '', // Placeholder for image URL
      'uid': uid,
    });

    // Upload image to Firebase Storage (if image is selected)
    if (_imageFile != null) {
      String imageName = formRef.id; // Use document ID as image name
      Reference storageRef = FirebaseStorage.instance.ref().child('images/$imageName');
      await storageRef.putFile(_imageFile!);
      String imageUrl = await storageRef.getDownloadURL();

      // Update Firestore document with image URL
      await formRef.update({'imageUrl': imageUrl});
    }

    setState(() {
      _isLoading = false;
    });

    // Navigate back to previous screen after submission (if needed)
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    landSizeController.dispose();
    approachRoadWidthController.dispose();
    ratioToLandlordController.dispose();
    ratioToBuilderController.dispose();
    goodwillController.dispose();
    refundableAdvanceController.dispose();
    termsAndConditionsController.dispose();
    super.dispose();
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
              backgroundColor: ColorUtils.primaryColor(), // Replace ColorUtils.primaryColor() with actual color
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Jv properties form',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: landSizeController,
                  decoration: InputDecoration(labelText: 'Land/Site Size'),
                ),
                TextField(
                  controller: approachRoadWidthController,
                  decoration: InputDecoration(labelText: 'Approach Road Width'),
                ),
                TextField(
                  controller: ratioToLandlordController,
                  decoration: InputDecoration(labelText: 'Ratio to Landlord'),
                ),
                TextField(
                  controller: ratioToBuilderController,
                  decoration: InputDecoration(labelText: 'Ratio to Builder'),
                ),
                TextField(
                  controller: goodwillController,
                  decoration: InputDecoration(labelText: 'Goodwill'),
                ),
                TextField(
                  controller: refundableAdvanceController,
                  decoration: InputDecoration(labelText: 'Refundable Advance'),
                ),
                TextField(
                  controller: termsAndConditionsController,
                  decoration: InputDecoration(
                    labelText: 'Any Other Terms and Conditions',
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  ColorUtils.primaryColor(),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: _pickImage,
                  child: Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  ColorUtils.primaryColor(),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


