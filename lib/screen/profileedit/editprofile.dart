import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaceships/Common/Widgets/app_bar.dart';
import 'package:spaceships/colorcode.dart';
import '../../Common/Constants/color_helper.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _image;
  String _userName = "";
  String _userEmail = "";
  String _userImage = '';
  String  _usermobile ='';
  @override

  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            _userName = userData['name'];
            _userEmail = userData['email'];
            _userImage = userData['profile_picture'];
            _usermobile = userData['number'];

          });
          nameController.text = _userName;
          emailController.text = _userEmail;
          numberController.text=_usermobile;
        } else {
          print("User data not found");
        }
      } else {
        print("User not logged in");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
  void _openImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      try {
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await storageSnapshot.ref.getDownloadURL();

        // Update user profile with download URL
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'profile_picture': downloadUrl,
          });
          setState(() {
            _image = imageFile;
          });

          // Show SnackBar message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile picture updated successfully"),
          ));
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: NavBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
        
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 56,
                      backgroundImage: NetworkImage(_userImage),
                      // Use a default image if the user's profile picture is not available
                      child: _userImage.isEmpty
                          ? Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'hi',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _openImagePicker(); // Function to open image picker
                        },
                        child: CircleAvatar(
                          maxRadius: 17,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: CircleAvatar(
                            maxRadius: 15,
                            child: Icon(
                              Icons.edit_rounded,
                              size: 17,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              SizedBox(
                height: height * 0.03,
              ),
              TextFormField(
                onChanged: (value) {},
                controller: nameController,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: GradientOutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [ColorCodes.green, ColorCodes.teal],
                    ),
                    width: 2,
                  ),
                  hintText: "Full Name",
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number';
                  }
                  return null;
                },
                controller: numberController,
                keyboardType: TextInputType.phone,
                onChanged: (value) {},
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.call_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: GradientOutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [ColorCodes.green, ColorCodes.teal],
                    ),
                    width: 2,
                  ),
                  hintText: "Enter Number",
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                onChanged: (value) {},
                controller: emailController,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                 suffixIcon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: GradientOutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [ColorCodes.green, ColorCodes.teal],
                    ),
                    width: 2,
                  ),
                  hintText: "Email",
                ),
              ),
        
           const SizedBox(height: 80,),
              Center(
                child: SizedBox(
                  width: 200, // Set your desired width
                  height: 50, // Set your desired height
                  child: ElevatedButton(
                    onPressed: () async {
                      // Get the current user
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          // Update user data in Firestore
                          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                            'name': nameController.text,
                            'number': numberController.text,
                            'email': emailController.text,
                            // Update the 'createdAt' field with the current timestamp
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Profile updated successfully"),
                          ));
                        } catch (e) {
                          print("Error updating profile: $e");
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Failed to update profile"),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("User not logged in"),
                        ));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(   ColorUtils.primaryColor(),), // Set button color
                    ),
                    child: const Text("Save",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
        
        
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }
}
