import 'package:bus_season_ticker_users/userPages/Loggin.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/DeportDetailspage.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/Home.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/MyAccount.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/RenewSeasonTicket.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomNavigationBarStu extends StatefulWidget {
  const bottomNavigationBarStu();

  @override
  State<bottomNavigationBarStu> createState() => _bottomNavigationBarStuState();
}

class _bottomNavigationBarStuState extends State<bottomNavigationBarStu> {
  int _currentIndex = 0;
  late List<Widget> _tabs;
  bool _isExecuting = false;
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
    _tabs = [Home(), RenewSeasonTicket(), MyAccount(), DepotDetailsPage()];
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
      child: Scaffold(
        extendBody: true,
        body: _tabs[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (!_isExecuting) {
                  // Only allow navigation if not currently executing
                  setState(() {
                    _currentIndex = index;
                  });
                  // help to make delayed
                  _simulateAsyncTask();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_moderator_rounded),
                  label: 'Ticket',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'My Account',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone),
                  label: 'Contact Infor',
                )
              ],
              // backgroundColor:
              unselectedItemColor: Colors.grey,
              selectedItemColor: Color(0xFF881C34)),
        ),
      ),
    );
  }

  void _simulateAsyncTask() async {
    setState(() {
      _isExecuting = true;
    });

    // Simulate an asynchronous task
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isExecuting = false;
    });
  }
}
