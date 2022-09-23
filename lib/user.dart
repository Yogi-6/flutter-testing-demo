// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String id;
  final String name;
  final int age;

  const User(this.id, this.age, this.name);

  @override
  String toString() => 'User(id: $id, name: $name, age: $age)';
}
