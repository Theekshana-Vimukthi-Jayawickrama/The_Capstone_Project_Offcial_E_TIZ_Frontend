import 'dart:convert';

import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/QRCodePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int MyIndex = 0;
  String imageUrl = '';

  late DateTime today;
  late DateTime minDate;
  late DateTime maxDate;
  String userName = '';
  late bool verfied;
  List<DateTime> noJourney = [];
  List<DateTime> oneJourney = [];
  List<DateTime> twoJourney = [];
  List<DateTime> blankJourney = [];
  List<DateTime> todayJourney = [];
  int? monday;
  int? tuesday;
  int? wensday;
  int? friday;
  int? thusday;
  int? satuarday;
  int? sunday;

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
      fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    minDate = DateTime(today.year, today.month - 2, 1);
    maxDate = DateTime(today.year, today.month, 31);
    _initializeSharedPreferences();
  }

  Future<void> fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.loadFromCache();
      print(dataProvider.isDataLoaded);
// Only fetch data from the backend if it's not already loaded
      if (!dataProvider.isDataLoaded) {
        await getSelectedDays();
        await getUserName();
        await presentDaySelection();
        await fetchQRCodeImage();

        dataProvider.updateData(
            userName: userName,
            imageUrl: imageUrl,
            noJourney: noJourney,
            oneJourney: oneJourney,
            twoJourney: twoJourney,
            blankJourney: blankJourney,
            monday: monday,
            tuesday: tuesday,
            wensday: wensday,
            friday: friday,
            thusday: thusday,
            satuarday: satuarday,
            sunday: sunday,
            isDataLoaded: !dataProvider.isDataLoaded);
      } else {
        // Assign loaded data to local variables
        String loadedUserName = dataProvider.userName ?? '';
        String loadedImageUrl = dataProvider.imageUrl;
        List<DateTime> loadedNoJourney = List.from(dataProvider.noJourney);
        List<DateTime> loadedOneJourney = List.from(dataProvider.oneJourney);
        List<DateTime> loadedTwoJourney = List.from(dataProvider.twoJourney);
        List<DateTime> loadedBlankJourney =
            List.from(dataProvider.blankJourney);
        int loadMonday = dataProvider.monday;
        int loadTuesday = dataProvider.tuesday;
        int loadThusday = dataProvider.thusday;
        int loadWensday = dataProvider.wensday;
        int loadFriday = dataProvider.friday;
        int loadSatuarday = dataProvider.satuarday;
        int loadSunday = dataProvider.sunday;

        // Update the local state variables with loaded data
        setState(() {
          userName = loadedUserName;
          imageUrl = loadedImageUrl;
          noJourney = loadedNoJourney;
          oneJourney = loadedOneJourney;
          twoJourney = loadedTwoJourney;
          blankJourney = loadedBlankJourney;
          monday = loadMonday;
          tuesday = loadTuesday;
          wensday = loadWensday;
          thusday = loadThusday;
          friday = loadFriday;
          satuarday = loadSatuarday;
          sunday = loadSunday;
          print(loadedNoJourney);
        });
      }
    });
  }

  Future<void> getSelectedDays() async {
    print('give me ${roles}');
    if (roles != null && roles!.contains('STUDENT')) {
      monday = 0;
      tuesday = 0;
      wensday = 0;
      friday = 0;
      thusday = 0;
      satuarday = 0;
      sunday = 0;
    } else if (roles != null && roles!.contains('ADULT')) {
      final response = await http.get(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/journey/adult/daySelection/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String jsonResponse = response.body;
        Map<String, dynamic> responseData = json.decode(jsonResponse);
        bool monday = responseData['monday'];
        bool tuesday = responseData['tuesday'];
        bool wensday = responseData['wednesday'];
        bool thusday = responseData['thursday'];
        bool friday = responseData['friday'];
        bool satuarday = responseData['saturday'];
        bool sunday = responseData['sunday'];
        if (monday == false) {
          this.monday = 1;
        }
        if (tuesday == false) {
          this.tuesday = 2;
        }
        if (wensday == false) {
          this.wensday = 3;
        }
        if (thusday == false) {
          this.thusday = 4;
        }
        if (friday == false) {
          this.friday = 5;
        }
        if (satuarday == false) {
          this.satuarday = 6;
        }
        if (sunday == false) {
          this.sunday = 7;
        }
      }
    }
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

  Future<void> fetchQRCodeImage() async {
    String url = 'http://192.168.43.220:8080/api/v1/qrcodes/${userId}';

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        setState(() {
          imageUrl = base64Encode(response.bodyBytes);
        });
      } else {
        // Handle error cases here
        print('Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other potential errors
      print('Error: $e');
    }
  }

  Future<void> presentDaySelection() async {
    List<Future<void>> requests = [];

    DateTime today = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(today.year, today.month, 1);

// Calculate the date two months ago
    DateTime twoMonthsAgo =
        firstDayOfCurrentMonth.subtract(const Duration(days: 61));

    for (DateTime date = twoMonthsAgo;
        date.isBefore(today);
        date = date.add(const Duration(days: 1))) {
      DateTime dateOnly = DateTime(date.year, date.month, date.day);

      //the ${...} string interpolation syntax
      //ensures it's at least two characters long by padding it with a '0' if needed.
      String formattedDate =
          '${dateOnly.year}-${dateOnly.month.toString().padLeft(2, '0')}-${dateOnly.day.toString().padLeft(2, '0')}';

      Future<void> request = calenderMarker(formattedDate, date);
      requests.add(request);

      // if (date.isBefore(minDate)) {
      //   break;
      // }
    }
    // Wait for all requests to complete
    await Future.wait(requests);
    setState(() {}); // Update the UI after all requests are processed
  }

  Future<void> calenderMarker(String formattedDate, DateTime dateToAdd) async {
    var url = Uri.parse(
        'http://192.168.43.220:8080/api/v1/journey/student/checkJourney/$userId/$formattedDate');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    DateTime currentDate = DateTime(today.year, today.month, today.day);

    if (response.statusCode == 200) {
      int status = jsonDecode(response.body);
      setState(() {
        print(status);
        if (status == 0) {
          noJourney.add(dateToAdd);
        } else if (status == 1) {
          oneJourney.add(dateToAdd);
        } else if (status == 2) {
          twoJourney.add(dateToAdd);
        } else if (status == 404) {
          if (dateToAdd == currentDate) {
            todayJourney.add(dateToAdd);
          } else {
            blankJourney.add(dateToAdd);
          }
        }
      });
    } else {
      // Handle error
    }
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
                  height: 500,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.99,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Color(0xFF881C34),
                            borderRadius: BorderRadius.only(),
                          )),
                      Positioned(
                        top: 145,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            height: 100,
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
                        right: 60,
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
                        right: 25,
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 241, 233, 234),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(500)))),
                      ),
                      Positioned.fill(
                        top: 170,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              width: 300,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFF881C34),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                              )),
                        ),
                      ),
                      Positioned.fill(
                        top: 180,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              width: 220,
                              height: 75,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 238, 231, 232),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                              )),
                        ),
                      ),
                      Positioned.fill(
                        top: 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              if (imageUrl.isNotEmpty) {
                                // navigateToAnotherPage();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRCodePage()),
                                );
                              }
                            },
                            child: imageUrl.isNotEmpty
                                ? Image.memory(
                                    base64Decode(imageUrl),
                                    width:
                                        200, // Adjust the width/height as needed
                                    height: 200,
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          left: 20,
                          child: Text(
                            "Hello, $userName ",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(236, 252, 250, 250)),
                          )),
                      const Positioned(
                          top: 43,
                          left: 20,
                          child: Text(
                            "Welcome Back To E-Tickz",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(236, 252, 250, 250)),
                          )),
                    ],
                  ),
                ),
                //calender start
                Container(
                  height: 420,
                  child: CalendarCarousel<Event>(
                    // onDayPressed: _calendarEnabled ? _onDayPressed : null,
                    weekendTextStyle: const TextStyle(color: Colors.red),
                    thisMonthDayBorderColor: Colors.grey,
                    customDayBuilder: (
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      if (day.isBefore(minDate) || day.isAfter(maxDate)) {
                        return null; // Return null for days outside the range to hide them
                      }
                      // if (isThisMonthDay || isPrevMonthDay) {
                      if (day.weekday == monday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == tuesday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == wensday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == thusday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == friday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == satuarday) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (day.weekday == sunday) {
                        print("hi");
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 13, 14, 13),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 241, 235, 235)),
                            ),
                          ),
                        );
                      } else if (noJourney.contains(day)) {
                        print("hi");
                        print(noJourney.contains(day));
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFEACFCF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else if (oneJourney.contains(day)) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE9C88A),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else if (twoJourney.contains(day)) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF288932),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else if (blankJourney.contains(day)) {
                        print("hi");
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(69, 41, 117, 224),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else if (todayJourney.contains(day)) {
                        print(noJourney);
                        print("hi");
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 247, 6, 6),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      return null; // Return null for other dates to hide them
                    },
                    headerTextStyle: const TextStyle(
                        color: Colors.black54), // Disable header text color
                    minSelectedDate: minDate,
                    maxSelectedDate: maxDate,
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
    await _initializeSharedPreferences();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.loadFromCache();
    await presentDaySelection();
    await getUserName();
    await getSelectedDays();

    await fetchQRCodeImage();

    dataProvider.updateData(
      userName: userName,
      imageUrl: imageUrl,
      noJourney: noJourney,
      oneJourney: oneJourney,
      twoJourney: twoJourney,
      blankJourney: blankJourney,
      monday: monday,
      tuesday: tuesday,
      wensday: wensday,
      thusday: thusday,
      friday: friday,
      satuarday: satuarday,
      sunday: sunday,
      isDataLoaded: true,
    );

    // Trigger a rebuild of the widget
    setState(() {});

    // Return a Future to indicate that the refresh is complete
    return Future.value();
  }
}
