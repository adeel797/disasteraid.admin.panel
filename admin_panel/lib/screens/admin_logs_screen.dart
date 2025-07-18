import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AdminLogScreen extends StatelessWidget {
  const AdminLogScreen({super.key});

  Widget _buildLogTable(List< DocumentSnapshot> logs, BuildContext context) {
    final colWidths = [150.0, 200.0, 250.0, 200.0];
    final columnTitles = ['Admin Name', 'Admin Email', 'Action Performed', 'Date Time'];
    final totalTableWidth = colWidths.reduce((a, b) => a + b); // Sum of column widths

    final headerRow = Row(
      children: columnTitles.asMap().entries.map((entry) {
        int idx = entry.key;
        String title = entry.value;
        return Container(
          width: colWidths[idx],
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF0B0B0C),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
    );

    Widget dataWidget;
    if (logs.isEmpty) {
      dataWidget = Container(
        width: totalTableWidth, // Ensure empty state has table width
        height: 100,
        alignment: Alignment.center,
        child: const Text('No logs available'),
      );
    } else {
      dataWidget = ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          var log = logs[index].data() as Map< String, dynamic>;
          Color rowColor = index % 2 == 0 ? Colors.white : Colors.grey[100]!;
          String dateTimeString = '';
          if (log['action_performed_date_time'] is Timestamp) {
            dateTimeString = DateFormat('MMM d, yyyy - HH:mm')
                .format(log['action_performed_date_time'].toDate());
          } else {
            dateTimeString = 'Invalid date';
          }
          return Container(
            color: rowColor,
            child: Row(
              children: [
                Container(
                  width: colWidths[0],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    log['admin_name'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF0B0B0C), fontSize: 14),
                  ),
                ),
                Container(
                  width: colWidths[1],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    log['admin_email'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF0B0B0C), fontSize: 14),
                  ),
                ),
                Container(
                  width: colWidths[2],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    log['admin_action_performed'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF0B0B0C), fontSize: 14),
                  ),
                ),
                Container(
                  width: colWidths[3],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    dateTimeString,
                    style: const TextStyle(color: Color(0xFF0B0B0C), fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: totalTableWidth, // Ensure minimum width for table
              maxHeight: constraints.maxHeight,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerRow,
                  const Divider(color: Colors.grey, height: 1),
                  SizedBox(
                    width: totalTableWidth, // Set width for data area
                    height: constraints.maxHeight - 50, // Adjust for header height
                    child: dataWidget,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder< QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_logs')
            .orderBy('action_performed_date_time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xFFFAF9F6),
                size: 100,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final logs = snapshot.data?.docs ?? [];
          return _buildLogTable(logs, context);
        },
      ),
    );
  }
}