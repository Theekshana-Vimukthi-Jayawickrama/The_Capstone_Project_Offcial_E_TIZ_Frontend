import 'dart:convert';
import 'dart:ffi';
import 'package:bus_season_ticker_users/userRegister/Adult/AdultEmailVerfication.dart';
import 'package:bus_season_ticker_users/userRegister/Adult/AdultSetUsername&Password.dart';
import 'package:bus_season_ticker_users/userRegister/student/EmailOTPEnteryScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdultBusRoute extends StatefulWidget {
  const AdultBusRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<AdultBusRoute> createState() => _AdultBusRouteState();
}

class _AdultBusRouteState extends State<AdultBusRoute> {
  List<String> routes = [];
  final _formKey = GlobalKey<FormState>();
  String? selectedRoute;
  String _nearest = '';
  String? charge;
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Map<String, bool> selectedDays = {};
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    for (String day in days) {
      selectedDays[day] = false;
    }
    fetchData();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _savePreferences() async {
    await _prefs.setString('selectedRoute', selectedRoute ?? '');
    await _prefs.setString('nearest', _nearest ?? '');
    await _prefs.setString('charge', charge ?? '');
    // Convert the map to a JSON string
    String selectedDaysJson = jsonEncode(selectedDays ?? {});

    // Save the JSON string to SharedPreferences
    await _prefs.setString('selectedDays', selectedDaysJson);
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
          'http://192.168.43.220:8080/api/v1/route/getAdultCharge/$selectedRoute';
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(selectedDays),
        );
        if (response.statusCode == 200) {
          setState(() {
            charge = jsonDecode(response.body).toString();
          });

          print(charge);
        } else {
          print("Error for chargers");
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.001,
                        child: const Text(
                          "Route Information",
                          style:
                              TextStyle(color: Color(0xFF881C34), fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.05,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Provide information of your daily route corresponding to the above-mentioned requirements.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xFF881C34), fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Positioned(
                        top: 12,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 500,
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
                                      color: Color(0xFF000000),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                          // You can filter your suggestions here
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
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select your route';
                                          }
                                          return null;
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
                                SizedBox(height: 20),
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Select days",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (String day in days)
                                          Text(
                                            day.substring(0, 3),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (String day in days)
                                          Checkbox(
                                            value: selectedDays[day]!,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                selectedDays[day] = value!;
                                                fetchChargeData();
                                              });
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
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
                                    backgroundColor: const Color(0xFF881C34),
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
                          Align(
                            alignment: Alignment.bottomRight,
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
                                    if (validateDays()) {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _formKey.currentState?.save();
                                        _savePreferences();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdultEmailVerfication(),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Please select at least 3 days."),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF881C34),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateDays() {
    int selectedCount = selectedDays.values.where((value) => value).length;
    return selectedCount >= 3;
  }

  Future<void> _refreshData() async {
    await fetchData();
  }
}
