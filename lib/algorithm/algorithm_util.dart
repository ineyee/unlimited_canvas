import 'dart:ui';

import 'package:unlimited_canvas_plan2/model/base_element_model.dart';

class AlgorithmUtil {
  AlgorithmUtil.internal();

  /// 以屏幕上任意一点为中心进行缩放、实时计算画布新增偏移量的算法
  ///
  /// [center]: 缩放中心
  /// [curCanvasOffset]: 画布当前的偏移量
  /// [curCanvasScale]: 画布当前的缩放比例
  /// [preCanvasScale]: 画布上一次的缩放比例
  ///
  /// return: 这一次缩放导致画布新增的偏移量
  static Offset centerZoomAlgorithm({
    required Offset center,
    required Offset curCanvasOffset,
    required double curCanvasScale,
    required double preCanvasScale,
  }) {
    double thisTimeCanvasOffsetX = -(center.dx - curCanvasOffset.dx) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    double thisTimeCanvasOffsetY = -(center.dy - curCanvasOffset.dy) *
        (curCanvasScale - preCanvasScale) /
        preCanvasScale;
    Offset thisTimeCanvasOffset =
        Offset(thisTimeCanvasOffsetX, thisTimeCanvasOffsetY);
    return thisTimeCanvasOffset;
  }

  /// 把屏幕上点的坐标转换成画布上点的坐标（坐标都是以画布一倍时为参照的，画布总是一倍）
  ///
  /// 一般就是创建元素时给元素赋值坐标的时候用
  static Offset transformScreenPointToCanvasPoint({
    required Offset screenPoint,
    required Offset curCanvasOffset,
    required double curCanvasScale,
  }) {
    Offset canvasPoint = (screenPoint - curCanvasOffset) / curCanvasScale;
    return canvasPoint;
  }

  /// 当前元素因为缩放、平移后真正显示在屏幕上的区域
  ///
  /// 用途：
  /// 1、判断触摸的点是否在这个元素内，以便选中元素
  /// 2、判断这个元素在不在屏幕可是范围内
  /// ...
  static Rect visibleRectOfElement({
    required BaseElementModel baseElementModel,
    required Offset curCanvasOffset,
    required double curCanvasScale,
  }) {
    Rect visibleRect = Rect.fromPoints(
      baseElementModel.p1 * curCanvasScale + curCanvasOffset,
      baseElementModel.p2 * curCanvasScale + curCanvasOffset,
    );
    return visibleRect;
  }

  /// 触摸的点是否在某个矩形中
  static bool pointInRect({
    required Offset screenPoint,
    required Rect rect,
  }) {
    return rect.contains(screenPoint);
  }
}
