import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final File imageFile;

  const FullScreenImage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        /// Enables zooming in and out of the image
        child: InteractiveViewer(
          panEnabled: false, // Disable panning (dragging)
          boundaryMargin: EdgeInsets.all(20), // Allows some margin for better interaction.
          minScale: 0.5,  // Minimum zoom level is 50%.
          maxScale: 4.0,  //Maximum zoom level is 400%.
          ///Displays the image from the file.
          child: Image.file(imageFile, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
