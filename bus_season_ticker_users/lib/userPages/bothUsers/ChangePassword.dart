import 'dart:convert';

import 'package:bus_season_ticker_users/userPages/Loggin.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/DataProvider.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/PasswordChangeSucessful.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextCom = true;

  @override
  void dispose() {
    //properly disposed of when the State object is removed. This is essential to prevent memory leaks and unexpected behavior in your app
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool isPasswordValid(String password) {
    // Regular expression pattern to enforce password rules
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?]).{12,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                      } else {
                        bool isValid = isPasswordValid(value);

                        if (isValid) {
                          return null;
                        } else {
                          return 'Add Captical & simple letters,Symbols and numbers.';
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureTextCom,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureTextCom
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureTextCom = !_obscureTextCom;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 236, 232, 233),
                      backgroundColor: Color(0xFF881C34),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        ok();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 236, 232, 233),
                      backgroundColor: Color(0xFF881C34),
                    ),
                    onPressed: () {
                      cancel();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void cancel() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Are you sure, Would you like to cancel password change.'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tap "Okay" button to return to the home screen.'),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('okay'),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void ok() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    " Please, keep changed password in your mind. It will be help to next time to log."),
                Text("Thank you for your cooperation."),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('okay'),
                  onPressed: () {
                    forgotPassword();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> forgotPassword() async {
    String email = widget.email.toLowerCase().trim();
    final response = await http.put(
        Uri.parse(
            'http://192.168.43.220:8080/api/v1/auth/updatePassword/$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'password': _passwordController.text,
        }));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PasswordChangeSucessful()));
    } else {
      // ignore: use_build_context_synchronously
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Not allow you to change password. Reasons: You did not register yet or You are pending to take service from us.'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Tap "Okay" button to return to the home screen.'),
                ],
              ),
            ),
            actions: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                      child: const Text('okay'),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                    ),
                  ])
            ],
          );
        },
      );
    }
  }
}
