import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FSEmptyWidget extends StatelessWidget {
  const FSEmptyWidget({
    required this.placeholder,
    required this.title,
    required this.caption,
    this.fit = BoxFit.contain,
    super.key,
  });

  final Widget placeholder;
  final BoxFit fit;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 0.5.sw,
                height: 0.25.sh,
                child: placeholder,
              ),
            ),
            8.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            4.verticalSpace,
            Text(
              caption,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
