import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.photo,
  });
  final String id;
  final String name;
  final String? photo;
  final String email;
  final String username;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      photo,
      email,
      username,
    ];
  }
}
