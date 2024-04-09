import 'dart:convert';
import 'dart:io';
import 'package:bus_season_ticker_users/userRegister/student/AllSet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdultSetUsernameAndPassword extends StatefulWidget {
  const AdultSetUsernameAndPassword({
    super.key,
  });

  @override
  State<AdultSetUsernameAndPassword> createState() =>
      _AdultSetUsernameAndPasswordState();
}

class _AdultSetUsernameAndPasswordState
    extends State<AdultSetUsernameAndPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _username = '';
  bool _obscureText = true;
  bool _obscureTextCom = true;
  late SharedPreferences _prefs;
  late String? name;
  late String? intName;
  late Map<String, bool> selectedDays;
  late String? email;
  late String? dob;
  late String? gender;
  late String? address;
  late String? telephone;
  late String? residence;
  late String? uploadedNICBack;
  late String? selectedFileContent;
  late String? uploadedPhotoFile;
  late String? uploadedNICFront;
  late String? selectedRoute;
  late String? nearest;
  late String? charge;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name');
      intName = _prefs.getString('intName');
      dob = _prefs.getString('dob');
      gender = _prefs.getString('gender');
      telephone = _prefs.getString('telephone');
      email = _prefs.getString('email');
      residence = _prefs.getString('residence');
      address = _prefs.getString('address');
      uploadedNICBack = _prefs.getString('uploadedNICBack');
      selectedFileContent = _prefs.getString('selectedFileContent');
      uploadedPhotoFile = _prefs.getString('uploadedPhotoFile');
      uploadedNICFront = _prefs.getString('uploadedNICFront');
      selectedRoute = _prefs.getString('selectedRoute');
      nearest = _prefs.getString('nearest');
      charge = _prefs.getString('charge');
      // Retrieve the JSON string from SharedPreferences
      String? selectedDaysJson = _prefs.getString('selectedDays');

      // Decode the JSON string into a map
      if (selectedDaysJson != null && selectedDaysJson.isNotEmpty) {
        Map<String, dynamic> decodedMap = jsonDecode(selectedDaysJson);
        // Convert dynamic values to bool and assign to selectedDays
        selectedDays =
            decodedMap.map((key, value) => MapEntry(key, value as bool));
      } else {
        // If no value found in SharedPreferences, initialize selectedDays as an empty map
        selectedDays = {};
      }
      print(name);
      print(charge);
    });
  }

  @override
  void dispose() {
    //properly disposed of when the State object is removed. This is essential to prevent memory leaks and unexpected behavior in your app
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> savedata() async {
    String password = _confirmPasswordController.text;
    // Map<String, bool> selectedDays = widget.selectedDays;
    bool monday = selectedDays['Monday'] ?? false;
    bool tuesday = selectedDays['Tuesday'] ?? false;
    bool wednesday = selectedDays['Wednesday'] ?? false;
    bool thursday = selectedDays['Thursday'] ?? false;
    bool friday = selectedDays['Friday'] ?? false;
    bool saturday = selectedDays['Saturday'] ?? false;
    bool sunday = selectedDays['Sunday'] ?? false;

    // File uploadedNICBack = File(uploadedNICBack);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.43.220:8080/api/v1/auth/adult/register'),
    )
      ..headers['Content-Type'] = 'multipart/mixed'
      ..fields['request'] = jsonEncode({
        'fullname': name,
        'intName': intName,
        'email': email.toString().trim().toLowerCase(),
        'password': password,
        'dob': dob,
        'gender': gender,
        'address': address,
        'telephone': telephone,
        'residence': residence
      })
      ..fields['routeDetails'] = jsonEncode(
          {"route": selectedRoute, "charge": charge, "nearestDeport": nearest})
      ..fields['selectDays'] = jsonEncode({
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
        "sunday": sunday,
      });

    request.files.add(http.MultipartFile.fromBytes(
      "uploadedNICFront",
      File(uploadedNICFront!).readAsBytesSync(),
      filename: uploadedNICFront!.split('/').last, // Use the file name
      contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(http.MultipartFile.fromBytes(
      "uploadedNICBack",
      File(uploadedNICBack!).readAsBytesSync(),
      filename: uploadedNICBack!.split('/').last, // Use the file name
      contentType: MediaType('image', 'jpeg'),
    ));

    request.files.add(http.MultipartFile.fromBytes(
      "photo",
      File(uploadedPhotoFile!).readAsBytesSync(),
      filename: uploadedPhotoFile!.split('/').last, // Use the file name
      contentType: MediaType('image', 'jpeg'),
    ));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        // Successful registration
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AllSet()));

        print('Registration Successful');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration Failed.Try Again!"),
          duration: Duration(seconds: 3),
        ));
        print('Registration Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  bool isPasswordValid(String password) {
    // Regular expression pattern to enforce password rules
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?]).{12,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    // return WillPopScope(
    //   onWillPop: () async {
    //     // Prevent going back by returning false

    //     return false;
    //   },
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Set Username & Password",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Just one step ahead!",
                  style: TextStyle(fontSize: 25, color: Color(0xFF881C20)),
                ),
                //point form
                const Text(
                  'Set a username and a password for your account. The password should,',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF881C20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  color: Color(0xFFF4E4C5),
                  child: const Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        ' 1: At least 12 characters long but 14 or more is better.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2: A combination of uppercase letters, lowercase letters, numbers, and symbols.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '3: Not a word that can be found in a dictionary or the name of a person, character, product, or organization.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Enter verified email as user name'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().toLowerCase().toString() !=
                                  email.toString().trim().toLowerCase()) {
                            return 'Please enter a your verified email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else {
                            bool isValid = isPasswordValid(value);

                            if (isValid) {
                              return null;
                            } else {
                              return 'Password does not meet the criteria that above mentioned.';
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureTextCom,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureTextCom
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureTextCom = !_obscureTextCom;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 236, 232, 233),
                          backgroundColor: Color(0xFF881C34),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            ok();
                          }
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 236, 232, 233),
                          backgroundColor: Color(0xFF881C34),
                        ),
                        onPressed: () {
                          cancel();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }

  void cancel() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Are you sure, Would you like to cancel the whole registration?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('If you leave, you need to start from the beginning.'),
                Text('Tap "Okay" button to return to the home screen.'),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('okay'),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void ok() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post-Registration Instructions'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Reminder: After clicking 'OK' on this alert, your registration will be successfully submitted. However, eligibility for our services is pending confirmation. We'll review your registration details within 24 hours and notify you via email. Please check your email frequently. "),
                Text("Thank you for your cooperation."),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('okay'),
                  onPressed: () {
                    savedata();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
