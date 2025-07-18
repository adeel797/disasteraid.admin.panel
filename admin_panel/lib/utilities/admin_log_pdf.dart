import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import '../services/admin_log_service.dart';

Future<void> downloadAdminLogs(BuildContext context) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: const Color(0xFFFAF9F6),
        size: 100,
      ),
    ),
  );

  try {
    // Log the download action
    final adminLogService = AdminLogService();
    await adminLogService.logAction('Downloaded admin logs');

    // Fetch logs from Firestore
    final logsSnapshot = await FirebaseFirestore.instance
        .collection('admin_logs')
        .orderBy('action_performed_date_time', descending: true)
        .get();
    final logs = logsSnapshot.docs;

    // Create PDF document
    final pdf = pw.Document();

    // Load Times font
    final font = pw.Font.times();

    // Build table rows
    final rows = <pw.TableRow>[];
    // Header row
    rows.add(
      pw.TableRow(
        children: [
          pw.Container(
            color: pw.PdfColors.black,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Admin Name',
              style: pw.TextStyle(font: font, color: pw.PdfColors.white),
            ),
          ),
          pw.Container(
            color: pw.PdfColors.black,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Admin Email',
              style: pw.TextStyle(font: font, color: pw.PdfColors.white),
            ),
          ),
          pw.Container(
            color: pw.PdfColors.black,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Action Performed',
              style: pw.TextStyle(font: font, color: pw.PdfColors.white),
            ),
          ),
          pw.Container(
            color: pw.PdfColors.black,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              'Date Time',
              style: pw.TextStyle(font: font, color: pw.PdfColors.white),
            ),
          ),
        ],
      ),
    );
    // Data rows
    for (var i = 0; i < logs.length; i++) {
      final log = logs[i].data();
      final dateTime = log['action_performed_date_time'] is Timestamp
          ? (log['action_performed_date_time'] as Timestamp).toDate()
          : DateTime.now();
      final dateTimeString = DateFormat('MMM d, yyyy - HH:mm').format(dateTime);
      final rowColor = i % 2 == 0 ? pw.PdfColors.white : pw.PdfColors.grey300;

      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(color: rowColor),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                log['admin_name'] ?? '',
                style: pw.TextStyle(font: font),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                log['admin_email'] ?? '',
                style: pw.TextStyle(font: font),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                log['admin_action_performed'] ?? '',
                style: pw.TextStyle(font: font),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                dateTimeString,
                style: pw.TextStyle(font: font),
              ),
            ),
          ],
        ),
      );
    }

    // Create table with column widths proportional to AdminLogScreen
    final table = pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FractionColumnWidth(0.1875), // 150/800
        1: const pw.FractionColumnWidth(0.25),   // 200/800
        2: const pw.FractionColumnWidth(0.3125), // 250/800
        3: const pw.FractionColumnWidth(0.25),   // 200/800
      },
      children: rows,
    );

    // Add page to PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pw.PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text(
              'Admins Logs Report',
              style: pw.TextStyle(font: font, fontSize: 24),
            ),
          ),
          pw.SizedBox(height: 20),
          table,
        ],
      ),
    );

    // Generate PDF bytes
    final pdfBytes = await pdf.save();
    final fileName = 'admin_logs_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

    // Handle platform-specific download
    if (kIsWeb) {
      // Web: Trigger browser download
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop: Save to filesystem
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      // Show success message with file path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logs downloaded to ${file.path}'),
          backgroundColor: const Color(0xFF0B0B0C),
        ),
      );
    }

    // Close loading dialog
    Navigator.of(context).pop();
  } catch (e) {
    // Close loading dialog
    Navigator.of(context).pop();
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading logs: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}