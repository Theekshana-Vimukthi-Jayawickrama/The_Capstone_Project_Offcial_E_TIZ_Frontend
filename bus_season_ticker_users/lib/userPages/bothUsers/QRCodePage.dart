import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage();

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String imageUrl = '';
  late http.Client client;
  late Uint8List imageData;
  late String? token;
  late String? userId;
  late List<String>? roles;
  late SharedPreferences _prefs;

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      token = _prefs.getString('token');
      userId = _prefs.getString('userId');
      roles = _prefs.getStringList('roles');
      fetchQRCodeImage();
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  void fetchQRCodeImage() async {
    String url = 'http://192.168.43.220:8080/api/v1/qrcodes/${userId}';

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        setState(() {
          imageUrl = base64Encode(response.bodyBytes);
          imageData = response.bodyBytes;
        });
      } else {
        // Handle error cases here
        print('Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other potential errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Show QR code',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
              )),
          backgroundColor: const Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  child: imageUrl.isNotEmpty
                      ? Image.memory(
                          base64Decode(imageUrl),
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.50,
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveImageToGallery,
                child: Text('Save QR Code on Your device Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveImageToGallery() async {
    try {
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
      if (result != null && result.isNotEmpty) {
        print('Image saved to gallery: $result');
        showSnackBar('Image saved to gallery: $result');
      } else {
        print('Failed to save image to gallery');
        showSnackBar('Failed to save image to gallery');
      }
    } on PlatformException catch (e) {
      print('Error saving image: $e');
      showSnackBar('Failed to save image to gallery');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 6),
      ),
    );
  }
}
