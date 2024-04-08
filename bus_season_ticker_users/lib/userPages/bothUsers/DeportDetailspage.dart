import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class Depot {
  String title;
  String phoneNumber;

  Depot({required this.title, required this.phoneNumber});
}

class DepotDetailsPage extends StatefulWidget {
  @override
  _DepotDetailsPageState createState() => _DepotDetailsPageState();
}

class _DepotDetailsPageState extends State<DepotDetailsPage> {
  List<Depot> depots = [
    Depot(title: 'Depot 1', phoneNumber: '123-456-7890'),
    Depot(title: 'Depot 2', phoneNumber: '987-654-3210'),
    // Add more depots as needed
  ];

  List<Depot> filteredDepots = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDepots = depots;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(children: [
              Container(
                  width: double.infinity,
                  height: 175,
                  decoration: const BoxDecoration(
                    color: Color(0xFF881C34),
                    borderRadius: BorderRadius.only(),
                  )),
              const Positioned(
                  top: 25,
                  left: 20,
                  child: Text(
                    "Contact Info",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromARGB(236, 252, 250, 250)),
                  )),
              Positioned(
                top: 140,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 233, 234),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    )),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 233, 234),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(5000),
                      ),
                    )),
              ),
              Positioned(
                top: 10,
                right: 90,
                child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 241, 233, 234),
                        borderRadius: BorderRadius.all(Radius.circular(500)))),
              ),
              Positioned(
                top: 80,
                right: 50,
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 233, 234),
                        borderRadius: BorderRadius.all(Radius.circular(500)))),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text(
                    'Search by Depot Name',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF881C34)),
                  ),
                  Container(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return depots
                            .where((depot) =>
                                depot.title.toLowerCase().contains(pattern))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.title),
                          subtitle: Text(suggestion.phoneNumber),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        _copyToClipboard(suggestion.phoneNumber);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDepots.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredDepots[index].title),
                    subtitle: Text(filteredDepots[index].phoneNumber),
                    onTap: () =>
                        _copyToClipboard(filteredDepots[index].phoneNumber),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSearchTextChanged(String value) {
    setState(() {
      filteredDepots = depots
          .where((depot) =>
              depot.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _copyToClipboard(String text) {
    FlutterClipboard.copy(text).then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number copied to clipboard'),
        ),
      );
    });
  }
}
