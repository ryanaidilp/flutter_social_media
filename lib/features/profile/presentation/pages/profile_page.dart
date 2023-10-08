import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_social/core/extension/widget_x.dart';
import 'package:flutter_social/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_infinite_scroll.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_post_card.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_profile_header.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ScrollController scrollController;
  late final ScrollController mainScrollController;
  late final RefreshController refreshController;
  late final PagingController<int, Post> pagingController;

  void _pageRequestListener(int pageKey) => context.read<ProfileBloc>().add(
        ProfileEvent.loadMorePosts(page: pageKey),
      );

  @override
  void initState() {
    super.initState();
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
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfilePostSuccess) {
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
          } else if (state is ProfilePostFailed) {
            pagingController.error = state.failure.toString();
            if (refreshController.isRefresh) {
              refreshController.refreshCompleted();
            }
          } else if (state is ProfilePostUpdated) {
            pagingController.refresh();
            await Future.delayed(3.seconds);
          } else if (state is ProfilePostRefreshed) {
            context.read<AppDataBloc>().add(const AppDataEvent.loadProfile());
            pagingController.refresh();
            await refreshController.requestRefresh();
          }
        },
        child: NestedScrollView(
          controller: mainScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              actions: [
                BlocBuilder<AppDataBloc, AppDataState>(
                  builder: (context, state) => switch (state) {
                    AppDataProfileLoaded(profile: final profile) => IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthEvent.logout(profile.id),
                              );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                        ),
                      ),
                    _ => const SizedBox.shrink()
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<AppDataBloc, AppDataState>(
                builder: (context, state) => switch (state) {
                  AppDataProfileLoaded(profile: final profile) =>
                    FSProfileHeader(
                      name: profile.name,
                      username: profile.username,
                      photo: profile.photo,
                      postCount: profile.postCount,
                      followerCount: profile.followersCount,
                      followingCount: profile.followingCount,
                    ),
                  AppDataLoading() => const FSProfileHeader(
                      name: 'This is placeholder name',
                      username: '@username_',
                    ).skeletonize(),
                  _ => const SizedBox.shrink()
                },
              ),
            ),
          ],
          body: FSInfiniteScroll(
            noItemTitle: 'Empty Here',
            noItemDescription:
                'You are not posts anything yet. Create your first post and share it to the world!',
            onRefresh: () async => context.read<ProfileBloc>()
              ..add(
                const ProfileEvent.refresh(),
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
