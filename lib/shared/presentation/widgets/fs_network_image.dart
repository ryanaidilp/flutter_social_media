import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FSNetworkImage extends StatelessWidget {
  const FSNetworkImage({
    required this.url,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.contain,
    super.key,
  });
  final String url;
  final double? width;
  final double? height;
  final BoxShape shape;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ExtendedImage.network(
        url,
        width: width?.w,
        height: height?.h,
        fit: fit,
        shape: shape,
        loadStateChanged: (state) => switch (state.extendedImageLoadState) {
          LoadState.completed => state.completedWidget,
          LoadState.failed => Container(
              width: width?.w,
              height: height?.h,
              decoration: BoxDecoration(
                shape: shape,
                border: Border.all(color: Colors.grey),
              ),
              child: InkWell(
                onTap: state.reLoadImage,
                child: const Icon(Icons.refresh),
              ),
            ),
          LoadState.loading => Skeleton.shade(
              child: Container(
                width: width?.w,
                height: height?.h,
                decoration: BoxDecoration(
                  shape: shape,
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey),
                ),
                child: SpinKitFadingCircle(
                  color: Colors.blueAccent,
                  size: 24.sp,
                ),
              ),
            )
        },
      );
}
