import 'dart:convert';
import 'dart:ffi';
import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RenewSeasonTicket extends StatefulWidget {
  final String token;
  final String userId;
  const RenewSeasonTicket(
      {super.key, required this.token, required this.userId});

  @override
  State<RenewSeasonTicket> createState() => _RenewSeasonTicketState();
}

class _RenewSeasonTicketState extends State<RenewSeasonTicket> {
  String purchaseDate = '';
  String expiredDate = '';
  int? remainDays;
  bool? verification;
  bool? purchaseAvailability;
  bool showButton = false;

  String topicMessage =
      'Please, purchase the ticket in end of month for next month.';
  String contentMessage =
      "As a new user,  You can purchase the ticket end week of the current month for next month.";
  String colorBackground = '';
  Color? myColor;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.loadFromTicketCache();

      if (!dataProvider.isTicketDataLoaded) {
        // Only fetch data from the backend if it's not already loaded
        print(dataProvider.isTicketDataLoaded);

        await _getTicketData();
        dataProvider.updateTicketData(
          purchaseDate: purchaseDate,
          expiredDate: expiredDate,
          purchaseAvailability: purchaseAvailability,
          remainDays: remainDays,
          verification: verification,
          isTicketDataLoaded: true,
        );
      } else {
        // Assign loaded data to local variables
        String loadedPurchaseDate = dataProvider.purchaseDate;
        String loadedExpiredDate = dataProvider.expiredDate;
        bool? loadedPurchaseAvailability = dataProvider.purchaseAvailability;
        bool? loadedVerification = dataProvider.verification;
        int? loadedRemainDays = dataProvider.remainDays;

        // Update the local state variables with loaded data
        setState(() {
          purchaseDate = loadedPurchaseDate;
          expiredDate = loadedExpiredDate;
          purchaseAvailability = loadedPurchaseAvailability;
          verification = loadedVerification;
          remainDays = loadedRemainDays;
          // showButton = purchaseAvailability ?? false;
          showButton = true;
          _setMessage();
        });

        print(verification);
      }
    });
  }

  Future<void> _getTicketData() async {
    String userId = widget.userId;
    String userToken = widget.token;
    final response = await http.get(
      Uri.parse(
          'http://192.168.43.220:8080/api/v1/subscription/getTicketDetails/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      Map<String, dynamic> responseData = json.decode(jsonResponse);
      purchaseDate = responseData['purchaseDate'];
      expiredDate = responseData['expiredDate'];
      remainDays = responseData['availableDays'];
      verification = responseData['verification'];
      purchaseAvailability = responseData['purchaseAvailability'];
      setState(() {
        // showButton = purchaseAvailability ?? false;
        showButton = true;
        _setMessage();
      });
    } else {
      print("error occured.");
    }
  }

  Future<void> _setMessage() async {
    if (verification == true) {
      topicMessage = 'You have no dues up to today.';
      contentMessage =
          'Make sure to purchase your next season on time to avoid interrruptions.';
      colorBackground = '#FF288932';
    } else if (verification == false) {
      topicMessage =
          'Your current purchase is overdue. Please, purchase the ticket.';
      contentMessage =
          'Your current purchase is no longer valid: Renew the season to avoid interruptions.If you are a new user:  You can purchase the ticket end week of the current month for next month.';
      colorBackground = '#FFFB0B0B';
    }
    if (colorBackground.length >= 9) {
      int colorValue = int.parse(colorBackground.substring(3, 9), radix: 16);
      // Rest of your code using colorValue
      myColor = Color(colorValue + 0xFF000000);
    } else {
      // Handle the case where the string is too short
      print('Invalid colorBackground string length');
    }
  }

  Future<void> _refreshData() async {
    // // refresh the data
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.loadFromTicketCache();

    await _getTicketData();
    dataProvider.updateTicketData(
      purchaseDate: purchaseDate,
      expiredDate: expiredDate,
      purchaseAvailability: purchaseAvailability,
      remainDays: remainDays,
      verification: verification,
      isTicketDataLoaded: true,
    );
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            height: 230,
                            decoration: const BoxDecoration(
                              color: Color(0xFF881C34),
                              borderRadius: BorderRadius.only(),
                            )),
                        Positioned(
                          top: 160,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.99,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 241, 233, 234),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50)),
                              )),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                              width: 90,
                              height: 90,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 241, 233, 234),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(5000),
                                ),
                              )),
                        ),
                        Positioned(
                          top: 50,
                          right: 70,
                          child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 241, 233, 234),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(500)))),
                        ),
                        Positioned(
                          top: 100,
                          right: 20,
                          child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(500)))),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          width: 350,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Date Purchased : $purchaseDate",
                                style: TextStyle(color: Color(0xFF881C34)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF881C34),
                              width: 2.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 350,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Expired on : $expiredDate",
                                style: TextStyle(color: Color(0xFF881C34)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF881C34),
                              width: 2.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 350,
                          height: 100,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Remaining No. of Days To Get Expired: $remainDays Days",
                                style:
                                    const TextStyle(color: Color(0xFF881C34)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF881C34),
                              width: 2.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 300,
                          height: 200,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Text(
                                    "$topicMessage",
                                    style: const TextStyle(
                                        color: Color(0xFFFFFFFF)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "$contentMessage",
                                    style: const TextStyle(
                                        color: Color(0xFFFFFFFF), fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: myColor,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: showButton,
                        child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF881C34),
                                border: Border.all(
                                  color: Color(0xFF881C34),
                                  width: 2.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                )),
                            child: ElevatedButton(
                                onPressed: makePurchase(),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Purchase Now",
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  makePurchase() {}
}
