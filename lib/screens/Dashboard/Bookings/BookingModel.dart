import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BookingModal {
  String modelDp;
  String modelEmail;
  String modelId;
  String modelInsta;
  String modelName;
  int order;
  String proposal;
  String rate;
  String role;
  String status;
  Timestamp time;
  String title;
  BookingModal({
    required this.modelDp,
    required this.modelEmail,
    required this.modelId,
    required this.modelInsta,
    required this.modelName,
    required this.order,
    required this.proposal,
    required this.rate,
    required this.role,
    required this.status,
    required this.time,
    required this.title,
  });

  BookingModal copyWith({
    String? modelDp,
    String? modelEmail,
    String? modelId,
    String? modelInsta,
    String? modelName,
    int? order,
    String? proposal,
    String? rate,
    String? role,
    String? status,
    Timestamp? time,
    String? title,
  }) {
    return BookingModal(
      modelDp: modelDp ?? this.modelDp,
      modelEmail: modelEmail ?? this.modelEmail,
      modelId: modelId ?? this.modelId,
      modelInsta: modelInsta ?? this.modelInsta,
      modelName: modelName ?? this.modelName,
      order: order ?? this.order,
      proposal: proposal ?? this.proposal,
      rate: rate ?? this.rate,
      role: role ?? this.role,
      status: status ?? this.status,
      time: time ?? this.time,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'modelDp': modelDp,
      'modelEmail': modelEmail,
      'modelId': modelId,
      'modelInsta': modelInsta,
      'modelName': modelName,
      'order': order,
      'proposal': proposal,
      'rate': rate,
      'role': role,
      'status': status,
      'time': time,
      'title': title,
    };
  }

  factory BookingModal.fromMap(Map<String, dynamic> map) {
    return BookingModal(
      modelDp: map['modelDp'],
      modelEmail: map['modelEmail'],
      modelId: map['modelId'],
      modelInsta: map['modelInsta'],
      modelName: map['modelName'],
      order: map['order'],
      proposal: map['proposal'],
      rate: map['rate'],
      role: map['role'],
      status: map['status'],
      time: map['time'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModal.fromJson(String source) =>
      BookingModal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingModal(modelDp: $modelDp, modelEmail: $modelEmail, modelId: $modelId, modelInsta: $modelInsta, modelName: $modelName, order: $order, proposal: $proposal, rate: $rate, role: $role, status: $status, time: $time, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingModal &&
        other.modelDp == modelDp &&
        other.modelEmail == modelEmail &&
        other.modelId == modelId &&
        other.modelInsta == modelInsta &&
        other.modelName == modelName &&
        other.order == order &&
        other.proposal == proposal &&
        other.rate == rate &&
        other.role == role &&
        other.status == status &&
        other.time == time &&
        other.title == title;
  }

  @override
  int get hashCode {
    return modelDp.hashCode ^
        modelEmail.hashCode ^
        modelId.hashCode ^
        modelInsta.hashCode ^
        modelName.hashCode ^
        order.hashCode ^
        proposal.hashCode ^
        rate.hashCode ^
        role.hashCode ^
        status.hashCode ^
        time.hashCode ^
        title.hashCode;
  }
}
