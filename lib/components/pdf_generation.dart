import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String> generatePdf(Map<String, dynamic> packageInfo) async {
  // Create a PDF document
  final pdf = pw.Document();
  final Uint8List companyLogoBytes =
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List();
  final fontData = (await rootBundle.load('fonts/MonsieurLaDoulaise.ttf'))
      .buffer
      .asUint8List();
  final customFont = pw.Font.ttf(fontData.buffer.asByteData());
  // Add content to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(companyLogoBytes),
                      width: 50, height: 50),
                  pw.SizedBox(width: 20),
                  pw.Text('Secure Me',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30)),
                ],
              ),
              pw.SizedBox(height: 80),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text(
                          'Date: ${DateTime.now().toString().substring(0, 10)}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16)),
                    ]),
                    pw.Column(children: [
                      pw.Text(
                          'Time: ${DateTime.now().toString().substring(11, 19)}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16))
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text('Name: ${packageInfo['Name']}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16)),
                      pw.Text('Address: ${packageInfo['Address']}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16)),
                      pw.Text('Phone: ${packageInfo['Phone']}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16)),
                      pw.Text('Email: ${packageInfo['Email']}',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, fontSize: 16)),
                    ]),
                  ]),
              pw.SizedBox(height: 30),
              pw.Text('Package Information:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.SizedBox(height: 30),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text('Package: ',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('Car Brand: ',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('Car Model: ',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('Car Reg: ',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('Car Engine: ',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('Expiration Date: ',
                          style: const pw.TextStyle(fontSize: 16)),
                    ]),
                    pw.Column(children: [
                      pw.Text('${packageInfo['Package']}',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('${packageInfo['Car Brand']}',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('${packageInfo['Car Model']}',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('${packageInfo['Car Reg']}',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('${packageInfo['Car Engine']}',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 20),
                      pw.Text('${packageInfo['Expiration Date']}',
                          style: const pw.TextStyle(fontSize: 16)),
                    ]),
                  ]),

              // Add other package information as needed
              pw.SizedBox(height: 40),
              pw.Column(
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        child: pw.Text('Signature:',
                            style: pw.TextStyle(fontSize: 16),
                            textAlign: pw.TextAlign.end),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Container(
                            width: 120, // Set the desired width for the divider
                            child:
                                pw.Divider(color: PdfColor.fromInt(0xff000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Md Mehedi Hasan',
                            style: pw.TextStyle(
                              fontSize: 22,
                              fontStyle: pw.FontStyle.italic,
                              font: customFont,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
