import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for clipboard functionality
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Depot {
  String depotName;
  String phoneNumber;
  String phoneNumber2;
  int id;

  Depot({
    required this.depotName,
    required this.phoneNumber,
    required this.phoneNumber2,
    required this.id,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      depotName: json['depotName'],
      phoneNumber: json['phoneNumber'].toString(),
      phoneNumber2: json['phoneNumber2'].toString(),
      id: json['id'],
    );
  }
}

class DepotDetailsPage extends StatefulWidget {
  @override
  _DepotDetailsPageState createState() => _DepotDetailsPageState();
}

class _DepotDetailsPageState extends State<DepotDetailsPage> {
  List<Depot> depots = [];

  @override
  void initState() {
    super.initState();
    fetchDepots();
  }

  Future<void> fetchDepots() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.220:8080/api/v1/depot/getAllDepots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        depots = data.map((e) => Depot.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to load depots');
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 175,
                    decoration: BoxDecoration(
                      color: Color(0xFF881C34),
                      borderRadius: BorderRadius.only(),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 20,
                    child: Text(
                      "Contact Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromARGB(236, 252, 250, 250),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 233, 234),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 233, 234),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(5000),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 90,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 233, 234),
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 50,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 233, 234),
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Search by Depot Name',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF881C34),
                      ),
                    ),
                    Container(
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return depots
                              .where((depot) => depot.depotName
                                  .toLowerCase()
                                  .contains(pattern))
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.depotName),
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
                  itemCount: depots.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(depots[index].depotName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone Number: ${depots[index].phoneNumber}"),
                          Text("Second Number: ${depots[index].phoneNumber2}"),
                        ],
                      ),
                      onTap: () => _copyToClipboard(depots[index].phoneNumber),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _copyToClipboard(String text) {
    Clipboard.setData(
        ClipboardData(text: text)); // This copies the text to the clipboard
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Phone number copied to clipboard: $text'),
    ));
  }

  Future<void> _refreshData() async {
    await fetchDepots();
  }
}
