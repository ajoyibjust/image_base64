import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_base64/image_from_base64.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class Base64FromImage extends StatefulWidget {
  const Base64FromImage({super.key});

  @override
  State<Base64FromImage> createState() => _Base64FromImageState();
}

class _Base64FromImageState extends State<Base64FromImage> {
  File? imageFile;
  String? imageBase64;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);

      setState(() {
        imageFile = file;
        imageBase64 = base64;
      });

      log(base64);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(imageFile!, fit: BoxFit.cover),
                            )
                          : Center(child: Icon(Icons.add)),
                    ),
                  ),
                ),
                if (imageBase64 != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(imageBase64!, maxLines: 5),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: imageBase64!));
                    },
                    icon: Icon(Icons.copy),
                    label: Text("Copy"),
                  ),
                ],

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft, // yon tomondan
                        child: ImageFromBase64(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
