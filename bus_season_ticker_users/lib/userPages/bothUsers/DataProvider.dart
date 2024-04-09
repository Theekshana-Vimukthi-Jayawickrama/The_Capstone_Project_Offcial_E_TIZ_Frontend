import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  // General data cache key
  static const String generalDataCacheKey = 'generalDataCache';

  // My account data cache key
  static const String myAccountDataCacheKey = 'myAccountDataCache';

  // Ticket data cache key
  static const String ticketDataCacheKey = 'ticketDataCache';

  String? userName;
  String imageUrl = '';
  List<DateTime> noJourney = [];
  List<DateTime> oneJourney = [];
  List<DateTime> twoJourney = [];
  List<DateTime> blankJourney = [];
  bool isDataLoaded = false;
  int monday = 0;
  int tuesday = 0;
  int wensday = 0;
  int friday = 0;
  int thusday = 0;
  int satuarday = 0;
  int sunday = 0;

  String purchaseDate = '';
  String? userName1;
  String expiredDate = '';
  int? remainDays;
  bool? verification;
  bool? purchaseAvailability;
  bool isTicketDataLoaded = false;
  static const String cacheKey = 'dataCache';
  String amount = '';
  bool? buttonStatus;
  bool? nextMonthSubcription;

  String purchaseDateMyAccount = '0000/00/00';
  String? monthName;
  String? route;
  String? routeNo;
  String? distance;
  String? charge;
  bool isMyAccountDataLoaded = false;
  String imageUrl1 = '';

  void updateData(
      {String? userName,
      String imageUrl = '',
      List<DateTime> noJourney = const [],
      List<DateTime> oneJourney = const [],
      List<DateTime> twoJourney = const [],
      List<DateTime> blankJourney = const [],
      bool? isDataLoaded,
      int? monday,
      int? tuesday,
      int? wensday,
      int? friday,
      int? thusday,
      int? satuarday,
      int? sunday,
      String? token,
      String? userId,
      List<String>? roles}) {
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.noJourney = noJourney;
    this.oneJourney = oneJourney;
    this.twoJourney = twoJourney;
    this.blankJourney = blankJourney;
    this.isDataLoaded = isDataLoaded!;
    this.monday = monday ?? 0;
    this.thusday = thusday ?? 0;
    this.tuesday = tuesday ?? 0;
    this.wensday = wensday ?? 0;
    this.friday = friday ?? 0;
    this.satuarday = satuarday ?? 0;
    this.sunday = sunday ?? 0;

    // Save data to cache
    _saveToCache();

    notifyListeners();
  }

