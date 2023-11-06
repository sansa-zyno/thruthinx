import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModalForModel {
  String? clientDp;

  String? clientID;

  String? clientName;
  int? order;

  String? rate;
  String? role;
  String? status;
  Timestamp? time;
  String? title;
  BookingModalForModel({
    this.clientDp,
    this.clientID,
    this.clientName,
    this.order,
    this.rate,
    this.role,
    this.status,
    this.time,
    this.title,
  });

  BookingModalForModel copyWith({
    String? clientDp,
    String? clientID,
    String? clientName,
    int? order,
    String? rate,
    String? role,
    String? status,
    Timestamp? time,
    String? title,
  }) {
    return BookingModalForModel(
      clientDp: clientDp ?? this.clientDp,
      clientID: clientID ?? this.clientID,
      clientName: clientName ?? this.clientName,
      order: order ?? this.order,
      rate: rate ?? this.rate,
      role: role ?? this.role,
      status: status ?? this.status,
      time: time ?? this.time,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientDp': clientDp,
      'clientID': clientID,
      'clientName': clientName,
      'order': order,
      'rate': rate,
      'role': role,
      'status': status,
      'time': time,
      'title': title,
    };
  }

  factory BookingModalForModel.fromMap(Map<String, dynamic> map) {
    return BookingModalForModel(
      clientDp: map['clientDp'],
      clientID: map['clientID'],
      clientName: map['clientName'],
      order: map['order'],
      rate: map['rate'],
      role: map['role'],
      status: map['status'],
      time: map['time'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModalForModel.fromJson(String source) =>
      BookingModalForModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingModal(clientDp: $clientDp, clientID: $clientID, clientName: $clientName, order: $order, rate: $rate, role: $role, status: $status, time: $time, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingModalForModel &&
        other.clientDp == clientDp &&
        other.clientID == clientID &&
        other.clientName == clientName &&
        other.order == order &&
        other.rate == rate &&
        other.role == role &&
        other.status == status &&
        other.time == time &&
        other.title == title;
  }

  @override
  int get hashCode {
    return clientDp.hashCode ^
        clientID.hashCode ^
        clientName.hashCode ^
        order.hashCode ^
        rate.hashCode ^
        role.hashCode ^
        status.hashCode ^
        time.hashCode ^
        title.hashCode;
  }
}
