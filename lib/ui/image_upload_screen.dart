import 'dart:io';

import 'package:alruism/ui/image_carousel_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.grey.shade200,
        trailing: GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('This is a demo app'),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(
            CupertinoIcons.info_circle,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 3,
                            shadowColor: Colors.blue.shade300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Lottie.asset('lib/assets/2.json'),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CupertinoButton.filled(
                onPressed: () async {
                  final action = await showModalBottomSheet<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context, 'gallery');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image_search_rounded),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  const Text('Pick Photo'),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context, 'camera');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(CupertinoIcons.photo_camera),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  const Text('Take Photo'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  if (action == null) return;
                  if (action == 'gallery') {
                    _pickImageFromGallery();
                  } else if (action == 'camera') {
                    _pickImageFromCamera();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.photo,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        _selectedImage != null
                            ? 'Choose another Photo'
                            : 'Choose a Photo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: _selectedImage != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 20),
                      child: CupertinoButton.filled(
                        onPressed: () async {
                          if (_selectedImage != null) {
                            setState(() {
                              _progress = 1;
                            });
                            await _uploadPhoto();
                            setState(() {
                              _progress = 0;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageShow()));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.file_upload,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.all(2),
                              child: Text('Upload Photo',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:300/api/upload'),
      );
      request.files.add(
          await http.MultipartFile.fromPath('photo', _selectedImage as String));
      final response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _progress = 1;
        });
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          _progress = 0;
          _selectedImage = null;
        });
      } else {
        setState(() {
          _progress = 0;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
