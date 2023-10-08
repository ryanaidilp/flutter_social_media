import 'package:equatable/equatable.dart';

import 'package:flutter_social/features/users/domain/entities/user.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.user,
  });

  final String id;
  final String image;
  final String description;
  final DateTime createdAt;
  final User user;

  @override
  List<Object> get props {
    return [
      id,
      image,
      description,
      createdAt,
      user,
    ];
  }
}
