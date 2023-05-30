import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_with_mee/auth/login_screen.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({Key? key}) : super(key: key);

  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
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
    final String displayName = user?.displayName ?? 'Anonymous';

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
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
                  : const AssetImage('assets/avatar.jpg'),
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
            'Kingsley Chibona',
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
            leading: Icon(Icons.location_on),
            title: Text('Kabwe, Zambia'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
