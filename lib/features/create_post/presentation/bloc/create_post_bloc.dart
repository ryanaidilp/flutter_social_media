import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/usecases/create_post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';
part 'create_post_bloc.freezed.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc() : super(const _Initial()) {
    on<CreatePostEvent>((event, emit) async {
      if (event is _Create) {
        emit(const CreatePostState.creating());
        final result = await createPost(
          CreatePostParam(
            userID: event.userID,
            description: event.description,
            image: event.image,
          ),
        );
        result.fold(
          (l) => emit(CreatePostState.failed(failure: l)),
          (r) => emit(CreatePostState.success(post: r)),
        );
      }
    });
  }

  final createPost = getIt<CreatePost>();
}
