import 'package:bus_season_ticker_users/userRegister/GetStarted.dart';
import 'package:flutter/material.dart';

class AllSet extends StatefulWidget {
  const AllSet({super.key});

  @override
  State<AllSet> createState() => _AllSetState();
}

class _AllSetState extends State<AllSet> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back by returning false

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text(
                "Successful Verification",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
            backgroundColor: Color(0xFF881C34),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Registration Confirmation Notice.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset("assets/AllSet.png"),
                    )),
                const Positioned(
                  top: 300,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "Your registration will be successfully submitted. However, eligibility for our services is pending confirmation. We'll review your registration details within 24 hours and notify you via email. Please check your email frequently. Thank you for your cooperation.",
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 236, 232, 233),
                        backgroundColor: Color(0xFF881C34),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetStarted()));
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
