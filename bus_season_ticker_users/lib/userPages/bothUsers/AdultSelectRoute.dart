import 'package:bus_season_ticker_users/userPages/bothUsers/AdultHomeBusRoute.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/AdultPayment.dart';
import 'package:bus_season_ticker_users/userPages/bothUsers/PaymentPage.dart';
import 'package:bus_season_ticker_users/userRegister/Adult/AdultBusRoute.dart';
import 'package:flutter/material.dart';

class AdultSelectRoute extends StatefulWidget {
  final String amount;

  const AdultSelectRoute({super.key, required this.amount});
  @override
  _AdultSelectRouteState createState() => _AdultSelectRouteState();
}

class _AdultSelectRouteState extends State<AdultSelectRoute> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ticket Page',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdultHomeBusRoute(),
                      ));
                },
                child: const Text('Purchase New Ticket',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          amount: widget.amount,
                        ),
                      ));
                },
                child: const Text('Existing Ticket',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
