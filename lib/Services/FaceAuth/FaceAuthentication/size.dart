

import 'package:flutter/cupertino.dart';

extension SizeExtension on num {
  double get sw => ScreenSizeUtil.screenWidth * this;

  double get sh => ScreenSizeUtil.screenHeight * this;
}
class ScreenSizeUtil {
  static late BuildContext context;

  static double get screenHeight => MediaQuery.of(context).size.height;
  static double get screenWidth => MediaQuery.of(context).size.width;
}