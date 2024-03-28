import 'package:bus_season_ticker_users/userRegister/SelectingUser.dart';
import 'package:bus_season_ticker_users/userRegister/student/PersonalDetails2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDeatils extends StatefulWidget {
  const PersonalDeatils({super.key});

  @override
  State<PersonalDeatils> createState() => _PersonalDeatilsState();
}

class _PersonalDeatilsState extends State<PersonalDeatils> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _intName = '';
  String _dob = '';
  String _gender = '';
  String _telephone = '';
  String _email = '';
  String _residence = '';
  String _address = '';
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
    await _prefs.setString('name', _name ?? '');
    await _prefs.setString('intName', _intName ?? '');
    await _prefs.setString('dob', _dob ?? '');
    await _prefs.setString('gender', _gender ?? '');
    await _prefs.setString('telephone', _telephone ?? '');
    await _prefs.setString('email', _email ?? '');
    await _prefs.setString('residence', _residence ?? '');
    await _prefs.setString('address', _address ?? '');
  }

  Future<void> checkingUser(BuildContext context) async {
    String email = _email.toString().trim().toLowerCase();
    var url = Uri.parse(
        "http://192.168.43.220:8080/api/v1/auth/checkAlreadyUsers/$email");

    final respone = await http.get(url);
    if (respone.statusCode == 200) {
      print(respone.body);
      // ignore: use_build_context_synchronously
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert!'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'This email has been already registered. So, please enter another email address.'),
                  Text('Try Again!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _savePreferences();
      // Navigate to the next page and pass form data as arguments
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalDetails2(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Personal Deails",
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "This section contains 03 sections namely student’s details, school details and guardian details.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Color(0xFF881C34)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        color: const Color(0xFF262E7B),
                        width: double.infinity,
                        child: const Text("student's Deatils",
                            style: TextStyle(color: Color(0xFFFFFFFF))),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Name in Full'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Name with initials'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _intName = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Date of Birth (YYYY/MM/DD)'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your date of birth';
                                  }
                                  try {
                                    // check date fromate
                                    DateFormat('yyyy/MM/dd')
                                        .parseStrict(value.trim());
                                  } catch (e) {
                                    // If parsing fails, show an error
                                    return 'Please enter a valid date format "YYYY/MM/DD" \n (remove spaces as well). For example: 2023/12/31';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _dob = value ?? '';
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 0),
                                child: Text(
                                  'Gender',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'male',
                                    groupValue: _gender,
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value.toString();
                                      });
                                    },
                                  ),
                                  Text('Male'),
                                  Radio(
                                    value: 'female',
                                    groupValue: _gender,
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value.toString();
                                      });
                                    },
                                  ),
                                  Text('Female'),
                                ],
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Residence'),
                                onSaved: (value) {
                                  _residence = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Telephone'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your telephone number';
                                  }
                                  // Remove any non-digit characters from the input
                                  String cleanedPhoneNumber =
                                      value.replaceAll(RegExp(r'\D'), '');

                                  if (cleanedPhoneNumber.length != 10) {
                                    return 'Please enter a valid 10-digit telephone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _telephone = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  RegExp emailRegex = RegExp(
                                      r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Please enter a valid email address (e.g., example@gmail.com)';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value ?? '';
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Address'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your adress';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _address = value ?? '';
                                },
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 0),
                            height: 44,
                            width: 120,
                            decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectUser(),
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF881C34), // Set the background color to blue
                                elevation: 5,
                                shadowColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                "Back",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 0),
                            height: 44,
                            width: 120,
                            decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // All fields are valid, save the form
                                  _formKey.currentState?.save();
                                  checkingUser(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF881C34), // Set the background color to blue
                                elevation: 5,
                                shadowColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                "Next",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
