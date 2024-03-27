import 'package:bus_season_ticker_users/userPages/Loggin.dart';
import 'package:bus_season_ticker_users/userRegister/RegNotice.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _getStartedState();
}

class _getStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 115.0),
              Center(child: Image.asset("assets/logo.png")),
              SizedBox(height: 75.0),
              Container(
                height: 502,
                width: 430,
                padding: EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    color: Color(0xFF881C34),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Welcome to E-Tickz!',
                      style:
                          TextStyle(fontSize: 40.0, color: Color(0xFFFFFFFF)),
                    ),
                    const Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15.0, color: Color(0xFFFFFFFF)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      height: 44,
                      width: 245,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Loggin()));
                        },
                        child: const Text(
                          "Log In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF881C34),
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Don’t have an account?',
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      height: 44,
                      width: 245,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegNotice()),
                          );
                        },
                        child: const Text(
                          "Get Registered",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF881C34),
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
