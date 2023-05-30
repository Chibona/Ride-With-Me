import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_with_mee/auth/login_screen.dart';

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({Key? key}) : super(key: key);

  @override
  _UserProfileTabState createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String displayName = 'Anonymous';

    // Check if the user is authenticated and has a display name
    if (user != null && user.displayName != null) {
      displayName = user.displayName!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Text(''),
        title: const Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              });
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 195, 228, 226),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Choose an option'),
                  actions: [
                    TextButton(
                      child: const Text('Take Photo'),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    TextButton(
                      child: const Text('Choose from Gallery'),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              );
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!) as ImageProvider<Object>?
                  : AssetImage('assets/avatar.jpg'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Software Engineer',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text('0987654321'),
          ),
          const ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('New York, USA'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
