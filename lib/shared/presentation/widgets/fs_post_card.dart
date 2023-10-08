import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/config/env.dart';
import 'package:flutter_social/shared/presentation/widgets/fs_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class FSPostCard extends StatelessWidget {
  const FSPostCard({
    required this.description,
    required this.userProfilePic,
    required this.username,
    required this.imageUrl,
    required this.createdAt,
    this.usingBaseUrl = true,
    super.key,
  });

  final String description;
  final String userProfilePic;
  final String username;
  final String imageUrl;
  final DateTime createdAt;
  final bool usingBaseUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            children: [
              FSNetworkImage(
                url: usingBaseUrl
                    ? '${Env.apiBaseUrl}/$userProfilePic'
                    : userProfilePic,
                width: 32,
                height: 32,
                shape: BoxShape.circle,
              ),
              8.horizontalSpace,
              Text(
                username,
                style: textTheme.labelLarge,
              ),
            ],
          ),
        ),
        8.verticalSpace,
        FSNetworkImage(
          url: usingBaseUrl ? '${Env.apiBaseUrl}/$imageUrl' : imageUrl,
          width: 1.sw,
          height: 0.4.sh,
          fit: BoxFit.cover,
        ),
        Markdown(
          padding: EdgeInsets.all(8.r),
          data: description,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            timeago.format(createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}
