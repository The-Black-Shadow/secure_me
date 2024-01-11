import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String> generatePdf(Map<String, dynamic> packageInfo) async {
  // Create a PDF document
  final pdf = pw.Document();

  // Add content to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Company Name', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Package Information:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.Text('Package: ${packageInfo['Package']}'),
              pw.Text('Car Model: ${packageInfo['Car Model']}'),
              pw.Text('Car Reg: ${packageInfo['Car Reg']}'),
              pw.Text('Car Engine: ${packageInfo['Car Engine']}'),
              // Add other package information as needed
              pw.SizedBox(height: 20),
              pw.Text('Signature: Your Name', style: pw.TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    ),
  );

  // Save the PDF to a file
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/package_info.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Open the PDF file using 'share_plus'
  await Share.shareFiles([filePath], text: 'Sharing PDF');

  print('PDF Generated and Saved at: $filePath');

  return filePath; // Return the file path
}
