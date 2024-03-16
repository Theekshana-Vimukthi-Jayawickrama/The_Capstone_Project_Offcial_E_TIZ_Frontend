import 'dart:convert';

import 'package:e_tiz_conductor_pages/Conductor/ChangePasswordVerfication.dart';
import 'package:e_tiz_conductor_pages/Conductor/DataProvider.dart';
import 'package:e_tiz_conductor_pages/Conductor/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Loggin extends StatefulWidget {
  const Loggin({super.key});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    //properly disposed of when the State object is removed. This is essential to prevent memory leaks and unexpected behavior in your app
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/auth/conductor/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _username.trim().toString().toLowerCase(),
          'password': _passwordController.text,
        }));

    if (response.statusCode == 200) {
      String jsonResponse = response.body;
      Map<String, dynamic> responseData = json.decode(jsonResponse);
      String userToken = responseData['token'];
      String userId = responseData['userId'];
      List<dynamic> role = responseData['role'];
      if (role.contains("CONDUCTOR".toUpperCase().trim())) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(token: userToken, conductorId: userId),
          ),
        );
      }
      DataProvider().updateData(
        isDataLoaded: false,
      );
      DataProvider().updateTicketData(
        isTicketDataLoaded: false,
      );
      DataProvider().updateMyAccountData(isMyAccountDataLoaded: false);
    } else {
      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User name and password do not match.'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Container(
                        height: 200,
                        width: 500,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 226, 190, 198),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(200)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xFF881C34),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(300),
                              bottomRight: Radius.circular(80)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0, right: 50),
                        child: Container(
                            height: 100,
                            child: Image.asset("assets/logo.png"))),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.0001,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Welcome!",
                          style:
                              TextStyle(color: Color(0xFF881C34), fontSize: 30),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Enter the user name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a your conductor ID as user name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              _formKey.currentState?.save();
                              forgotPassword(context);
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF881C34),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 236, 232, 233),
                            backgroundColor: Color(0xFF881C34),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                            }
                            _login(context);
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgotPassword(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordVerfication(
                  email: _username.trim().toString().toLowerCase(),
                )));
  }
}
