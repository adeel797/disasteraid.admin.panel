import 'package:admin_panel/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import '../utilities/user_statistics_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid of cards
          _buildCard(context),
          // Chart below the grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: UserStatisticsChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      {
        'name': 'Affecties',
        'icon': Icons.person,
        'action': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserListScreen(accountType: 'affectee')),
        )
      },
      {
        'name': 'NGOs',
        'icon': Icons.group,
        'action': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserListScreen(accountType: 'ngo')),
        )
      },
      {
        'name': 'Volunteers',
        'icon': Icons.volunteer_activism,
        'action': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserListScreen(accountType: 'volunteer')),
        )
      },
      {
        'name': 'Donors',
        'icon': Icons.monetization_on,
        'action': () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserListScreen(accountType: 'donor')),
        )
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Fixed 4 cards in a row
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.5,
      ),
      itemCount: settings.length,
      shrinkWrap: true, // Prevent grid from taking full height
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFFFAF9F6),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: settings[index]['action'],
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  settings[index]['icon'],
                  color: const Color(0xFF0B0B0C),
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  settings[index]['name'],
                  style: const TextStyle(
                    color: Color(0xFF0B0B0C),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}