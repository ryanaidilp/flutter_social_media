import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/usecases/get_my_posts.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

@LazySingleton()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const _Initial()) {
    on<ProfileEvent>(
      (event, emit) async {
        if (event is _LoadInitialPosts) {
          emit(const ProfileState.loadingPosts());
          final result = await getMyPosts(const PaginationParam());
          result.fold(
            (l) => emit(ProfileState.loadingPostsFailed(page: 1, failure: l)),
            (r) => emit(ProfileState.loadingPostsSuccess(page: 1, data: r)),
          );
        } else if (event is _LoadMorePosts) {
          emit(const ProfileState.loadingPosts());
          final result = await getMyPosts(
            PaginationParam(
              page: event.page,
              perPage: event.perPage,
            ),
          );
          result.fold(
            (l) => emit(
              ProfileState.loadingPostsFailed(page: event.page, failure: l),
            ),
            (r) => emit(
              ProfileState.loadingPostsSuccess(page: event.page, data: r),
            ),
          );
        } else if (event is _PostsUpdatedEvent) {
          emit(const ProfileState.update());
        } else if (event is _PostsRefreshEvent) {
          emit(const ProfileState.refresh());
        }
      },
    );
  }

  final GetMyPosts getMyPosts = getIt<GetMyPosts>();
}
