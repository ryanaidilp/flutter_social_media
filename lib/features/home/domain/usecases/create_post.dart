import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CreatePost implements UseCase<Post, CreatePostParam, PostRepository> {
  @override
  Future<Either<Failure, Post>> call(CreatePostParam param) => repo.createPost(
        userID: param.userID,
        description: param.description,
        image: param.image,
      );

  @override
  PostRepository get repo => getIt<PostRepository>();
}

class CreatePostParam extends Equatable {
  const CreatePostParam({
    required this.userID,
    required this.description,
    required this.image,
  });
  final String userID;
  final String description;
  final File image;
  @override
  List<Object> get props => [userID, description, image];
}
