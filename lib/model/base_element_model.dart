import 'dart:ui';

/// 基类元素模型
class BaseElementModel {
  BaseElementModel({
    this.p1 = Offset.zero,
    this.p2 = Offset.zero,
  });

  /// 该元素所在矩形框的左上角点坐标（画布一倍时）
  Offset p1;

  /// 该元素所在矩形框的右下角点（画布一倍时）
  Offset p2;
}
