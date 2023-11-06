import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ModelProposal {
  String proposal;
  String clientId;
  String clientEmail;
  String clientName;
  int order;
  Timestamp time;
  String clientDP;
  int rate;
  ModelProposal({
    required this.proposal,
    required this.clientId,
    required this.clientEmail,
    required this.clientName,
    required this.order,
    required this.time,
    required this.clientDP,
    required this.rate,
  });

  ModelProposal copyWith({
    String? proposal,
    String? clientId,
    String? clientEmail,
    String? clientName,
    int? order,
    Timestamp? time,
    String? clientDP,
    int? rate,
  }) {
    return ModelProposal(
      proposal: proposal ?? this.proposal,
      clientId: clientId ?? this.clientId,
      clientEmail: clientEmail ?? this.clientEmail,
      clientName: clientName ?? this.clientName,
      order: order ?? this.order,
      time: time ?? this.time,
      clientDP: clientDP ?? this.clientDP,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'proposal': proposal,
      'clientId': clientId,
      'clientEmail': clientEmail,
      'clientName': clientName,
      'order': order,
      'time': time,
      'clientDP': clientDP,
      'rate': rate,
    };
  }

  factory ModelProposal.fromMap(Map<String, dynamic> map) {
    return ModelProposal(
      proposal: map['proposal'],
      clientId: map['clientId'],
      clientEmail: map['clientEmail'],
      clientName: map['clientName'],
      order: map['order'],
      time: map['time'],
      clientDP: map['clientDP'],
      rate: map['rate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelProposal.fromJson(String source) =>
      ModelProposal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ModelProposal(proposal: $proposal, clientId: $clientId, clientEmail: $clientEmail, clientName: $clientName, order: $order, time: $time, clientDP: $clientDP, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModelProposal &&
        other.proposal == proposal &&
        other.clientId == clientId &&
        other.clientEmail == clientEmail &&
        other.clientName == clientName &&
        other.order == order &&
        other.time == time &&
        other.clientDP == clientDP &&
        other.rate == rate;
  }

  @override
  int get hashCode {
    return proposal.hashCode ^
        clientId.hashCode ^
        clientEmail.hashCode ^
        clientName.hashCode ^
        order.hashCode ^
        time.hashCode ^
        clientDP.hashCode ^
        rate.hashCode;
  }
}

class ClientProposal {
  String proposal;
  String modelId;
  String modelEmail;
  String modelName;
  int order;
  Timestamp time;
  String modelDp;
  int rate;
  ClientProposal({
    required this.proposal,
    required this.modelId,
    required this.modelEmail,
    required this.modelName,
    required this.order,
    required this.time,
    required this.modelDp,
    required this.rate,
  });

  ClientProposal copyWith({
    String? proposal,
    String? modelId,
    String? modelEmail,
    String? modelName,
    int? order,
    Timestamp? time,
    String? modelDp,
    int? rate,
  }) {
    return ClientProposal(
      proposal: proposal ?? this.proposal,
      modelId: modelId ?? this.modelId,
      modelEmail: modelEmail ?? this.modelEmail,
      modelName: modelName ?? this.modelName,
      order: order ?? this.order,
      time: time ?? this.time,
      modelDp: modelDp ?? this.modelDp,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'proposal': proposal,
      'modelId': modelId,
      'modelEmail': modelEmail,
      'modelName': modelName,
      'order': order,
      'time': time,
      'modelDp': modelDp,
      'rate': rate,
    };
  }

  factory ClientProposal.fromMap(Map<String, dynamic> map) {
    return ClientProposal(
      proposal: map['proposal'],
      modelId: map['modelId'],
      modelEmail: map['modelEmail'],
      modelName: map['modelName'],
      order: map['order'],
      time: map['time'],
      modelDp: map['modelDp'],
      rate: map['rate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientProposal.fromJson(String source) =>
      ClientProposal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClientProposal(proposal: $proposal, modelId: $modelId, modelEmail: $modelEmail, modelName: $modelName, order: $order, time: $time, modelDp: $modelDp, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientProposal &&
        other.proposal == proposal &&
        other.modelId == modelId &&
        other.modelEmail == modelEmail &&
        other.modelName == modelName &&
        other.order == order &&
        other.time == time &&
        other.modelDp == modelDp &&
        other.rate == rate;
  }

  @override
  int get hashCode {
    return proposal.hashCode ^
        modelId.hashCode ^
        modelEmail.hashCode ^
        modelName.hashCode ^
        order.hashCode ^
        time.hashCode ^
        modelDp.hashCode ^
        rate.hashCode;
  }
}
