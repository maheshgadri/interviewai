import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PDFTextExtractor extends StatefulWidget {
  @override
  _PDFTextExtractorState createState() => _PDFTextExtractorState();
}

class _PDFTextExtractorState extends State<PDFTextExtractor> {
  String extractedText = 'Select a PDF file to extract text';

  Future<void> pickPDFAndExtractText() async {
    if (await Permission.storage.request().isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          String pdfPath = result.files.single.path!;
          String text = await extractTextFromPDF(pdfPath);
          setState(() {
            extractedText = text;
          });
        }
      } catch (e) {
        print("Error picking PDF: $e");
      }
    } else {
      print("Permission not granted");
      // Handle the scenario when the permission is not granted
    }
  }

  Future<String> extractTextFromPDF(String pdfPath) async {
    try {
      // Load the PDF document
      PdfDocument document = PdfDocument(inputBytes: File(pdfPath).readAsBytesSync());

      // Extract text from each page
      String text = '';
      for (int i = 0; i < document.pages.count; i++) {
        PdfPage page = document.pages[i];
        PdfTextExtractor extractor = PdfTextExtractor(document);
        text += await extractor.extractText();
      }

      // Dispose the document
      document.dispose();

      return text;
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Text Extraction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickPDFAndExtractText,
              child: Text('Pick PDF and Extract Text'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    extractedText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
