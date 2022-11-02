import 'dart:ui';

/// 数值常量
class ConstNumber {
  ConstNumber._internal();

  /// 屏幕物理分辨率：宽度
  static final double _physicalWidth = window.physicalSize.width;

  /// 屏幕物理分辨率：高度
  static final double _physicalHeight = window.physicalSize.height;

  /// device pixel ratio：1x、2x、3x
  static final double _dpr = window.devicePixelRatio;

  /// 屏幕逻辑分辨率：宽度
  static final double screenWidth = _physicalWidth / _dpr;

  /// 屏幕逻辑分辨率：高度
  static final double screenHeight = _physicalHeight / _dpr;

  /// 顶部（SafeArea + 状态栏）的高度
  static final double topHeight = window.padding.top / _dpr;

  /// 导航栏的高度
  static const double navigationBarHeight = 44;

  /// AppBar的高度
  static final double appBarHeight = (topHeight + navigationBarHeight);

  /// 底部SafeArea的高度
  static final double bottomHeight = window.padding.bottom / _dpr;
}
