import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social/core/assets/assets.gen.dart';
import 'package:flutter_social/core/extension/num_x.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FSInfiniteScroll extends StatelessWidget {
  const FSInfiniteScroll({
    required this.showDivider,
    required this.noItemTitle,
    required this.itemBuilder,
    required this.scrollController,
    required this.pagingController,
    required this.refreshController,
    required this.noItemDescription,
    required this.onRefresh,
    super.key,
    this.padding,
    this.emptyBuilder,
    this.separatorBuilder,
    this.progressIndicatorBuilder,
    this.firstProgressIndicatorBuilder,
  });

  final bool showDivider;
  final String noItemTitle;
  final EdgeInsets? padding;
  final String noItemDescription;
  final PagingController<dynamic, dynamic> pagingController;
  final ScrollController scrollController;
  final RefreshController refreshController;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context, Object? item, int index)
      itemBuilder;
  final Widget Function(BuildContext context)? progressIndicatorBuilder;
  final Widget Function(BuildContext context)? firstProgressIndicatorBuilder;
  final Future<dynamic> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scrollbar(
      trackVisibility: true,
      radius: const Radius.circular(4),
      thickness: 2,
      controller: scrollController,
      child: SmartRefresher(
        controller: refreshController,
        scrollController: scrollController,
        onRefresh: onRefresh,
        header: ClassicHeader(
          idleText: 'Keep Pulling',
          refreshingText: 'Processing',
          failedText: 'Failed',
          completeText: 'Success',
          releaseText: 'Release',
          completeIcon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          refreshingIcon: SpinKitDoubleBounce(
            size: 14.sp,
            color: Colors.blueAccent,
          ),
        ),
        child: PagedListView.separated(
          pagingController: pagingController,
          scrollController: scrollController,
          padding: padding ?? EdgeInsets.all(16.r),
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: itemBuilder,
            animateTransitions: true,
            transitionDuration: 700.milliseconds,
            noItemsFoundIndicatorBuilder: emptyBuilder ??
                (context) {
                  return SizedBox(
                    height: 0.8.sh,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.illustration.emptyPost.svg(
                            width: 0.4.sw,
                            height: 0.2.sh,
                          ),
                          16.verticalSpace,
                          Text(
                            noItemTitle,
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          8.verticalSpace,
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                            ),
                            child: Text(
                              noItemDescription,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
            firstPageErrorIndicatorBuilder: (_) {
              return Container(
                padding: EdgeInsets.all(16.r),
                height: 0.84.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.illustration.emptyPost.svg(
                          width: 0.4.sw,
                          height: 0.2.sh,
                        ),
                        16.verticalSpace,
                        Text(
                          'Failed',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        8.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                          ),
                          child: Text(
                            pagingController.error.toString(),
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    SizedBox(
                      width: 0.5.sw,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: pagingController.refresh,
                        child: const Text('Try Again'),
                      ),
                    ),
                  ],
                ),
              );
            },
            firstPageProgressIndicatorBuilder: firstProgressIndicatorBuilder ??
                (_) {
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    height: 0.84.sh,
                    child: SpinKitFadingCircle(
                      color: Colors.blueAccent,
                      size: 30.r,
                    ),
                  );
                },
            newPageProgressIndicatorBuilder: progressIndicatorBuilder ??
                (_) {
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    child: Center(
                      child: Column(
                        children: [
                          SpinKitFadingCircle(
                            color: Colors.blueAccent,
                            size: 30.r,
                          ),
                          8.verticalSpace,
                          Text(
                            'Load more...',
                            style: textTheme.bodySmall,
                          ),
                          8.verticalSpace,
                        ],
                      ),
                    ),
                  );
                },
            newPageErrorIndicatorBuilder: (_) {
              return Container(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.illustration.emptyPost.svg(
                          width: 0.4.sw,
                          height: 0.2.sh,
                        ),
                        16.verticalSpace,
                        Text(
                          'Failed',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        8.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                          ),
                          child: Text(
                            pagingController.error.toString(),
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    SizedBox(
                      width: 0.5.sw,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: pagingController.retryLastFailedRequest,
                        child: const Text('Try Again'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          shrinkWrap: true,
          separatorBuilder: showDivider
              ? separatorBuilder ??
                  (_, __) => const Divider(
                        height: 16,
                        thickness: 2,
                        color: Colors.white,
                      )
              : (_, __) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
