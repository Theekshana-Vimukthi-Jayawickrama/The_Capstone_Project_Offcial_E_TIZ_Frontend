import 'dart:convert';

import 'package:e_tiz_conductor_pages/Conductor/DataProvider.dart';
import 'package:e_tiz_conductor_pages/Conductor/HomePage.dart';
import 'package:e_tiz_conductor_pages/Conductor/Loggin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserJourneyMark extends StatefulWidget {
  final String token;
  final String conductorId;
  final String userId;
  final String role;
  const UserJourneyMark(
      {super.key,
      required this.token,
      required this.userId,
      required this.role,
      required this.conductorId});

  @override
  State<UserJourneyMark> createState() => _UserJourneyMarkState();
}

class _UserJourneyMarkState extends State<UserJourneyMark> {
  String? mark;
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

  @override
  void initState() {
    super.initState();
    today = DateTime.now();

    minDate = DateTime(today.year, today.month - 2, 1);
    maxDate = DateTime(today.year, today.month, 31);
    getSelectedDays();
    getUserName();
    presentDaySelection();
    fetchProfileImage();
    checkJourney();
    getTicketData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.loadFromCache();
      print(dataProvider.isDataLoaded);

      if (!dataProvider.isDataLoaded) {
        // Only fetch data from the backend if it's not already loaded
        await getSelectedDays();
        await getUserName();
        await presentDaySelection();
        await fetchProfileImage();
        await checkJourney();
        await getTicketData();
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

  bool isButton1Disabled = true;
  bool isButton2Disabled = true;
  bool isStatement = false;
  String? currentDay;

  Future<void> checkJourney() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d').format(now);
    currentDay = formattedDate;

    String userId = widget.userId;
    String token = widget.token;
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/journey/user/checkJourney/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("response ${response.body}");

        mark = response.body;

        if (mark == "0") {
          isButton1Disabled = false;
          isButton2Disabled = true;
        } else if (mark == "1") {
          isButton1Disabled = true;
          isButton2Disabled = false;
        } else if (mark == "2") {
          isButton1Disabled = true;
          isButton2Disabled = true;
          isStatement = true;
        }
      } else {
        isButton1Disabled = true;
        isButton2Disabled = true;
      }
    } catch (e) {
      isButton1Disabled = true;
      isButton2Disabled = true;
    }
  }

  Future<void> getSelectedDays() async {
    String userId = widget.userId;
    String token = widget.token;
    if (widget.role.contains('STUDENT'.toUpperCase().trim())) {
      monday = 0;
      tuesday = 0;
      wensday = 0;
      friday = 0;
      thusday = 0;
      satuarday = 0;
      sunday = 0;
    } else if (widget.role == 'ADULT'.toUpperCase().trim()) {
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
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (tuesday == false) {
          this.tuesday = 2;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (wensday == false) {
          this.wensday = 3;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (thusday == false) {
          this.thusday = 4;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (friday == false) {
          this.friday = 5;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (satuarday == false) {
          this.satuarday = 6;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
        if (sunday == false) {
          this.sunday = 7;
          isButton1Disabled = true;
          isButton2Disabled = true;
        }
      }
    }
    print(this.tuesday);
  }

  Future<void> getUserName() async {
    String userId = widget.userId;
    String userToken = widget.token;
    var urlGetName = Uri.parse(
        'http://192.168.43.220:8080/api/v1/conductor/getName/$userId');
    final response1 = await http.get(urlGetName, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response1.statusCode == 200) {
      var getName = response1.body;
      userName = getName;
    } else {
      userName = "";
    }
  }

  Future<void> fetchProfileImage() async {
    String userToken = widget.token;
    String userId = widget.userId;

    try {
      var response = await http.get(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/conductor/profilePhoto/$userId'),
        headers: {
          'Authorization': 'Bearer $userToken',
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
    String userId = widget.userId;
    String userToken = widget.token;
    var url = Uri.parse(
        'http://192.168.43.220:8080/api/v1/journey/student/checkJourney/$userId/$formattedDate');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    });

    DateTime currentDate = DateTime(today.year, today.month, today.day);

    if (response.statusCode == 200) {
      int status = jsonDecode(response.body);
      setState(() {
        if (status == 0) {
          noJourney.add(dateToAdd);
        } else if (status == 1) {
          oneJourney.add(dateToAdd);
        } else if (status == 2) {
          twoJourney.add(dateToAdd);
        } else if (status == 500) {
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
        appBar: AppBar(
          title: const Text(
            'welcome back',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF881C34),
          toolbarHeight: 35.0,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(children: <Widget>[
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 600,
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
                        top: 165,
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
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.080,
                        top: 140,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 700,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 237, 237),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                          ),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  imageUrl.isNotEmpty
                                      ? ClipOval(
                                          child: Image.memory(
                                            base64Decode(imageUrl),
                                            width: 160,
                                            height: 170,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : CircularProgressIndicator(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(
                                      " $userName \n ${widget.role}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          height: 1.5,
                                          color: Color(0xFF881C34)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 200,
                                    height: 100,
                                    // ignore: sort_child_properties_last
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Current Purchase",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            height: 1.5,
                                            color: Color(0xFF881C34),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color(0x80881C20),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)))),
                                Container(
                                    width: 100,
                                    height: 100,
                                    // ignore: sort_child_properties_last
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        month,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                            color: Color(0xFF881C34)),
                                      ),
                                    ),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 180,
                                      height: 100,
                                      // ignore: sort_child_properties_last
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Validity Period",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              color: Color(0xFF881C34)),
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Color(0x80881C20),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft:
                                                  Radius.circular(20)))),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      // ignore: sort_child_properties_last
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          remainsDays,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              height: 1.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF881C34)),
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20)))),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                      const Positioned(
                          top: 43,
                          left: 20,
                          child: Text(
                            "View Passenger Details",
                            style: TextStyle(
                                fontSize: 20,
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
                        print(todayJourney);
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
                        print(noJourney);
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 58, 57, 57),
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
                Container(
                  child: isButton2Disabled && isButton1Disabled
                      ? const Text(
                          "Futhermore, there are no journeys.",
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF881C34)),
                        )
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              // ignore: sort_child_properties_last
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    " $currentDay",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF881C34)),
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                  color: Color(0x80262E7B),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)))),
                          Container(
                              width: 100,
                              height: 100,
                              // ignore: sort_child_properties_last
                              child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                      onPressed: isButton1Disabled
                                          ? null
                                          : () {
                                              // ignore: use_build_context_synchronously
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // User must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Validate Customer Journey.'),
                                                    content:
                                                        const SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              "Tap 'okay' to proceed and confirm your selected journey. Alternatively, press 'cancel' to resign from the marking process."),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          journeyMark();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Okay'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                      child: isButton1Disabled
                                          ? Image.asset("assets/right1.png")
                                          : Container(
                                              width: 50,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: const Text(
                                                "Mark",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        204, 216, 141, 12),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )))),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE3B2),
                              )),
                          Container(
                              width: 100,
                              height: 100,
                              // ignore: sort_child_properties_last
                              child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                      onPressed: isButton2Disabled
                                          ? null
                                          : () {
                                              // ignore: use_build_context_synchronously
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // User must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Validate Customer Journey.'),
                                                    content:
                                                        const SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              "Tap 'okay' to proceed and confirm your selected journey. Alternatively, press 'cancel' to resign from the marking process."),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          journeyMark();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Okay'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                      child: isButton2Disabled
                                          ? Image.asset("assets/right2.png")
                                          : Container(
                                              width: 50,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: const Text(
                                                "Mark",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xCC288932),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )))),
                              decoration: const BoxDecoration(
                                  color: Color(0x80288932),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)))),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: isButton2Disabled && isButton1Disabled
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Color.fromARGB(255, 236, 232, 233),
                                  backgroundColor: Color(0xFF881C34),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                          token: widget.token,
                                          conductorId: widget.conductorId),
                                    ),
                                  );
                                },
                                child: Text("Back"))
                            : null,
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.loadFromCache();

    await getUserName();
    await getSelectedDays();
    await presentDaySelection();
    await fetchProfileImage();
    await checkJourney();
    await getTicketData();

    dataProvider.updateData(
      userName: userName,
      imageUrl: imageUrl,
      noJourney: noJourney,
      oneJourney: oneJourney,
      twoJourney: twoJourney,
      blankJourney: blankJourney,
      isDataLoaded: true,
    );

    // Trigger a rebuild of the widget
    setState(() {});

    // Return a Future to indicate that the refresh is complete
    return Future.value();
  }

  Future<void> journeyMark() async {
    String token = widget.token;
    if (widget.role == "STUDENT".toUpperCase().trim()) {
      try {
        final response = await http.post(
            Uri.parse(
                'http://192.168.43.220:8080/api/v1/journey/student/update'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'userId': widget.userId,
              'hasJourney': 'true',
              'conductorId': widget.conductorId
            }));

        if (response.statusCode == 200) {
          String status = response.body;
          showDialog<void>(
            context: context,
            barrierDismissible: false, // User must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('$status'),
                content: const SingleChildScrollView(
                  child: ListBody(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                              token: token, conductorId: widget.conductorId),
                        ),
                      );
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
                title: const Text('Failed to mark the journey.'),
                content: const SingleChildScrollView(
                  child: ListBody(),
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
      } catch (e) {
        // ignore: use_build_context_synchronously
        showDialog<void>(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed to mark the journey.'),
              content: const SingleChildScrollView(
                child: ListBody(),
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
    } else if (widget.role == "ADULT".toUpperCase().trim()) {
      try {
        final response = await http.post(
            Uri.parse('http://192.168.43.220:8080/api/v1/journey/adult/update'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, String>{
              'userId': widget.userId,
              'hasJourney': 'true',
              'conductorId': widget.conductorId
            }));

        print(response.statusCode);

        if (response.statusCode == 200) {
          String status = response.body;
          // ignore: use_build_context_synchronously
          showDialog<void>(
            context: context,
            barrierDismissible: false, // User must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('$status'),
                content: const SingleChildScrollView(
                  child: ListBody(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                              token: token, conductorId: widget.conductorId),
                        ),
                      );
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
                title: const Text('Failed to mark the journey.'),
                content: const SingleChildScrollView(
                  child: ListBody(),
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
      } catch (e) {
        // ignore: use_build_context_synchronously
        showDialog<void>(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed to mark the journey.'),
              content: const SingleChildScrollView(
                child: ListBody(),
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
    }
  }

  String month = 'null';
  String remainsDays = 'null';
  Future<void> getTicketData() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/conductor/ticketStatus/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        String jsonResponse = response.body;
        Map<String, dynamic> responseData = json.decode(jsonResponse);
        month = responseData['month'];
        remainsDays = responseData['remainsDays'];
      }
    } catch (e) {
      print('error: ticket details retrive');
    }
  }
}
