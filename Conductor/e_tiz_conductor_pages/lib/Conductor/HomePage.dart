import 'dart:math';

import 'package:e_tiz_conductor_pages/Conductor/DataProvider.dart';
import 'package:e_tiz_conductor_pages/Conductor/Loggin.dart';
import 'package:e_tiz_conductor_pages/Conductor/UserJourneyMarkPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;
  final String conductorId;
  const HomePage({super.key, required this.token, required this.conductorId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrResult = 'Scanned Data will appear here';
  String userId = '';
  String token = '';

  Future<void> scanQR() async {
    DataProvider().updateData(
      isDataLoaded: false,
    );
    DataProvider().updateTicketData(
      isTicketDataLoaded: false,
    );
    DataProvider().updateMyAccountData(isMyAccountDataLoaded: false);
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode.toString();
        int userIdIndex = qrCode.indexOf("userId");
        if (userIdIndex != -1) {
          int startIndex = qrResult.indexOf("userId: ") + "userId: ".length;
          String userId = qrResult.substring(startIndex);
          this.userId = userId;
          print("User ID: $userId");
        } else {
          // ignore: use_build_context_synchronously
          showDialog<void>(
            context: context,
            barrierDismissible: false, // User must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Invalid QR Code'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('This QR code is not associated with our service.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            },
          );
          print("no any user id");
        }
      });

      if (userId.isEmpty) {
      } else {
        try {
          final response = await http.get(
            Uri.parse(
                'http://192.168.43.220:8080/api/v1/conductor/checkUser/$userId'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            String jsonResponse = response.body;
            Map<String, dynamic> responseData = json.decode(jsonResponse);
            bool status = responseData['status'];
            String role = responseData['role'];
            if (status) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserJourneyMark(
                    token: widget.token,
                    conductorId: widget.conductorId,
                    userId: userId,
                    role: role,
                  ),
                ),
              );
              print('ok');
            } else {
              // ignore: use_build_context_synchronously
              showDialog<void>(
                context: context,
                barrierDismissible: false, // User must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('User not found'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('There is no user for this QR code.'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Okay'),
                      ),
                    ],
                  );
                },
              );
            }
            print('Response: ${response.body}');
          } else {
            // ignore: use_build_context_synchronously
            showDialog<void>(
              context: context,
              barrierDismissible: false, // User must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('User not found'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('There is no user for this QR code.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                );
              },
            );
            print('Error: ${response.statusCode}, ${response.reasonPhrase}');
          }
        } catch (error) {
          // ignore: use_build_context_synchronously
          showDialog<void>(
            context: context,
            barrierDismissible: false, // User must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('User not found'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('There is no user for this QR code.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            },
          );
          // print('Error: $error');
        }
      }
    } on PlatformException {
      qrResult = 'Fail to read QR code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Loggin()),
          (route) => false,
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
          child: Stack(children: [
            const Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 200,
                width: 300,
                child: Center(
                    child: Text(
                  "Scan QR",
                  style: TextStyle(
                      color: Color(0xFF881C34),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 145, 144, 144),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/consuctorQR.png"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 400),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 106, 106)
                          .withOpacity(0.5), // Adjust the opacity here
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Scan QR Code",
                            style: TextStyle(
                                color: Color(0xFF881C34),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 45, right: 10, left: 10),
                          child: Text(
                            "Scanning a QR code is a straightforward process that can be done using your smartphone or tablet. Begin by unlocking your device and opening the camera app. Position the QR code within the camera frame, ensuring it is well-lit and undamaged. Wait for the camera to recognize the QR code, and when it does, tap on the notification or follow on-screen instructions to access the associated content.",
                            style: TextStyle(
                                color: Color(0xFF881C34),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 260),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 236, 232, 233),
                                    backgroundColor: const Color(0xFF881C34),
                                    fixedSize: const Size(100, 100)),
                                onPressed: scanQR,
                                child: const Text("Scan")),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ]),
        )),
      ),
    );
  }
}
