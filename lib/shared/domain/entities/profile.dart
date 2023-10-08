import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    this.photo,
  });
  final String id;
  final String name;
  final String? photo;
  final String email;
  final String username;
  final int postCount;
  final int followersCount;
  final int followingCount;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      photo,
      email,
      username,
      postCount,
      followersCount,
      followingCount,
    ];
  }
}
