import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.photo,
  });
  final String id;
  final String name;
  final String username;
  final String email;
  final String? photo;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      username,
      email,
      photo,
    ];
  }
}