//My account
  void updateMyAccountData(
      {String? userName1,
      String imageUrl1 = '',
      String purchaseDate = '0000/00/00',
      String? monthName,
      String? route,
      String? routeNo,
      String? distance,
      String? charge,
      bool isMyAccountDataLoaded = true}) {
    this.userName1 = userName1;
    this.imageUrl1 = imageUrl1;
    purchaseDateMyAccount = purchaseDate;
    this.monthName = monthName;
    this.route = route;
    this.routeNo = routeNo;
    this.distance = distance;
    this.charge = charge;
    this.isMyAccountDataLoaded = isMyAccountDataLoaded;

    // Save data to cache
    _saveToMyAccountCache();

    notifyListeners();
  }

  void _saveToMyAccountCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'userName': userName,
      'imageUrl1': imageUrl1,
      'purchaseDate': purchaseDateMyAccount,
      'monthName': monthName,
      'routeNo': routeNo,
      'distance': distance,
      'charge': charge,
      'route': route,
      'isMyAccountDataLoaded': isMyAccountDataLoaded
    };

    prefs.setString(myAccountDataCacheKey, jsonEncode(data));
  }

  Future<void> loadFromMyAccountCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(myAccountDataCacheKey);

    if (cachedData != null) {
      Map<String, dynamic> data = jsonDecode(cachedData);

      userName = data['userName'] ?? '';
      imageUrl1 = data['imageUrl1'] ?? '';
      purchaseDate = data['purchaseDate'] ?? '';
      monthName = data['monthName'] ?? '';
      routeNo = data['routeNo'] ?? '';
      distance = data['distance'] ?? '';
      route = data['route'] ?? '';
      charge = data['charge'] ?? '';
      isMyAccountDataLoaded = data['isMyAccountDataLoaded'] ?? false;

      notifyListeners();
    }
  }

  //get ticket data

  void updateTicketData({
    String purchaseDate = '0000-00-00',
    String expiredDate = '0000-00-00',
    int? remainDays,
    bool? nextMonthSubcription,
    bool? verification,
    bool? purchaseAvailability,
    bool? isTicketDataLoaded,
    String amount = '',
    bool? buttonStatus,
  }) {
    this.purchaseAvailability = purchaseAvailability;
    this.purchaseDate = purchaseDate;
    this.expiredDate = expiredDate;
    this.verification = verification;
    this.remainDays = remainDays;
    this.isTicketDataLoaded = isTicketDataLoaded!;
    this.amount = amount;
    this.buttonStatus = buttonStatus;
    this.nextMonthSubcription = nextMonthSubcription;

    // Save data to cache
    _saveTicketToCache();

    notifyListeners();
  }

  void _saveTicketToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'purchaseDate': purchaseDate,
      'expiredDate': expiredDate,
      'purchaseAvailability': purchaseAvailability,
      'remainDays': remainDays,
      'verification': verification,
      'isTicketDataLoaded': isTicketDataLoaded,
      'amount': amount,
      'buttonStatus': buttonStatus,
      'nextMonthSubcription': nextMonthSubcription
    };

    prefs.setString(ticketDataCacheKey, jsonEncode(data));
  }

  Future<void> loadFromTicketCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(ticketDataCacheKey);

    if (cachedData != null) {
      Map<String, dynamic> data = jsonDecode(cachedData);

      purchaseDate = data['purchaseDate'] ?? '';
      expiredDate = data['expiredDate'] ?? '';
      purchaseAvailability = data['purchaseAvailability'] ?? null;
      remainDays = data['remainDays'] ?? 0;
      verification = data['verification'] ?? null;
      isTicketDataLoaded = data['isTicketDataLoaded'] ?? true;
      amount = data['amount'] ?? null;
      buttonStatus = data['buttonStatus'] ?? false;
      nextMonthSubcription = data['nextMonthSubcription'] ?? false;
      notifyListeners();
    }
  }

  void _saveToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'userName': userName,
      'imageUrl': imageUrl,
      'noJourney': noJourney.map((date) => date.toIso8601String()).toList(),
      'oneJourney': oneJourney.map((date) => date.toIso8601String()).toList(),
      'twoJourney': twoJourney.map((date) => date.toIso8601String()).toList(),
      'blankJourney':
          blankJourney.map((date) => date.toIso8601String()).toList(),
      'isDataLoaded': isDataLoaded,
      'monday': monday,
      'tuesday': tuesday,
      'wensday': wensday,
      'thusday': thusday,
      'friday': friday,
      'satuarday': satuarday,
      'sunday': sunday
    };

    prefs.setString(generalDataCacheKey, jsonEncode(data));
  }

  Future<void> loadFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(generalDataCacheKey);

    if (cachedData != null) {
      Map<String, dynamic> data = jsonDecode(cachedData);

      userName = data['userName'] ?? ''; // use empty string as a default value
      imageUrl = data['imageUrl'] ?? ''; // use empty string as a default value
      noJourney = (data['noJourney'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date.toString()))
              .toList() ??
          [];

      oneJourney = (data['oneJourney'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date.toString()))
              .toList() ??
          [];
      twoJourney = (data['twoJourney'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date.toString()))
              .toList() ??
          [];
      blankJourney = (data['blankJourney'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date.toString()))
              .toList() ??
          [];
      isDataLoaded = data['isDataLoaded'] ?? false;

      monday = data['monday'] ?? 0;
      tuesday = data['tuesday'] ?? 0;
      wensday = data['wensday'] ?? 0;
      thusday = data['thusday'] ?? 0;
      friday = data['friday'] ?? 0;
      satuarday = data['satuarday'] ?? 0;
      sunday = data['sunday'] ?? 0;

      notifyListeners();
    }
  }
}
