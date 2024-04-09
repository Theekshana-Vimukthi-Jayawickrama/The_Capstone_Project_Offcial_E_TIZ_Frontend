import 'package:e_tiz_conductor_pages/Conductor/ChangePasswordOTPVerfication.dart';
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
    String userName = userEmail
        .toString()
        .trim()
        .toLowerCase(); //remove leading and trailing whitespace (spaces, tabs, newlines, etc.) from a string.

    var url =
        Uri.parse('http://192.168.43.220:8080/api/v1/auth/sendOTP/${userName}');
    var response = (await http.get(url));
    String responseBody = response.body;

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordOTPVerfication(
                  email: response.body, userName: userName)));
    } else {
      String message = responseBody as String;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter User Name'),
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
                        labelText: 'Enter User Name',
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
