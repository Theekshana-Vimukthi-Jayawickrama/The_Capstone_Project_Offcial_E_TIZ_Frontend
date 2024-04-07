import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdultPayment extends StatefulWidget {
  final String amount;
  final String? route;
  final Map<String, bool> selectedDays;
  final String? nearestDeport;
  const AdultPayment(
      {super.key,
      required this.amount,
      this.route,
      required this.selectedDays,
      this.nearestDeport});

  @override
  State<AdultPayment> createState() => _AdultPaymentState();
}

class _AdultPaymentState extends State<AdultPayment> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
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
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    // DataProvider().updateData(
    //   isDataLoaded: false,
    // );
    DataProvider().updateTicketData(
      isTicketDataLoaded: false,
    );
    DataProvider().updateMyAccountData(isMyAccountDataLoaded: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Page'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount: LKR ${widget.amount}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            hintText: 'Enter card number',
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiry Date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    controller: _expiryDateController,
                                    decoration: InputDecoration(
                                      hintText: 'MM/YY',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVV',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    controller: _cvvController,
                                    decoration: InputDecoration(
                                      hintText: '123',
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    processPayment();
                  },
                  child: Text('Pay Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processPayment() async {
    try {
      Map<String, dynamic> data = {
        'route': widget.route,
        'charge': widget.amount,
        'nearestDeport': widget.nearestDeport,
      };
      var response = await http.put(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/user/update/subscription/route/$userId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        DataProvider().updateTicketData(
          isTicketDataLoaded: false,
        );
        Future.delayed(Duration(seconds: 2));
        // ignore: use_build_context_synchronously
        showDialog<void>(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Payment Successful'),
              content: const SingleChildScrollView(
                child: ListBody(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => bottomNavigationBarStu(),
                        ));
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        showDialog<void>(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Payment Unsucessful'),
              content: const SingleChildScrollView(
                child: ListBody(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => bottomNavigationBarStu(),
                        ));
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
      }
      print(widget.amount);
      Future.delayed(Duration(seconds: 1));
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Payment Unsucessful'),
            content: const SingleChildScrollView(
              child: ListBody(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  DataProvider().updateData(
                    isDataLoaded: false,
                  );
                  DataProvider().updateTicketData(
                    isTicketDataLoaded: false,
                  );
                  Future.delayed(Duration(seconds: 1));
                  DataProvider()
                      .updateMyAccountData(isMyAccountDataLoaded: false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => bottomNavigationBarStu(),
                      ));
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }
}
