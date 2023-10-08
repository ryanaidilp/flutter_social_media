import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

extension WidgetX on Widget {
  Skeletonizer skeletonize() => Skeletonizer(
        child: this,
      );
}
