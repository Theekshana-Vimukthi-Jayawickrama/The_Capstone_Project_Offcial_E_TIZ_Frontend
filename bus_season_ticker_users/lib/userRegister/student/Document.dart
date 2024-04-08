import 'package:bus_season_ticker_users/userRegister/student/BusRoute.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Document extends StatefulWidget {
  const Document({
    super.key,
  });

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  String? uploadedBirthFile;
  String? uploadedApprovalFile;
  String selectedFileContent = "";
  String? uploadedPhotoFile;
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
    await _prefs.setString('uploadedBirthFile', uploadedBirthFile ?? '');
    await _prefs.setString('selectedFileContent', selectedFileContent ?? '');
    await _prefs.setString('uploadedPhotoFile', uploadedPhotoFile ?? '');
    await _prefs.setString('uploadedApprovalFile', uploadedApprovalFile ?? '');
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

  void _uploadBirthFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        uploadedBirthFile = filePath;
      });
    }
  }

  void _removeBirthFile() {
    setState(() {
      uploadedBirthFile = null;
      selectedFileContent = "";
    });
  }

  void _showBirthFile() async {
    if (uploadedBirthFile != null) {
      await OpenFile.open(uploadedBirthFile!);
    }
  }

  //Approval file

  void _uploadApprovalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      setState(() {
        uploadedApprovalFile = filePath;
      });
    }
  }

  void _removeApprovalFile() {
    setState(() {
      uploadedApprovalFile = null;
      selectedFileContent = "";
    });
  }

  void _showApprovalFile() async {
    if (uploadedApprovalFile != null) {
      await OpenFile.open(uploadedApprovalFile!);
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
    if (uploadedBirthFile != null &&
        uploadedApprovalFile != null &&
        uploadedPhotoFile != null) {
      _savePreferences();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BusRoute()),
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
                const Text(
                    "Attach the above - mentioned documents. documents should be renamed by the index number.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF881C34), fontSize: 15)),
                const SizedBox(
                  height: 20,
                ),

                const Text(
                    "A Copy of The Birth Certificate of The Student (File type should be PDF).",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
                ElevatedButton(
                  onPressed:
                      uploadedBirthFile == null ? _uploadBirthFile : null,
                  child: const Text('Upload Birth File as PDF'),
                ),
                const SizedBox(height: 20),
                uploadedBirthFile != null
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _getFileThumbnail(uploadedBirthFile!),
                              IconButton(
                                onPressed: _removeBirthFile,
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _showBirthFile,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xFF881C34), // Text color
                              padding: EdgeInsets.all(
                                  10), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                            ),
                            child: const Text('Show Birth File'),
                          ),
                        ],
                      )
                    : Container(),

                //next uploader
                SizedBox(height: 50),
                const Text(
                    "A Letter Signed By The Principal (File type should be PDF).",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
                ElevatedButton(
                  onPressed: uploadedApprovalFile == null
                      ? _uploadApprovalFile
                      : null, // disable button // disable button (If uploadedApprovalFile is null, call _uploadApprovalFile. If uploadedApprovalFile is not null, execute null.)
                  child: const Text('Upload Approval File as PDF'),
                ),
                const SizedBox(height: 20),
                uploadedApprovalFile != null
                    ? Column(
                        children: [
                          Stack(
                            //Stack is a widget that allows you to place multiple widgets on top of each other
                            alignment: Alignment.topRight,
                            children: [
                              _getFileThumbnail(uploadedApprovalFile!),
                              IconButton(
                                onPressed: _removeApprovalFile,
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: (_showApprovalFile),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color(0xFF881C34), // Text color
                              padding: EdgeInsets.all(
                                  10), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                            ),
                            child: const Text('Show Approval File'),
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
