import 'package:bus_season_ticker_users/userRegister/Adult/AdultPersonalDetails.dart';
import 'package:bus_season_ticker_users/userRegister/student/PersonalDeatils.dart';
import 'package:flutter/material.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _selectUserState();
}

String selectedValue = 'Option 1';

class _selectUserState extends State<SelectUser> {
  bool isContinueButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Get Registered",
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("Select Your Category",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF881C34))),
                    const Text(
                        "Selecting the right category will help you to get the most cost effective season ticket.",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF881C34))),
                    const SizedBox(height: 40),
                    const Text("When Selecting the category,",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF881C34))),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 15, top: 10, bottom: 5),
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: const TextSpan(
                              text:
                                  '\u2022 ', // Unicode for bullet point symbol
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF881C34),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'If you are currently a student (under or above 18) of a school/university/ government or private institute, select ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                TextSpan(
                                  text: 'student.',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //next text
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: const TextSpan(
                              text:
                                  '\u2022 ', // Unicode for bullet point symbol
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF881C34),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'If you are above 18 and not a student of any institute (employed or unemployed), select ',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                TextSpan(
                                  text: 'Adult.',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Color(0xFFF4E4C5),
                width: 336,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Color(0xFFE9C88A),
                      child: const Text(
                        " I am a/an,",
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF881C34)),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Student'),
                      value: 'Student',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Adult'),
                      value: 'Adult',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 200),
              Container(
                padding: EdgeInsets.only(bottom: 0),
                height: 44,
                width: 245,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedValue == "Student") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PersonalDeatils()),
                      );
                    } else if (selectedValue == "Adult") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdultPersonalDeatils()),
                      );
                    } else {
                      const AlertDialog(
                        title: Text('Alert'),
                        content: Text('Please select an option.'),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF881C34), // Set the background color to blue
                    elevation: 5,
                    shadowColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
