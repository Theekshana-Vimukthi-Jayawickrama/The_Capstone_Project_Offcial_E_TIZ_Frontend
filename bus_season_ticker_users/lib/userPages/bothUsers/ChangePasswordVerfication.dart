import 'package:bus_season_ticker_users/userPages/bothUsers/ChangePasswordOTPVerfication.dart';
import 'package:bus_season_ticker_users/userRegister/student/OTPVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordVerfication extends StatefulWidget {
  final String email;
  const ChangePasswordVerfication({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordVerfication> createState() =>
      _ChangePasswordVerficationState();
}

class _ChangePasswordVerficationState extends State<ChangePasswordVerfication> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> sendOTP(
    userEmail,
    BuildContext context,
  ) async {
    String email = widget.email.trim().toLowerCase();
    String typedEmail = userEmail
        .toString()
        .trim()
        .toLowerCase(); //remove leading and trailing whitespace (spaces, tabs, newlines, etc.) from a string.

    if (typedEmail == email) {
      var url = Uri.parse('http://192.168.43.220:8080/api/v1/auth/sendOTP');
      var response = (await http.post(url, body: {'email': typedEmail}));
      String responseBody = response.body;

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePasswordOTPVerfication(
                      email: widget.email,
                    )));
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
              "Please, Enter your email that previous you entered at loggin."),
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Email'),
        // automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
    );
  }
}
