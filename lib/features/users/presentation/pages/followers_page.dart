import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/di/service_locator.dart';
import 'package:flutter_social/core/extension/widget_x.dart';
import 'package:flutter_social/features/users/domain/entities/follow_argument.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/domain/enums/user_action.dart';
import 'package:flutter_social/features/users/presentation/bloc/followers_bloc.dart';
import 'package:flutter_social/router/fs_router.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_infinite_scroll.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_user_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage<FollowArgument?>()
class FollowersPage extends StatefulWidget {
  const FollowersPage({
    required this.username,
    super.key,
  });

  final String username;

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late final ScrollController scrollController;
  late final PagingController<int, User> pagingController;
  late final RefreshController refreshController;
  late final FollowersBloc bloc;

  void _pageRequestListener(int pageKey) => bloc.add(
        FollowersEvent.loadMoreFollowers(
          username: widget.username,
          page: pageKey,
        ),
      );

  @override
  void initState() {
    super.initState();
    bloc = FollowersBloc();
    scrollController = ScrollController();
    refreshController = RefreshController();
    pagingController = PagingController(
      firstPageKey: 1,
    )..addPageRequestListener(
        _pageRequestListener,
      );
  }

  @override
  void dispose() {
    bloc.close();
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
      appBar: AppBar(
        title: const Text('Followers'),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 10,
      ),
      body: BlocListener<FollowersBloc, FollowersState>(
        bloc: bloc,
        listener: (context, state) async {
          if (state is FollowersLoaded) {
            final data = state.data;

            final isLastPage = !(data.pagination?.hasMorePages ?? false);

            if (isLastPage) {
              pagingController.appendLastPage(data.data ?? []);
            } else {
              pagingController.appendPage(data.data ?? [], state.page + 1);
            }

            if (refreshController.isRefresh) {
              refreshController.refreshCompleted();
            }
          } else if (state is FollowersError) {
            pagingController.error = state.failure.toString();
            if (refreshController.isRefresh) {
              refreshController.refreshCompleted();
            }
          } else if (state is FollowersRefreshed) {
            pagingController.refresh();
            await refreshController.requestRefresh();
          }
        },
        child: FSInfiniteScroll(
          showDivider: true,
          padding: EdgeInsets.zero,
          noItemTitle: 'No Followers',
          separatorBuilder: (context, index) => const Divider(),
          firstProgressIndicatorBuilder: (context) => ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const FsUserCard(
              name: 'This is just placeholder',
              username: 'username',
            ).skeletonize(),
            separatorBuilder: (context, index) => const Divider(),
          ),
          itemBuilder: (context, item, index) {
            final user = item as User?;
            return FsUserCard(
              onToggleFollow: () {
                if (user?.followedAt != null) {
                  getIt<FSRouter>().pop(
                    FollowArgument(
                      action: UserAction.unfollow,
                      username: user?.username ?? '',
                    ),
                  );
                } else {
                  getIt<FSRouter>().pop(
                    FollowArgument(
                      action: UserAction.follow,
                      username: user?.username ?? '',
                    ),
                  );
                }
              },
              name: user?.name,
              photo: user?.photo,
              username: user?.username,
              isFollowed: user?.followedAt != null,
            );
          },
          progressIndicatorBuilder: (context) => const FsUserCard(
            name: 'This is just placeholder',
            username: 'username',
          ).skeletonize(),
          scrollController: scrollController,
          pagingController: pagingController,
          refreshController: refreshController,
          noItemDescription:
              'You dont have any followers yet. Make sure to create something to interest people to follow you!',
          onRefresh: () async => bloc.add(const FollowersEvent.refresh()),
        ),
      ),
    );
  }
}
