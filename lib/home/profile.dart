import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> _getUserProfile() async {
    User? user = _auth.currentUser;
    return _firestore.collection('users').doc(user!.uid).get();
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Profile not found'));
          } else {
            var userData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (userData['imageUrl'] != null)
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(userData['imageUrl']),
                        ),
                      ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileRow('Name:', '${userData['name']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('Age:', '${userData['age']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('Gender:', '${userData['gender']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('Height:', '${userData['height']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('Weight:', '${userData['weight']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('History:', '${userData['history']}'),
                            SizedBox(height: 10),
                            _buildProfileRow('Lifestyle:', '${userData['lifestyle']}'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, // Set the button color to red
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                       // textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      child: Text('Logout', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}
