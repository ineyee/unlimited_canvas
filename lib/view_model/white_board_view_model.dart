import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/model/base_element_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/model/graphics_element_model.dart';
export 'package:unlimited_canvas_plan2/view_model/gesture_logic.dart';
export 'package:unlimited_canvas_plan2/view_model/scale_layer_widget_logic.dart';
export 'package:unlimited_canvas_plan2/view_model/update_layer_widget_logic.dart';

/// 正在对白板进行什么操作
enum OperationType {
  /// 绘制笔迹
  drawPencil,

  /// 绘制橡皮擦
  drawEraser,

  /// 绘制图形
  drawGraphics,

  /// 平移画布
  translateCanvas,

  /// 缩放画布
  scaleCanvas,

  /// 平移且缩放画布
  translateAndScaleCanvas,

  /// 拖动元素
  dragElement,
}

/// 背景类型
enum BackgroundType {
  none,
  dot,
  grid,
}

/// 白板VM层
class WhiteBoardViewModel extends GetxController {
  /// 正在对画布进行什么操作
  ///
  /// 默认绘制笔迹
  OperationType operationType = OperationType.drawPencil;

  /// 正在绘制的元素
  List<BaseElementModel> drawingElementModelList = [];

  /// 所有的笔迹元素
  List<PencilElementModel> pencilElementModelList = [];

  /// 所有的图形元素
  List<GraphicsElementModel> graphicsElementModelList = [];

  /// 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  /// 画布当前的缩放比例
  double curCanvasScale = 1.0;

  /// 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  final double minCanvasScale = 0.1;
  final double maxCanvasScale = 3.0;
  final double stepScale = 0.1;

  /// 上一次缩放数据（GestureDetector专用的）
  ///
  /// 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? lastScaleUpdateDetails;

  /// 可视区域的大小
  Size visibleAreaSize = Size.zero;

  /// 可视区域的中心
  Offset visibleAreaCenter = Offset.zero;

  /// 背景类型
  BackgroundType backgroundType = BackgroundType.none;
}
