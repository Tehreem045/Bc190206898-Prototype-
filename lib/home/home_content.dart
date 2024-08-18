import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        title: Text('Autism Support Companion' , style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome to Autism Support Companion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Recommendations Based on Play Store Apps'),
            _buildRecommendationCard(
              'Effective Communication Strategies',
              'Explore apps that offer strategies for improving communication between parents and children. These apps provide tools like visual schedules, social stories, and communication boards to help facilitate better understanding.',
              Icons.chat,
            ),
            _buildRecommendationCard(
              'Interactive Communication Exercises',
              'Discover apps with interactive exercises or games designed to improve communication skills for children on the autism spectrum. These exercises are often gamified to make learning fun and engaging.',
              Icons.gamepad,
            ),
            _buildRecommendationCard(
              'Technology-Assisted Learning',
              'Utilize technology to provide visual aids or auditory prompts that assist in understanding and responding to social cues. These apps can include features like flashcards, voice prompts, and customizable visual supports.',
              Icons.lightbulb_outline,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Explore these tools and resources to enhance communication and understanding for children on the autism spectrum.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecommendationCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.lightBlueAccent
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
