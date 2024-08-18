import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../home/home_screen.dart';

class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _name, _age, _gender, _height, _weight, _history, _lifestyle;
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImageToFirebaseStorage() async {
    final user = _auth.currentUser;
    final storageRef = _storage.ref().child('profile_images/${user!.uid}.jpg');
    UploadTask uploadTask = storageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();
      final user = _auth.currentUser;
      final profileData = {
        'name': _name,
        'age': _age,
        'gender': _gender,
        'height': _height,
        'weight': _weight,
        'history': _history,
        'lifestyle': _lifestyle,
      };

      if (_image != null) {
        String imageUrl = await _uploadImageToFirebaseStorage();
        profileData['imageUrl'] = imageUrl;
      }

      await _firestore.collection('users').doc(user!.uid).set(profileData);

      setState(() {
        _isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (input) => input!.isEmpty ? 'Enter Name' : null,
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (input) => input!.isEmpty ? 'Enter Age' : null,
                onSaved: (input) => _age = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (input) => input!.isEmpty ? 'Enter Gender' : null,
                onSaved: (input) => _gender = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (input) => input!.isEmpty ? 'Enter Height' : null,
                onSaved: (input) => _height = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (input) => input!.isEmpty ? 'Enter Weight' : null,
                onSaved: (input) => _weight = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'History'),
                validator: (input) => input!.isEmpty ? 'Enter History' : null,
                onSaved: (input) => _history = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lifestyle'),
                validator: (input) => input!.isEmpty ? 'Enter Lifestyle' : null,
                onSaved: (input) => _lifestyle = input,
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(
                _image!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : Text('No image selected.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Profile Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
