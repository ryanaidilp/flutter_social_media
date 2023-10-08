import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/usecases/get_user_posts.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_post_event.dart';
part 'user_post_state.dart';
part 'user_post_bloc.freezed.dart';

class UserPostBloc extends Bloc<UserPostEvent, UserPostState> {
  UserPostBloc() : super(const _Initial()) {
    on<UserPostEvent>((event, emit) async {
      if (event is _LoadInitialPosts) {
        emit(const UserPostState.loading());
        final result = await getIt<GetUserPosts>().call(
          GetUserPostsParam(
            username: event.username,
            perPage: event.perPage,
          ),
        );
        result.fold(
          (l) => emit(UserPostState.error(page: 1, failure: l)),
          (r) => emit(UserPostState.success(page: 1, posts: r)),
        );
      } else if (event is _LoadMorePosts) {
        emit(const UserPostState.loading());
        final result = await getIt<GetUserPosts>().call(
          GetUserPostsParam(
            page: event.page,
            username: event.username,
            perPage: event.perPage,
          ),
        );
        result.fold(
          (l) => emit(
            UserPostState.error(
              page: event.page,
              failure: l,
            ),
          ),
          (r) => emit(
            UserPostState.success(
              page: event.page,
              posts: r,
            ),
          ),
        );
      } else if (event is _PostsRefreshEvent) {
        emit(const UserPostState.refresh());
      }
    });
  }
}
