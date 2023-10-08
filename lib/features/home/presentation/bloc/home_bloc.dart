import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/domain/usecases/get_all_posts.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@LazySingleton()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const _Initial()) {
    on<HomeEvent>(
      (event, emit) async {
        if (event is _LoadInitialPostEvent) {
          emit(const HomeState.loadingPosts());
          final result = await getAllPosts(
            PaginationParam(
              perPage: event.perPage,
            ),
          );

          result.fold(
            (l) => emit(HomeState.loadingPostsFailed(failure: l, page: 1)),
            (r) => emit(HomeState.loadingPostsSuccess(data: r, page: 1)),
          );
        } else if (event is _LoadMorePostEvent) {
          emit(const HomeState.loadingPosts());
          final result = await getAllPosts(
            PaginationParam(
              page: event.page,
              perPage: event.perPage,
            ),
          );

          result.fold(
            (l) => emit(
              HomeState.loadingPostsFailed(
                failure: l,
                page: event.page,
              ),
            ),
            (r) => emit(
              HomeState.loadingPostsSuccess(
                data: r,
                page: event.page,
              ),
            ),
          );
        } else if (event is _PostUpdatedEvent) {
          emit(const HomeState.update());
        } else if (event is _PostRefreshEvent) {
          emit(const HomeState.refresh());
        }
      },
    );
  }

  final getAllPosts = getIt<GetAllPosts>();
}
