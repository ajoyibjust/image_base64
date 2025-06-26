import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageFromBase64 extends StatefulWidget {
  const ImageFromBase64({super.key});

  @override
  State<ImageFromBase64> createState() => _ImageFromBase64();
}

class _ImageFromBase64 extends State<ImageFromBase64> {
  final _controller = TextEditingController();
  Uint8List? _imageBytes;

  void _decodeImage() {
    final input = _controller.text.trim();
    final decoded = base64Decode(input);
    setState(() {
      _imageBytes = decoded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              _imageBytes != null
                  ? Image.memory(_imageBytes!, width: 200, height: 200)
                  : SizedBox.shrink(),
              ElevatedButton(onPressed: _decodeImage, child: Text("Korish")),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
