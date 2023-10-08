import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    this.photo,
  });
  final String id;
  final String name;
  final String username;
  final String email;
  final String? photo;
  final int postCount;
  final int followersCount;
  final int followingCount;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      username,
      email,
      photo,
      postCount,
      followersCount,
      followingCount,
    ];
  }
}
