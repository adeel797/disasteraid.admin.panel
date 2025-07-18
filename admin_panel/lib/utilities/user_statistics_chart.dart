import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserStatisticsChart extends StatelessWidget {
   UserStatisticsChart({super.key});

  // Define colors for each account type
  final Map<String, Color> accountTypeColors = {
    'affectee': Colors.red,
    'ngo': Colors.blue,
    'volunteer': Colors.green,
    'donor': Colors.orange,
  };

  // Define labels for each account type
  final Map<String, String> accountTypeLabels = {
    'affectee': 'Affecties',
    'ngo': 'NGOs',
    'volunteer': 'Volunteers',
    'donor': 'Donors',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color(0xFF0B0B0C),
                  size: 28,
                ),
              );
            }
            final users = snapshot.data!.docs;
            final counts = {
              'affectee': 0,
              'ngo': 0,
              'volunteer': 0,
              'donor': 0,
            };
            for (var user in users) {
              final accountType = user['accountType'];
              if (counts.containsKey(accountType)) {
                counts[accountType] = counts[accountType]! + 1;
              }
            }

            // Calculate total for percentage calculation
            final total = counts.values.reduce((a, b) => a + b).toDouble();
            if (total == 0) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 16, color: Color(0xFF0B0B0C)),
                ),
              );
            }

            return Column(
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'User Distribution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0B0B0C),
                    ),
                  ),
                ),
                // Pie Chart
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: counts['affectee']!.toDouble(),
                          color: accountTypeColors['affectee'],
                          title:
                          '${(counts['affectee']! / total * 100).toStringAsFixed(1)}%',
                          radius: 120,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAF9F6),
                          ),
                        ),
                        PieChartSectionData(
                          value: counts['ngo']!.toDouble(),
                          color: accountTypeColors['ngo'],
                          title:
                          '${(counts['ngo']! / total * 100).toStringAsFixed(1)}%',
                          radius: 120,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAF9F6),
                          ),
                        ),
                        PieChartSectionData(
                          value: counts['volunteer']!.toDouble(),
                          color: accountTypeColors['volunteer'],
                          title:
                          '${(counts['volunteer']! / total * 100).toStringAsFixed(1)}%',
                          radius: 120,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAF9F6),
                          ),
                        ),
                        PieChartSectionData(
                          value: counts['donor']!.toDouble(),
                          color: accountTypeColors['donor'],
                          title:
                          '${(counts['donor']! / total * 100).toStringAsFixed(1)}%',
                          radius: 120,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAF9F6),
                          ),
                        ),
                      ],
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                // Legend
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildLegendItem(
                        'Affecties',
                        accountTypeColors['affectee']!,
                      ),
                      _buildLegendItem('NGOs', accountTypeColors['ngo']!),
                      _buildLegendItem(
                        'Volunteers',
                        accountTypeColors['volunteer']!,
                      ),
                      _buildLegendItem('Donors', accountTypeColors['donor']!),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0B0B0C),
          ),
        ),
      ],
    );
  }
}