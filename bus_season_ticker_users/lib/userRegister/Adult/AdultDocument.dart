import 'package:bus_season_ticker_users/userRegister/Adult/AdultBusRoute.dart';
import 'package:bus_season_ticker_users/userRegister/student/BusRoute.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdultDocument extends StatefulWidget {
  const AdultDocument({
    super.key,
  });

  @override
  State<AdultDocument> createState() => _AdultDocumentState();
}

class _AdultDocumentState extends State<AdultDocument> {
  String? uploadedNICBack;
  String selectedFileContent = "";
  String? uploadedPhotoFile;
  String? uploadedNICFront;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _savePreferences() async {
    await _prefs.setString('uploadedNICBack', uploadedNICBack ?? '');
    await _prefs.setString('selectedFileContent', selectedFileContent ?? '');
    await _prefs.setString('uploadedPhotoFile', uploadedPhotoFile ?? '');
    await _prefs.setString('uploadedNICFront', uploadedNICFront ?? '');
  }

  Widget _getFileThumbnail(String filePath) {
    if (filePath.endsWith('.pdf')) {
      return Image.asset('assets/pdf.png', height: 100, width: 100);
    } else if (filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.png')) {
      return Image.file(File(filePath),
          height: 100, width: 100, fit: BoxFit.cover);
    } else {
      return Container(
        height: 100,
        width: 100,
        color: Colors.grey,
        child: const Center(
          child: Icon(
            Icons.insert_drive_file,
            size: 50,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void _uploadBackUserNICPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        uploadedNICBack = filePath;
      });
    }
  }

  void _removeUploadedNICBack() {
    setState(() {
      uploadedNICBack = null;
      selectedFileContent = "";
    });
  }

  void _showUploadedNICBack() async {
    if (uploadedNICBack != null) {
      await OpenFile.open(uploadedNICBack!);
    }
  }

  //uploadedNICFront

  Future<void> _uploadFrontUserNICPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        uploadedNICFront = filePath;
      });
    }
  }

  void _removeUploadedNICFront() {
    setState(() {
      uploadedNICFront = null;
      selectedFileContent = "";
    });
  }

  void _showUploadedNICFront() async {
    if (uploadedNICFront != null) {
      await OpenFile.open(uploadedNICFront!);
    }
  }

  //passport sized photo

  void _uploadUserPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        uploadedPhotoFile = filePath;
      });
    }
  }

  void _removePhoto() {
    setState(() {
      uploadedPhotoFile = null;
      selectedFileContent = "";
    });
  }

  void _showPhoto() async {
    if (uploadedPhotoFile != null) {
      await OpenFile.open(uploadedPhotoFile!);
    }
  }

  void _navigateToNextPage() {
    if (uploadedNICBack != null &&
        uploadedNICFront != null &&
        uploadedPhotoFile != null) {
      _savePreferences();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdultBusRoute()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: const Text('Please upload all files.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Documents",
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(height: 50),

                //NIC Front Side
                const Text("NIC Front Side Photo.(should be clear.)",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
                ElevatedButton(
                  onPressed: uploadedNICFront == null
                      ? _uploadFrontUserNICPhoto
                      : null,
                  child: const Text('Upload Photo'),
                ),
                const SizedBox(height: 20),
                uploadedNICFront !=
                        null //display an image when uploadedPhotoFile is not null and show container if it is null.
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _getFileThumbnail(uploadedNICFront!),
                              IconButton(
                                onPressed: _removeUploadedNICFront,
                                icon: const Icon(Icons.close,
                                    color: Color(0xFF881C20)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _showUploadedNICFront,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xFF881C34), // Text color
                              padding: const EdgeInsets.all(
                                  10), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                            ),
                            child: const Text('Show Photo.'),
                          ),
                        ],
                      )
                    : Container(),

                //NIC Back photo
                SizedBox(height: 50),
                const Text("NIC Back Side Photo.(should be clear.)",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
                ElevatedButton(
                  onPressed:
                      uploadedNICBack == null ? _uploadBackUserNICPhoto : null,
                  child: const Text('Upload Photo'),
                ),
                const SizedBox(height: 20),
                uploadedNICBack !=
                        null //display an image when uploadedPhotoFile is not null and show container if it is null.
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _getFileThumbnail(uploadedNICBack!),
                              IconButton(
                                onPressed: _removeUploadedNICBack,
                                icon: const Icon(Icons.close,
                                    color: Color(0xFF881C20)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _showUploadedNICBack,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xFF881C34), // Text color
                              padding: const EdgeInsets.all(
                                  10), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                            ),
                            child: const Text('Show Photo.'),
                          ),
                        ],
                      )
                    : Container(),

                //photo
                SizedBox(height: 50),
                const Text("Passport Sized Photo.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
                ElevatedButton(
                  onPressed:
                      uploadedPhotoFile == null ? _uploadUserPhoto : null,
                  child: const Text('Upload Photo'),
                ),
                const SizedBox(height: 20),
                uploadedPhotoFile !=
                        null //display an image when uploadedPhotoFile is not null and show container if it is null.
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _getFileThumbnail(uploadedPhotoFile!),
                              IconButton(
                                onPressed: _removePhoto,
                                icon: const Icon(Icons.close,
                                    color: Color(0xFF881C20)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _showPhoto,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xFF881C34), // Text color
                              padding: const EdgeInsets.all(
                                  10), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                            ),
                            child: const Text('Show Photo.'),
                          ),
                        ],
                      )
                    : Container(),

                SizedBox(height: 50),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color(0xFF881C34), // Text color
                          padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 40,
                              right: 40), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _navigateToNextPage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color(0xFF881C34), // Text color
                          padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 40,
                              right: 40), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
