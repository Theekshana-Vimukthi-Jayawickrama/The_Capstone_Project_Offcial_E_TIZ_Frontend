import 'dart:ffi';
import 'package:bus_season_ticker_users/userRegister/Adult/AdultOTPScreen.dart';
import 'package:bus_season_ticker_users/userRegister/student/OTPVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdultEmailVerfication extends StatefulWidget {
  const AdultEmailVerfication({
    super.key,
  });

  @override
  State<AdultEmailVerfication> createState() => _AdultEmailVerficationState();
}

class _AdultEmailVerficationState extends State<AdultEmailVerfication> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences _prefs;
  String? email;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      email = _prefs.getString('email');
    });
  }

  Future<void> sendOTP(
    userEmail,
    BuildContext context,
  ) async {
    String typedEmail = userEmail
        .toString()
        .trim()
        .toLowerCase(); //remove leading and trailing whitespace (spaces, tabs, newlines, etc.) from a string.

    if (typedEmail == email.toString().trim().toLowerCase()) {
      var url = Uri.parse('http://192.168.43.220:8080/api/v1/auth/sendOTP');
      var response = (await http.post(url, body: {'email': typedEmail}));
      String responseBody = response.body;

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdultOTPScreen()));
      } else {
        String message = responseBody as String;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please, Enter your email that previous you entered at personal details page."),
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF881C34),
          title: const Text('Enter Email',
              style: TextStyle(color: Color(0xFFFFFFFF))),
          // automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 200,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Enter Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            sendOTP(_emailController.text, context);
                          }
                        },
                        child: Text('Send OTP'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
