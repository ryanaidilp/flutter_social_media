import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_social/core/extension/widget_x.dart';
import 'package:flutter_social/features/users/domain/entities/user.dart';
import 'package:flutter_social/features/users/presentation/bloc/user_bloc.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_infinite_scroll.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_user_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final ScrollController scrollController;
  late final PagingController<int, User> pagingController;
  late final RefreshController refreshController;

  void _pageRequestListener(int pageKey) => context.read<UserBloc>()
    ..add(
      UserEvent.loadMoreUsers(
        page: pageKey,
      ),
    );

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text('People'),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 10,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is UserLoaded) {
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
          } else if (state is UserError) {
            pagingController.error = state.failure.toString();
            if (refreshController.isRefresh) {
              refreshController.refreshCompleted();
            }
          } else if (state is UserListUpdated) {
            pagingController.refresh();
            await Future.delayed(3.seconds);
          } else if (state is UserListRefreshed) {
            pagingController.refresh();
            await refreshController.requestRefresh();
          }
        },
        child: FSInfiniteScroll(
          showDivider: true,
          padding: EdgeInsets.zero,
          noItemTitle: 'No Posts',
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
          noItemDescription: 'There are no users yet',
          onRefresh: () async =>
              context.read<UserBloc>()..add(const UserEvent.refresh()),
        ),
      ),
    );
  }
}
