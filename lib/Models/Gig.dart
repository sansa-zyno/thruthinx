import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Gig {
  String clientName;
  String clientID;
  Timestamp dateCreated;
  int gigOrder;
  String clientDp;
  String title;
  String role;
  String gender;
  String desc;
  String requirements;
  String hourlyRate;
  Gig({
    required this.clientName,
    required this.clientID,
    required this.dateCreated,
    required this.gigOrder,
    required this.clientDp,
    required this.title,
    required this.role,
    required this.gender,
    required this.desc,
    required this.requirements,
    required this.hourlyRate,
  });

  Gig copyWith({
    String? clientName,
    String? clientID,
    Timestamp? dateCreated,
    int? gigOrder,
    String? clientDp,
    String? title,
    String? role,
    String? gender,
    String? desc,
    String? requirements,
    String? hourlyRate,
  }) {
    return Gig(
      clientName: clientName ?? this.clientName,
      clientID: clientID ?? this.clientID,
      dateCreated: dateCreated ?? this.dateCreated,
      gigOrder: gigOrder ?? this.gigOrder,
      clientDp: clientDp ?? this.clientDp,
      title: title ?? this.title,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      desc: desc ?? this.desc,
      requirements: requirements ?? this.requirements,
      hourlyRate: hourlyRate ?? this.hourlyRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientID': clientID,
      'dateCreated': dateCreated,
      'gigOrder': gigOrder,
      'clientDp': clientDp,
      'title': title,
      'role': role,
      'gender': gender,
      'desc': desc,
      'requirements': requirements,
      'hourlyRate': hourlyRate,
    };
  }

  factory Gig.fromMap(Map<String, dynamic> map) {
    return Gig(
      clientName: map['clientName'],
      clientID: map['clientID'],
      dateCreated: map['dateCreated'],
      gigOrder: map['gigOrder'],
      clientDp: map['clientDp'],
      title: map['title'],
      role: map['role'],
      gender: map['gender'],
      desc: map['desc'],
      requirements: map['requirements'],
      hourlyRate: map['hourlyRate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Gig.fromJson(String source) => Gig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Gig(clientName: $clientName, clientID: $clientID, dateCreated: $dateCreated, gigOrder: $gigOrder, clientDp: $clientDp, title: $title, role: $role, gender: $gender, desc: $desc, requirements: $requirements, hourlyRate: $hourlyRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Gig &&
        other.clientName == clientName &&
        other.clientID == clientID &&
        other.dateCreated == dateCreated &&
        other.gigOrder == gigOrder &&
        other.clientDp == clientDp &&
        other.title == title &&
        other.role == role &&
        other.gender == gender &&
        other.desc == desc &&
        other.requirements == requirements &&
        other.hourlyRate == hourlyRate;
  }

  @override
  int get hashCode {
    return clientName.hashCode ^
        clientID.hashCode ^
        dateCreated.hashCode ^
        gigOrder.hashCode ^
        clientDp.hashCode ^
        title.hashCode ^
        role.hashCode ^
        gender.hashCode ^
        desc.hashCode ^
        requirements.hashCode ^
        hourlyRate.hashCode;
  }
}
