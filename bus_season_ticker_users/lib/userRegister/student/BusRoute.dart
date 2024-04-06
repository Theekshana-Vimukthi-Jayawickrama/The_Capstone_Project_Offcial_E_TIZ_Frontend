import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bus_season_ticker_users/userRegister/student/EmailOTPEnteryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusRoute extends StatefulWidget {
  const BusRoute({
    super.key,
  });

  @override
  State<BusRoute> createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {
  List<String> routes = [];
  final _formKey = GlobalKey<FormState>();
  String? selectedRoute;
  String _nearest = '';
  String? charge;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    fetchData();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _savePreferences() async {
    await _prefs.setString('selectedRoute', selectedRoute ?? '');
    await _prefs.setString('nearest', _nearest ?? '');
    await _prefs.setString('charge', charge ?? '');
  }

  Future<void> fetchData() async {
    const url = 'http://192.168.43.220:8080/api/v1/route/routeList';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          routes = jsonResponse.cast<String>();
        });
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> fetchChargeData() async {
    if (selectedRoute != null) {
      String url =
          'http://192.168.43.220:8080/api/v1/route/getStudentCharge/$selectedRoute';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          double jsonResponse = jsonDecode(response.body);
          setState(() {
            charge = jsonResponse.toString();
          });
          print('Charge fetched: $charge');
        } else {
          print('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('Please select a route.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bus Route",
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Positioned(
                      top: 10,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Route Information",
                          style:
                              TextStyle(color: Color(0xFF881C34), fontSize: 20),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 30),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.88,
                          child: const Text(
                            "Provide information of your daily route corresponding to the above-mentioned requirements.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xFF881C34), fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Text(
                                "Select your route",
                                style: TextStyle(
                                    color: Color(0xFF000000), fontSize: 15),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        decoration: const InputDecoration(
                                          labelText: 'Select Route',
                                        ),
                                        controller: TextEditingController(
                                            text: selectedRoute),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        //  filter suggestions
                                        return routes
                                            .where((route) => route
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase()))
                                            .toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          selectedRoute = suggestion;
                                          fetchChargeData();
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your route';
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: ("Nearest Deport")),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Nearest Deport';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _nearest = value ??
                                            ''; // check value is null(??), if null assin ('') to _nearest, otherwise, value assign to _neareat
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  "Charge(RS) : ${charge ?? '0.00'}",
                                  style: const TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Positioned(
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 20.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 0),
                                height: 44,
                                width: 120,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 20.0),
                              child: Container(
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
                                      _savePreferences();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EmailEnteryScreen(),
                                        ),
                                      );
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await fetchData();
  }
}
