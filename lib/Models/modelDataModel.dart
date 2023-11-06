import 'dart:convert';

import 'package:flutter/foundation.dart';

class ModelDataModel {
  String? dp;
  DateTime? dpDate;
  bool? enablePushNotifications;
  int? hourlyRate;
  List<String>? bestPhotos = [];
  String? zipCode;
  String? phoneNumber;
  String? instaUserName;
  List<String>? categories = [];
  List<String>? skills = [];
  List<String>? personality = [];
  List<String>? attributes = [];
  String? nudityStatus;
  String? verification;
  ModelDataModel({
    this.dp,
    this.dpDate,
    this.enablePushNotifications,
    this.hourlyRate,
    this.bestPhotos,
    this.zipCode,
    this.phoneNumber,
    this.instaUserName,
    this.categories,
    this.skills,
    this.personality,
    this.attributes,
    this.nudityStatus,
    this.verification,
  });

  ModelDataModel copyWith({
    String? dp,
    DateTime? dpDate,
    bool? enablePushNotifications,
    int? hourlyRate,
    List<String>? bestPhotos,
    String? zipCode,
    String? phoneNumber,
    String? instaUserName,
    List<String>? categories,
    List<String>? skills,
    List<String>? personality,
    List<String>? attributes,
    String? nudityStatus,
    String? verification,
  }) {
    return ModelDataModel(
      dp: dp ?? this.dp,
      dpDate: dpDate ?? this.dpDate,
      enablePushNotifications:
          enablePushNotifications ?? this.enablePushNotifications,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      bestPhotos: bestPhotos ?? this.bestPhotos,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      instaUserName: instaUserName ?? this.instaUserName,
      categories: categories ?? this.categories,
      skills: skills ?? this.skills,
      personality: personality ?? this.personality,
      attributes: attributes ?? this.attributes,
      nudityStatus: nudityStatus ?? this.nudityStatus,
      verification: verification ?? this.verification,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dp': dp,
      'dpDate': dpDate!.millisecondsSinceEpoch,
      'enablePushNotifications': enablePushNotifications,
      'hourlyRate': hourlyRate,
      'bestPhotos': bestPhotos,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'instaUserName': instaUserName,
      'categories': categories,
      'skills': skills,
      'personality': personality,
      'attributes': attributes,
      'nudityStatus': nudityStatus,
      'verification': verification,
    };
  }

  factory ModelDataModel.fromMap(Map<String, dynamic> map) {
    return ModelDataModel(
      dp: map['dp'],
      dpDate: DateTime.fromMillisecondsSinceEpoch(map['dpDate']),
      enablePushNotifications: map['enablePushNotifications'],
      hourlyRate: map['hourlyRate'],
      bestPhotos: List<String>.from(map['bestPhotos']),
      zipCode: map['zipCode'],
      phoneNumber: map['phoneNumber'],
      instaUserName: map['instaUserName'],
      categories: List<String>.from(map['categories']),
      skills: List<String>.from(map['skills']),
      personality: List<String>.from(map['personality']),
      attributes: List<String>.from(map['attributes']),
      nudityStatus: map['nudityStatus'],
      verification: map['verification'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelDataModel.fromJson(String source) =>
      ModelDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ModelDataModel(dp: $dp, dpDate: $dpDate, enablePushNotifications: $enablePushNotifications, hourlyRate: $hourlyRate, bestPhotos: $bestPhotos, zipCode: $zipCode, phoneNumber: $phoneNumber, instaUserName: $instaUserName, categories: $categories, skills: $skills, personality: $personality, attributes: $attributes, nudityStatus: $nudityStatus, verification: $verification)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModelDataModel &&
        other.dp == dp &&
        other.dpDate == dpDate &&
        other.enablePushNotifications == enablePushNotifications &&
        other.hourlyRate == hourlyRate &&
        listEquals(other.bestPhotos, bestPhotos) &&
        other.zipCode == zipCode &&
        other.phoneNumber == phoneNumber &&
        other.instaUserName == instaUserName &&
        listEquals(other.categories, categories) &&
        listEquals(other.skills, skills) &&
        listEquals(other.personality, personality) &&
        listEquals(other.attributes, attributes) &&
        other.nudityStatus == nudityStatus &&
        other.verification == verification;
  }

  @override
  int get hashCode {
    return dp.hashCode ^
        dpDate.hashCode ^
        enablePushNotifications.hashCode ^
        hourlyRate.hashCode ^
        bestPhotos.hashCode ^
        zipCode.hashCode ^
        phoneNumber.hashCode ^
        instaUserName.hashCode ^
        categories.hashCode ^
        skills.hashCode ^
        personality.hashCode ^
        attributes.hashCode ^
        nudityStatus.hashCode ^
        verification.hashCode;
  }
}
