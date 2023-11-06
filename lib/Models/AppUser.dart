import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  String? email;
  String? first_name;
  String? last_name;
  String? role;
  String? gender;
  String? verification;
  String? instagram;
  List<String>? cetegories;
  AppUser({
    this.email,
    this.first_name,
    this.last_name,
    this.role,
    this.gender,
    this.verification,
    this.instagram,
    this.cetegories,
  });

  AppUser copyWith({
    String? email,
    String? first_name,
    String? last_name,
    String? role,
    String? gender,
    String? verification,
    String? instagram,
    List<String>? cetegories,
  }) {
    return AppUser(
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      verification: verification ?? this.verification,
      instagram: instagram ?? this.instagram,
      cetegories: cetegories ?? this.cetegories,
    );
  }

  factory AppUser.fromPreferences(
      List<String> userData, List<String> categories) {
    return AppUser(
      email: userData[0],
      first_name: userData[1],
      last_name: userData[2],
      role: userData[3],
      gender: userData[4],
      verification: userData[5],
      instagram: userData[6] ?? "default",
      cetegories: categories ?? [],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'role': role,
      'gender': gender,
      'verification': verification,
      'instagram': instagram,
      'cetegories': cetegories,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      role: map['role'],
      gender: map['gender'],
      verification: map['verification'],
      instagram: map['instagram'],
      cetegories: List<String>.from(map['cetegories']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(email: $email, first_name: $first_name, last_name: $last_name, role: $role, gender: $gender, verification: $verification, instagram: $instagram, cetegories: $cetegories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.email == email &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.role == role &&
        other.gender == gender &&
        other.verification == verification &&
        other.instagram == instagram &&
        listEquals(other.cetegories, cetegories);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        role.hashCode ^
        gender.hashCode ^
        verification.hashCode ^
        instagram.hashCode ^
        cetegories.hashCode;
  }
}
