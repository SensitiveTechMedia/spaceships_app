import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spaceships/colorcode.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<String> items = [
    'Issue with An Property',
    'Issue with Refund',
    'Issue with Booking property',
    'Leave Feedback'
  ];
  String? selectedValue;
  TextEditingController description = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _submitSupportRequest() async {
    if (selectedValue != null && description.text.isNotEmpty) {
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Get the current user's UID
        String uid = auth.currentUser?.uid ?? 'unknown';

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
                    .orderBy('submittedDate', descending: true) // Order by date
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
                      final userUID = doc['userUID'] as String;
                      final docId = doc.id;
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
    ),),
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

  Future<void> _sendResponse() async {
    if (responseController.text.isNotEmpty) {
      try {
        // Get the current user's UID
        String uid = auth.currentUser?.uid ?? 'unknown';

        await firestore.collection('support').doc(widget.docId).collection('responses').add({
          'response': responseController.text,
          'respondedDate': DateTime.now(),
          'userUID': uid, // Store the UID
        });

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Response sent successfully')),
        );

        // Clear the text field
        responseController.clear();
      } catch (e) {
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send response')),
        );
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
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor(), // Example app bar background color
        title: Text(
          "Support Screen",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                          return Center(child: CircularProgressIndicator());
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((doc) {
                            bool isCurrentUser = doc['userUID'] == auth.currentUser?.uid;
                            return Align(
                              alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isCurrentUser ? Colors.blue[100] : Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['response'], style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 5),
                                    Text(
                                      DateFormat('yyyy-MM-dd – kk:mm').format(doc['respondedDate'].toDate()),
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: responseController,
                    decoration: InputDecoration(
                      labelText: 'Type your response here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendResponse,
                  child: Container(
                    width: 100,
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorUtils.primaryColor(),
                    ),
                    child: Center(
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
