import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String password;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    this.createdAt,
  });

  User.login({
    required this.uid,
    required this.email,
    required this.name,
  })  : password = '',
        createdAt = null;

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email}';
  }
}