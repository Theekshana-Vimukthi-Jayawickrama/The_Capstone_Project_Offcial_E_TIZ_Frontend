import 'package:flutter/material.dart';

class UserData {
  String? userName;
  String imageUrl;
  List<DateTime> noJourney;
  List<DateTime> oneJourney;
  List<DateTime> twoJourney;
  List<DateTime> blankJourney;
  List<DateTime> todayJourney;

  UserData({
    this.userName,
    required this.imageUrl,
    required this.noJourney,
    required this.oneJourney,
    required this.twoJourney,
    required this.blankJourney,
    required this.todayJourney,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['userName'],
      imageUrl: json['imageUrl'],
      noJourney: List<DateTime>.from(
          json['noJourney'].map((date) => DateTime.parse(date))),
      oneJourney: List<DateTime>.from(
          json['oneJourney'].map((date) => DateTime.parse(date))),
      twoJourney: List<DateTime>.from(
          json['twoJourney'].map((date) => DateTime.parse(date))),
      blankJourney: List<DateTime>.from(
          json['blankJourney'].map((date) => DateTime.parse(date))),
      todayJourney: List<DateTime>.from(
          json['todayJourney'].map((date) => DateTime.parse(date))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'imageUrl': imageUrl,
      'noJourney': noJourney.map((date) => date.toIso8601String()).toList(),
      'oneJourney': oneJourney.map((date) => date.toIso8601String()).toList(),
      'twoJourney': twoJourney.map((date) => date.toIso8601String()).toList(),
      'blankJourney':
          blankJourney.map((date) => date.toIso8601String()).toList(),
      'todayJourney':
          todayJourney.map((date) => date.toIso8601String()).toList(),
    };
  }
}
