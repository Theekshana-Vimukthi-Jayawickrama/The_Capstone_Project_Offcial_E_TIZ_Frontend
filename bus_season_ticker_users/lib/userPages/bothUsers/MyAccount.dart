import 'dart:convert';
import 'dart:ffi';

import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({
    super.key,
  });

  @override
  State<MyAccount> createState() => _HomeState();
}

class _HomeState extends State<MyAccount> {
  int MyIndex = 0;
  String imageUrl = '';
  String userName = '';
  String purchaseDate = '0000/00/00';
  String? monthName;
  String? route;
  String? routeNo;
  String? distance;
  String? charge;

  late String? token;
  late String? userId;
  late List<String>? roles;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      token = _prefs.getString('token');
      userId = _prefs.getString('userId');
      roles = _prefs.getStringList('roles');
      fetchData();
    });
  }

  Future<void> fetchData() async {
    // Only fetch data from the backend if it's not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.loadFromMyAccountCache();

      if (!dataProvider.isMyAccountDataLoaded) {
        await getTicketPuchaseDate();
        await getUserRoute();
        await getUserName();
        await fetchProfileImage();
        dataProvider.updateMyAccountData(
          userName1: userName,
          imageUrl1: imageUrl,
          purchaseDate: purchaseDate,
          monthName: monthName,
          routeNo: routeNo,
          route: route,
          distance: distance,
          isMyAccountDataLoaded: !dataProvider.isMyAccountDataLoaded,
          charge: charge,
        );
      } else {
        // Assign loaded data to local variables
        String loadedUserName = dataProvider.userName1 ?? '';
        String loadedImageUrl = dataProvider.imageUrl1;
        String loadedPurchaseDate = dataProvider.purchaseDateMyAccount ?? '';
        String loadedMonthName = dataProvider.monthName ?? '';
        String loadedRouteNo = dataProvider.routeNo ?? '';
        String loadDistance = dataProvider.distance ?? '';
        String loadCharge = dataProvider.charge ?? '';
        String loadRoute = dataProvider.route ?? '';

        // Update the local state variables with loaded data
        setState(() {
          userName = loadedUserName;
          imageUrl = loadedImageUrl;
          purchaseDate = loadedPurchaseDate;
          monthName = loadedMonthName;
          routeNo = loadedRouteNo;
          distance = loadDistance;
          charge = loadCharge;
          route = loadRoute;
        });
      }
    });
  }

  Future<void> getUserName() async {
    var urlGetName =
        Uri.parse('http://192.168.43.220:8080/api/v1/user/getName/$userId');
    final response1 = await http.get(urlGetName, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response1.statusCode == 200) {
      var getName = response1.body;
      userName = getName;
    } else {
      userName = "";
    }
  }

  Future<void> getUserRoute() async {
    var urlGetRoute = Uri.parse(
        'http://192.168.43.220:8080/api/v1/user/getRouteDetails/$userId');
    final response = await http.get(urlGetRoute, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      Map<String, dynamic> responseData = json.decode(jsonResponse);
      route = responseData['route'];
      routeNo = responseData['routeNo'];
      distance = responseData['distance'];
      charge = responseData['charge'];
      monthName = responseData['purchaseMonth'];
    }

    print('dddddddd $charge');
  }

  Future<void> fetchProfileImage() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/user/profilePhoto/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // The response body should contain the image data
        List<int> imageData = response.bodyBytes;

        setState(() {
          // Convert the image data to base64 and assign it to imageUrl
          imageUrl = base64Encode(imageData);
        });
      } else {
        // Handle error cases here
        print('Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other potential errors
      print('Error: $e');
    }
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(children: <Widget>[
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 800,
                  width: MediaQuery.sizeOf(context).width * 0.99,
                  child: Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 175,
                          decoration: const BoxDecoration(
                            color: Color(0xFF881C34),
                            borderRadius: BorderRadius.only(),
                          )),
                      const Positioned(
                          top: 25,
                          left: 20,
                          child: Text(
                            "My Account ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromARGB(236, 252, 250, 250)),
                          )),
                      Positioned(
                        top: 140,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            height: 40,
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
                        top: 10,
                        right: 90,
                        child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 241, 233, 234),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(500)))),
                      ),
                      Positioned(
                        top: 80,
                        right: 50,
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 240, 233, 234),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(500)))),
                      ),
                      Positioned.fill(
                        top: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.memory(
                                      base64Decode(imageUrl),
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircularProgressIndicator(),
                            Center(
                              child: Text(
                                " $userName ",
                                style: const TextStyle(
                                    fontSize: 25, color: Color(0xFF881C34)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Currently Purchase Month : $monthName",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, color: Color(0xFF881C34)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 244, 148, 30),
                                    Color.fromARGB(255, 226, 94, 11)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(children: [
                                const Text(
                                  "Your Route",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Route :$route",
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Charge :$charge",
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Route NO :$routeNo",
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Distance :$distance",
                                  style: const TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));

    // // ignore: use_build_context_synchronously
    // final dataProvider = Provider.of<DataProvider>(context, listen: false);
    // await dataProvider.loadFromCache();

    // await fetchProfileImage();
    // await getUserName();
    // await getTicketPuchaseDate();
    await _initializeSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserName();
      await getUserRoute();
      await getTicketPuchaseDate();
      await fetchProfileImage();

      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.loadFromMyAccountCache();
      print(dataProvider.isMyAccountDataLoaded);

      dataProvider.updateMyAccountData(
        userName1: userName,
        imageUrl1: imageUrl,
        purchaseDate: purchaseDate,
        monthName: monthName,
        routeNo: routeNo,
        route: route,
        distance: distance,
        isMyAccountDataLoaded: false,
        charge: charge,
      );
    });

    // Trigger a rebuild of the widget
    setState(() {});

    // Return a Future to indicate that the refresh is complete
    return Future.value();
  }

  Future<void> getTicketPuchaseDate() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.43.220:8080/api/v1/subscription/getTicketDetails/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      Map<String, dynamic> responseData = json.decode(jsonResponse);
      purchaseDate = responseData['purchaseDate'];

      if (purchaseDate == '0000-00-00') {
        monthName = 'No Month';
      } else {
        DateTime dateTime = DateTime.parse(purchaseDate);
        monthName = DateFormat.MMMM().format(dateTime);
      }
    } else {
      print("error occured.");
    }
  }
}
