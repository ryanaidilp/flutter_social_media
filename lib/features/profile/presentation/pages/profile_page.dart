import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/shared/presentation/bloc/app_data_bloc.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_network_image.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout_rounded,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<AppDataBloc, AppDataState>(
              builder: (context, state) => switch (state) {
                AppDataProfileLoaded(profile: final profile) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FSNetworkImage(
                        url: profile.photo ?? '',
                        width: 50.w,
                        height: 50.h,
                        shape: BoxShape.circle,
                      ),
                      4.verticalSpace,
                      Text(
                        profile.name,
                        textAlign: TextAlign.center,
                        style: textTheme.labelLarge,
                      ),
                      4.verticalSpace,
                      Text(
                        '@${profile.username}',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall,
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.postCount.toString(),
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                const Text('Posts'),
                              ],
                            ),
                          ),
                          4.horizontalSpace,
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.followersCount.toString(),
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                const Text('Followers'),
                              ],
                            ),
                          ),
                          4.horizontalSpace,
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.followingCount.toString(),
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                const Text('Followings'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      const Divider(),
                    ],
                  ),
                _ => const SizedBox.shrink()
              },
            ),
          ),
        ],
      ),
    );
  }
}
