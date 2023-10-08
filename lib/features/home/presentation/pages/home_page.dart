import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/core/assets/assets.gen.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_social/core/extension/widget_x.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_infinite_scroll.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_post_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController scrollController;
  late final PagingController<int, Post> pagingController;
  late final RefreshController refreshController;

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

  void _pageRequestListener(int pageKey) => context.read<HomeBloc>()
    ..add(
      HomeEvent.loadMorePosts(
        page: pageKey,
        perPage: 10,
      ),
    );

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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 10,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Assets.logo.flutterSocialIcons.image(
              width: 32.w,
              height: 32.h,
              fit: BoxFit.fill,
            ),
            4.horizontalSpace,
            Text(
              'Flutter Social Demo',
              style: textTheme.labelLarge,
            ),
          ],
        ),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is LoadingPostsSuccess) {
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
          } else if (state is LoadingPostFailed) {
            pagingController.error = state.failure.toString();
            if (refreshController.isRefresh) {
              refreshController.refreshCompleted();
            }
          } else if (state is PostUpdated) {
            pagingController.refresh();
            await Future.delayed(3.seconds);
          } else if (state is PostRefreshed) {
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
            itemCount: 5,
            shrinkWrap: true,
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
          scrollController: scrollController,
          pagingController: pagingController,
          refreshController: refreshController,
          noItemDescription: 'There are no posts yet',
          onRefresh: () async =>
              context.read<HomeBloc>()..add(const HomeEvent.refresh()),
        ),
      ),
    );
  }
}
