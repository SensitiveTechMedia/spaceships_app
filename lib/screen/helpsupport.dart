import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:spaceships/colorcode.dart';


class SupportScreen extends StatefulWidget {
  SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<String> items = [
    'Issue with An Property',
    'Issue with Refund',
    'Issue with Land',
    'Leave Feedback',
    'Others',
  ];
  String? selectedValue;
  TextEditingController description = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Get the current user
  }

  Future<void> _submitSupportRequest() async {
    if (selectedValue != null && description.text.isNotEmpty) {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Get the current user's UID
        String uid = _user?.uid ?? 'unknown';

        await firestore.collection('support').add({
          'issue': selectedValue,
          'comment': description.text,
          'status': 'Active', // Or true/false based on your requirement
          'submittedDate': DateTime.now(),
          'userUID': uid, // Store the UID
        });

        // Clear the form after submission
        setState(() {
          selectedValue = null;
          description.clear();
        });

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Support request submitted successfully')),
        );
      } catch (e) {
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit support request')),
        );
      }
    } else {
      // Optionally show a message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // If the user is not authenticated, show a message or redirect to login
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: AppBar(
              backgroundColor:  ColorUtils.primaryColor(), // Example app bar background color
              title: Text(
                "Help & Support",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          child: Text('Please log in to view this page.'),
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor:  ColorUtils.primaryColor(), // Example app bar background color
            title: Text(
              "Help & Support",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Select Issue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Enter Details',
                    hintText: 'Enter Details',
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _submitSupportRequest,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorUtils.primaryColor(),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space between the form and the list
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('support')
                    .where('userUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filter by userUID
                // .orderBy('submittedDate', descending: true) // Order by submittedDate
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data?.docs ?? [];

                  if (data.isEmpty) {
                    return Center(child: Text('No support requests found'));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final doc = data[index];
                      final issue = doc['issue'] as String;
                      final comment = doc['comment'] as String;
                      final status = doc['status'] as String;
                      final submittedDate = (doc['submittedDate'] as Timestamp).toDate();
                      final docId = doc.id;

                      // Format date
                      String createDay = DateFormat('dd').format(submittedDate);
                      String createMonth = DateFormat('MMMM').format(submittedDate);
                      String createHour = DateFormat('hh').format(submittedDate);
                      String createMinute = DateFormat('mm').format(submittedDate);
                      String createSeconds = DateFormat('ss').format(submittedDate);

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResponseScreen(
                                    docId: docId,
                                    issue: issue,
                                    submittedDate: submittedDate,
                                    status: status,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: ColorUtils.primaryColor(),
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Date: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  "$createDay $createMonth $createHour:$createMinute:$createSeconds",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Issue: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: issue,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Comment: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: comment,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: Colors.black),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Status: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: status,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorUtils.primaryColor(),
                                          border: Border.all(
                                            color: ColorUtils.primaryColor(),
                                            width: 3,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 7,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10), // Space between list items
                        ],
                      );
                    },
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}





class ResponseScreen extends StatefulWidget {
  final String docId;
  final String issue;
  final DateTime submittedDate;
  final String status;

  ResponseScreen({
    required this.docId,
    required this.issue,
    required this.submittedDate,
    required this.status,
  });

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  TextEditingController responseController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isUploading = false; // Add this variable to track upload status

  Future<void> _sendResponse() async {
    if (responseController.text.isNotEmpty || _image != null) {
      setState(() {
        _isUploading = true; // Set to true when upload starts
      });

      try {
        // Get the current user's UID
        String uid = auth.currentUser?.uid ?? 'unknown';

        // Upload the image if selected
        String? imageUrl;
        if (_image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('responses/${widget.docId}/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = storageRef.putFile(_image!);
          final snapshot = await uploadTask.whenComplete(() => {});
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        await firestore.collection('support').doc(widget.docId).collection('responses').add({
          'response': responseController.text,
          'respondedDate': DateTime.now(),
          'userUID': uid, // Store the UID
          'isClient': false, // Mark this as a user response
          'imageUrl': imageUrl, // Store the image URL if available
        });

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Response sent successfully')),
        );

        // Clear the text field and image
        responseController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send response')),
        );
      } finally {
        setState(() {
          _isUploading = false; // Set to false when upload finishes
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Automatically upload the image once it's picked
      if (_image != null) {
        await _sendResponse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String createDay = DateFormat('dd').format(widget.submittedDate);
    String createMonth = DateFormat('MMMM').format(widget.submittedDate);
    String createHour = DateFormat('hh').format(widget.submittedDate);
    String createMinute = DateFormat('mm').format(widget.submittedDate);
    String createSeconds = DateFormat('ss').format(widget.submittedDate);

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
            title: Text('Support Screen', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: $createDay $createMonth $createHour:$createMinute:$createSeconds",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Issue: ${widget.issue}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: firestore.collection('support').doc(widget.docId).collection('responses').orderBy('respondedDate').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(   child: LoadingAnimationWidget.inkDrop(
                                color: ColorUtils.primaryColor(),
                                size: 50,
                              ),);
                            }

                            return ListView(
                              children: snapshot.data!.docs.map((doc) {
                                bool isClient = doc['isClient'] ?? false;
                                bool isCurrentUser = doc['userUID'] == auth.currentUser?.uid;

                                return Align(
                                  alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser ? ColorUtils.primaryColor() : isClient ? Colors.green[100] : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (doc['response'] != null) Text(doc['response'], style: TextStyle(fontSize: 16,color: Colors.white)),
                                        if (doc['imageUrl'] != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 1.0),
                                            child: SizedBox(
                                              width: 200, // Set the desired width
                                              height: 200, // Set the desired height
                                              child: Image.network(
                                                doc['imageUrl'],
                                                width: 200,
                                                height: 80,
                                                fit: BoxFit.cover, // Use BoxFit.cover to fit the image within the given width and height
                                              ),
                                            ),
                                          ),

                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat('yyyy-MM-dd – kk:mm').format(doc['respondedDate'].toDate()),
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: responseController,
                        decoration: InputDecoration(
                          hintText: 'Type your response here...',hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          fillColor: ColorUtils.primaryColor(),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 10),
                            child: GestureDetector(
                              onTap: _isUploading ? null : _pickImage, // Disable picking image if uploading
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: _isUploading ? null : _sendResponse, // Disable sending response if uploading
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        enabled: !_isUploading, // Disable the text field if uploading
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
          if (_isUploading)
            Center(
              child: LoadingAnimationWidget.inkDrop(
                color: ColorUtils.primaryColor(),
                size: 50,
              ),
            ),
        ],
      ),
    );
  }
}


