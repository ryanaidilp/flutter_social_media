import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_social/config/env.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FSProfileHeader extends StatelessWidget {
  const FSProfileHeader({
    String? photo,
    String? username,
    String? name,
    int? postCount,
    int? followerCount,
    int? followingCount,
    super.key,
  })  : name = name ?? '',
        username = username ?? '',
        photo = photo ?? 'public/uploads/pc_profile.jpg',
        postCount = postCount ?? 0,
        followerCount = followerCount ?? 0,
        followingCount = followingCount ?? 0;

  final String photo;
  final String username;
  final String name;
  final int postCount;
  final int followerCount;
  final int followingCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FSNetworkImage(
          url: '${Env.apiBaseUrl}/$photo',
          width: 50.w,
          height: 50.h,
          shape: BoxShape.circle,
        ),
        4.verticalSpace,
        Text(
          name,
          textAlign: TextAlign.center,
          style: textTheme.labelLarge,
        ),
        4.verticalSpace,
        SelectableText(
          '@$username',
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
                    postCount.toString(),
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  const Skeleton.keep(child: Text('Posts')),
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
                    followerCount.toString(),
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  const Skeleton.keep(child: Text('Followers')),
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
                    followingCount.toString(),
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  const Skeleton.keep(child: Text('Followings')),
                ],
              ),
            ),
          ],
        ),
        16.verticalSpace,
        const Divider(),
      ],
    );
  }
}
