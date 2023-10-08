import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_social/core/extension/widget_x.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/users/domain/enums/user_action.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_detail_bloc.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_follow_bloc.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_post_bloc.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_infinite_scroll.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_post_card.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_profile_header.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage<UserAction?>()
class UserDetailPage extends StatefulWidget {
  const UserDetailPage({
    required this.username,
    this.isFollowing = false,
    super.key,
  });

  final String username;
  final bool isFollowing;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late final ScrollController scrollController;
  late final ScrollController mainScrollController;
  late final RefreshController refreshController;
  late final PagingController<int, Post> pagingController;

  late final UserDetailBloc userDetailBloc;
  late final UserPostBloc userPostBloc;
  late final UserFollowBloc userFollowBloc;

  void _pageRequestListener(int pageKey) => userPostBloc.add(
        UserPostEvent.loadMorePosts(username: widget.username, page: pageKey),
      );

  @override
  void initState() {
    super.initState();
    userDetailBloc = UserDetailBloc()
      ..add(
        UserDetailEvent.loadProfile(username: widget.username),
      );
    userPostBloc = UserPostBloc();
    userFollowBloc = UserFollowBloc();
    mainScrollController = ScrollController();
    scrollController = ScrollController();
    refreshController = RefreshController();
    pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
        _pageRequestListener,
      );
  }

  @override
  void dispose() {
    userDetailBloc.close();
    userPostBloc.close();
    userFollowBloc.close();
    mainScrollController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    pagingController
      ..removePageRequestListener(_pageRequestListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserPostBloc, UserPostState>(
            bloc: userPostBloc,
            listener: (context, state) async {
              if (state is UserPostLoaded) {
                final data = state.posts;

                final isLastPage = !(data.pagination?.hasMorePages ?? false);

                if (isLastPage) {
                  pagingController.appendLastPage(data.data ?? []);
                } else {
                  pagingController.appendPage(data.data ?? [], state.page + 1);
                }

                if (refreshController.isRefresh) {
                  refreshController.refreshCompleted();
                }
              } else if (state is UserPostNotLoaded) {
                pagingController.error = state.failure.toString();
                if (refreshController.isRefresh) {
                  refreshController.refreshCompleted();
                }
              } else if (state is UserPostUpdated) {
                pagingController.refresh();
                await Future.delayed(3.seconds);
              } else if (state is UserPostRefreshed) {
                userDetailBloc.add(
                  UserDetailEvent.loadProfile(
                    username: widget.username,
                  ),
                );
                pagingController.refresh();
                await refreshController.requestRefresh();
              }
            },
            child: Container(),
          ),
          BlocListener<UserDetailBloc, UserDetailState>(
            bloc: userDetailBloc,
            listener: (context, state) async {},
          ),
        ],
        child: NestedScrollView(
          controller: mainScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(),
            SliverToBoxAdapter(
              child: BlocBuilder<UserDetailBloc, UserDetailState>(
                bloc: userDetailBloc,
                builder: (context, state) => switch (state) {
                  UserDetailLoaded(user: final profile) => FSProfileHeader(
                      name: profile.name,
                      username: profile.username,
                      photo: profile.photo,
                      postCount: profile.postCount,
                      followerCount: profile.followersCount,
                      followingCount: profile.followingCount,
                      showAction: true,
                      isFollowing: widget.isFollowing,
                      onAction: () {
                        log(getIt<FSRouter>().currentHierarchy().toString());
                        if (widget.isFollowing) {
                          getIt<FSRouter>().pop(UserAction.unfollow);
                        } else {
                          getIt<FSRouter>().pop(UserAction.follow);
                        }
                      },
                    ),
                  UserDetailLoading() => const FSProfileHeader(
                      name: 'This is placeholder name',
                      username: '@username_',
                      showAction: true,
                    ).skeletonize(),
                  _ => const SizedBox.shrink()
                },
              ),
            ),
          ],
          body: FSInfiniteScroll(
            noItemTitle: 'Empty Here',
            noItemDescription: 'This user not create any posts yet!',
            onRefresh: () async => userPostBloc.add(
              const UserPostEvent.refresh(),
            ),
            firstProgressIndicatorBuilder: (context) => ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => FSPostCard(
                usingBaseUrl: false,
                description: 'This is a placeholder data for skeleton',
                userProfilePic:
                    'https://i0.wp.com/fisip.umrah.ac.id/wp-content/uploads/2022/12/placeholder-2.png',
                username: 'username_ling',
                imageUrl:
                    'https://i0.wp.com/fisip.umrah.ac.id/wp-content/uploads/2022/12/placeholder-2.png',
                createdAt: DateTime.now(),
              ).skeletonize(),
              separatorBuilder: (context, index) => const Divider(),
            ),
            pagingController: pagingController,
            refreshController: refreshController,
            scrollController: scrollController,
            showDivider: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, item, index) {
              final post = item as Post?;

              return FSPostCard(
                description: post?.description ?? '',
                userProfilePic: post?.user.photo ?? '',
                username: post?.user.username ?? '',
                imageUrl: post?.image ?? '',
                createdAt: post?.createdAt ?? DateTime.now(),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
