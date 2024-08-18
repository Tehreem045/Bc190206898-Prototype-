import 'package:flutter/material.dart';

class LifeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        title: Text(
          'Lifestyle Recommendations',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Personalized Recommendations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Lifestyle Modifications'),
            _buildRecommendationCard(
              Icons.local_dining,
              'Healthy Eating',
              'Incorporate more fruits and vegetables into your diet. Consider reducing sugar and processed foods for better overall health.',
            ),
            _buildRecommendationCard(
              Icons.bedtime,
              'Sleep Hygiene',
              'Aim for 7-8 hours of sleep each night. Create a consistent sleep routine by going to bed and waking up at the same time each day.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Exercise Routines'),
            _buildRecommendationCard(
              Icons.directions_run,
              'Cardio Exercises',
              'Engage in at least 30 minutes of moderate aerobic activity, such as brisk walking or cycling, five days a week.',
            ),
            _buildRecommendationCard(
              Icons.fitness_center,
              'Strength Training',
              'Incorporate strength training exercises at least two days a week. Focus on major muscle groups for balanced strength.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Actionable Insights & Strategies'),
            _buildRecommendationCard(
              Icons.self_improvement,
              'Stress Management',
              'Practice mindfulness and relaxation techniques daily to manage stress and improve mental well-being.',
            ),
            _buildRecommendationCard(
              Icons.chat_bubble_outline,
              'Effective Communication',
              'Enhance communication skills by actively listening and expressing thoughts clearly. Regular practice can lead to better relationships and understanding.',
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

  Widget _buildRecommendationCard(IconData icon, String title, String description) {
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
              color: Colors.lightBlueAccent,
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
