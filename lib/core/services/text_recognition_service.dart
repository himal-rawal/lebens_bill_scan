import 'package:flutter/rendering.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  static Future<String> recognizeText(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      final formattedText = _formatReceiptText(recognizedText);
      debugPrint(formattedText);
      return formattedText;
    } catch (e) {
      debugPrint(e.toString());
      return "";
    } finally {
      textRecognizer.close();
    }
  }

  /// Reconstructs receipt text row-by-row using bounding box coordinates
  static String _formatReceiptText(RecognizedText recognizedText) {
    // 1. Extract every single line of text from all blocks
    List<TextLine> allLines = [];
    for (TextBlock block in recognizedText.blocks) {
      allLines.addAll(block.lines);
    }

    if (allLines.isEmpty) return "";

    // 2. Sort all lines vertically (top to bottom) based on their Y coordinate
    allLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    // 3. Group lines into rows if they sit on the same vertical level
    List<List<TextLine>> rows = [];
    for (TextLine line in allLines) {
      if (rows.isEmpty) {
        rows.add([line]);
      } else {
        var lastRow = rows.last;

        // Calculate a dynamic threshold based on text height.
        // If the Y coordinate is within this threshold, it belongs on the same line.
        double yThreshold = lastRow.first.boundingBox.height / 2;

        if ((line.boundingBox.top - lastRow.first.boundingBox.top).abs() <
            yThreshold) {
          lastRow.add(line); // Belongs to the current row
        } else {
          rows.add([line]); // Starts a new row
        }
      }
    }

    // 4. Sort each row horizontally (left to right) and join them
    StringBuffer receiptBuilder = StringBuffer();
    for (List<TextLine> row in rows) {
      // Sort by X coordinate (left to right)
      row.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

      // Join the elements in the row with a large space to represent the receipt gap
      String rowText = row.map((line) => line.text).join('   ');
      receiptBuilder.writeln(rowText);

      // Optional: Print to console to verify it worked
      debugPrint("Receipt Line: $rowText");
    }

    return receiptBuilder.toString();
  }
}
