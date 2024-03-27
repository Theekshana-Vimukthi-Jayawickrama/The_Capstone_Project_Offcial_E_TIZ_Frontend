import 'package:bus_season_ticker_users/userRegister/GetStarted.dart';
import 'package:bus_season_ticker_users/userRegister/SelectingUser.dart';
import 'package:flutter/material.dart';

class RegNotice extends StatefulWidget {
  const RegNotice({super.key});

  @override
  State<RegNotice> createState() => _RegNoticeState();
}

class _RegNoticeState extends State<RegNotice> {
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
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      const Text(
                          "Getting Registered in our app allows you to create an account on BST on your own and enjoy our free services online.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color(0xFF881C34), fontSize: 15)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          "Before getting registered, we invite you to take the followings to your notice.",
                          style: TextStyle(
                              color: Color(0xFF881C34), fontSize: 15)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: EdgeInsets.all(10),
                        color: Color(0xFFE9C88A),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "This consists of ",
                                style: TextStyle(
                                    color: Color(0xFF881C34), fontSize: 15)),
                            TextSpan(
                                text: " five ",
                                style: TextStyle(
                                    color: Color(0xFF881C34),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "sections: Personal Details, Documents, Route, Verification and Payment.",
                                style: TextStyle(
                                    color: Color(0xFF881C34), fontSize: 15)),
                          ]),
                        ),
                      ),
                      //next section
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        color: Color(0xFFF4E4C5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Color(0xFFE9C88A),
                              child: const Text(
                                  "While registering you have to upload the soft copies of the followings.",
                                  style: TextStyle(
                                      color: Color(0xFF881C34), fontSize: 15)),
                            ),
                            SizedBox(height: 10),
                            const Text("If you are a student,",
                                style: TextStyle(
                                    color: Color(0xFF881C34),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
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
                                        'A copy of Birth Certificate. (File format should be PDF.)',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
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
                                        'An approval Letter Signed By The Principal.(File format should be PDF.)',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
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
                                        'A Passport Sized Photo. (As image type)',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            const Text("If you are an adult,",
                                style: TextStyle(
                                    color: Color(0xFF881C34),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
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
                                    text: 'NIC. (As image type)',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
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
                                        'A Passport Sized Photo. (As image type)',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          color: Color(0xFFE9C88A),
                          child: const Text(
                            "Once you are done providing necessary details, you have do the payment here itself. ",
                            style: TextStyle(
                                color: Color(0xFF881C34), fontSize: 15),
                          ))
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 44,
                width: 245,
                decoration: const BoxDecoration(
                    color: Color(0xFF881C34),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SelectUser()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF881C34), // Set the background color to blue
                    elevation:
                        5, // Set the elevation when the button is pressed
                    shadowColor: Colors.blueAccent, // Set the shadow color
                  ),
                  child: const Text(
                    "ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                height: 44,
                width: 245,
                decoration: BoxDecoration(
                    color: Color(0xFF881C34),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, GetStarted());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF881C34), // Set the background color to blue
                    elevation:
                        5, // Set the elevation when the button is pressed
                    shadowColor: Colors.blueAccent, // Set the shadow color
                  ),
                  child: const Text(
                    "Go Back",
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
