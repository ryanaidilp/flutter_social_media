import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/config/env.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FsUserCard extends StatelessWidget {
  const FsUserCard({
    this.isFollowed = false,
    super.key,
    this.username,
    this.name,
    String? photo,
    this.onTap,
    this.onToggleFollow,
  }) : photo = photo ?? 'public/uploads/pc_profile.jpg';

  final String? username;
  final String? name;
  final String photo;
  final bool isFollowed;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      leading: FSNetworkImage(
        url: '${Env.apiBaseUrl}/$photo',
        width: 32.w,
        height: 32.h,
        shape: BoxShape.circle,
      ),
      title: Text(
        '$name',
        style: textTheme.labelLarge,
      ),
      trailing: OutlinedButton(
        onPressed: onToggleFollow,
        child: Skeleton.keep(
          child: Text(isFollowed ? 'Unfollow' : 'Follow'),
        ),
      ),
      subtitle: Text('@$username'),
      dense: true,
    );
  }
}
