import 'dart:ui';

/// 基类元素模型
abstract class BaseElementModel {
  /// 该元素所在矩形框的左上角点坐标
  Offset p1 = Offset.zero;

  /// 该元素所在矩形框的右下角点坐标
  Offset p2 = Offset.zero;
}
