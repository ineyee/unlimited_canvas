import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';
import 'package:unlimited_canvas_plan2/model/base_element_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/model/graphics_element_model.dart';
import 'package:unlimited_canvas_plan2/algorithm/algorithm_util.dart';

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

  /// 选中的元素
  BaseElementModel? selectedElementModel;

  /// 是否正在拖动画布
  ///
  /// 进入translatingCanvas模式之后，手指down下去才算在拖动，手指抬起来就不在拖动，模拟项目里的小手
  bool isTranslatingCanvas = false;

  /// 画布当前的偏移量
  Offset curCanvasOffset = Offset.zero;

  /// 画布正在平移过程中时的偏移量
  Offset translatingCanvasOffset = Offset.zero;

  /// 画布当前的缩放比例
  double curCanvasScale = 1.0;

  /// 画布上一次的缩放比例
  double preCanvasScale = 1.0;

  /// 画布正在缩放过程中时的缩放比例
  double scalingCanvasScale = 1.0;

  final double minCanvasScale = 0.1;
  final double maxCanvasScale = 4.0;
  final double stepScale = 0.1;

  /// 上一次缩放数据（GestureDetector专用的）
  ///
  /// 用来计算双指缩放是缩小还是放大
  ScaleUpdateDetails? _lastScaleUpdateDetails;

// @override
// void onInit() {
//   super.onInit();
//
//   for (int i = 0; i < 100; i++) {
//    for (int j = 0; j < 100; j++) {
//      GraphicsElementModel graphicsElementModel = GraphicsElementModel();
//      graphicsElementModel.p1 = Offset(i * 20, j * 20);
//      graphicsElementModel.p2 = Offset(i * 20 + 100, j * 20 + 100);
//      graphicsElementModelList.add(graphicsElementModel);
//    }
//   }
// }
}

/// 正在对画布进行什么操作
enum OperationType {
  /// 绘制笔迹
  drawPencil,

  /// 绘制图形
  drawGraphics,

  /// 平移画布
  translateCanvas,

  /// 缩放画布
  scaleCanvas,

  /// 平移且缩放画布
  translateAndScaleCanvas,

  /// 选中元素
  selectedElement,
}

/// GestureDetectorLogic
extension GestureDetectorLogic on WhiteBoardViewModel {
  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount >= 2) {
      operationType = OperationType.translateAndScaleCanvas;
      _lastScaleUpdateDetails = null;
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount >= 2) {
      _executeTranslating(details);
      _executeScaling(details);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (details.pointerCount >= 2) {
      _lastScaleUpdateDetails = null;
    }
  }

  /// 执行缩放
  void _executeScaling(ScaleUpdateDetails details) {
    if (_lastScaleUpdateDetails == null) {
      _lastScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - _lastScaleUpdateDetails!.scale;
    if (scaleIncrement < 0) {
      // 缩小
      centerZoomCanvas(
        type: CenterZoomCanvasType.zoomOut,
        center: details.localFocalPoint,
        stepScale: -scaleIncrement,
      );
    }
    if (scaleIncrement > 0) {
      // 放大
      centerZoomCanvas(
        type: CenterZoomCanvasType.zoomIn,
        center: details.localFocalPoint,
        stepScale: scaleIncrement,
      );
    }

    // 缩放过程中实时更新上一次缩放的数据
    _lastScaleUpdateDetails = details;
  }

  /// 执行平移
  void _executeTranslating(ScaleUpdateDetails details) {
    curCanvasOffset += details.focalPointDelta;
    translatingCanvasOffset += details.focalPointDelta;
  }
}

/// ListenerLogic
extension ListenerLogic on WhiteBoardViewModel {
  void onPointerDown(PointerDownEvent event) {
    for (GraphicsElementModel graphicsElementModel
        in graphicsElementModelList) {
      Rect visibleRect = AlgorithmUtil.visibleRectOfElement(
        baseElementModel: graphicsElementModel,
        curCanvasOffset: curCanvasOffset,
        curCanvasScale: curCanvasScale,
      );
      bool isSelectedElement = AlgorithmUtil.pointInRect(
        screenPoint: event.localPosition,
        rect: visibleRect,
      );
      if (isSelectedElement) {
        operationType = OperationType.selectedElement;
        selectedElementModel = graphicsElementModel;
        updateGraphicsLayerWidget();
        return;
      }
    }

    Offset point = AlgorithmUtil.transformScreenPointToCanvasPoint(
      screenPoint: event.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );
    switch (operationType) {
      case OperationType.drawPencil:
        PencilElementModel pencilElementModel = PencilElementModel();
        pencilElementModel.points.add(point);
        drawingElementModelList.add(pencilElementModel);
        updatePencilLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel = GraphicsElementModel(
          p1: point,
          p2: point,
        );
        drawingElementModelList.add(graphicsElementModel);
        updateGraphicsLayerWidget();
        break;
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (operationType == OperationType.selectedElement) {
      selectedElementModel!.p1 += event.localDelta / curCanvasScale;
      selectedElementModel!.p2 += event.localDelta / curCanvasScale;
      updateGraphicsLayerWidget();
    }

    Offset point = AlgorithmUtil.transformScreenPointToCanvasPoint(
      screenPoint: event.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );

    switch (operationType) {
      case OperationType.drawPencil:
        PencilElementModel pencilElementModel =
            drawingElementModelList.last as PencilElementModel;
        pencilElementModel.points.add(point);
        updatePencilLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel =
            drawingElementModelList.last as GraphicsElementModel;
        graphicsElementModel.p2 = point;
        updateGraphicsLayerWidget();
        break;
      case OperationType.translateCanvas:
        isTranslatingCanvas = true;
        curCanvasOffset += event.localDelta;
        translatingCanvasOffset += event.localDelta;
        updateAllLayerWidget();
        break;
    }
  }

  void onPointerUp(PointerUpEvent event) {
    if (operationType == OperationType.selectedElement) {
      selectedElementModel!.p1 += event.localDelta;
      selectedElementModel!.p2 += event.localDelta;

      operationType = OperationType.drawPencil;
      return;
    }

    Offset point = AlgorithmUtil.transformScreenPointToCanvasPoint(
      screenPoint: event.localPosition,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
    );

    switch (operationType) {
      case OperationType.drawPencil:
        PencilElementModel pencilElementModel =
            drawingElementModelList.last as PencilElementModel;
        pencilElementModel.points.add(point);
        pencilElementModel.setP1P2();
        drawingElementModelList.removeLast();
        pencilElementModelList.add(pencilElementModel);
        updatePencilLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel =
            drawingElementModelList.last as GraphicsElementModel;
        graphicsElementModel.p2 = point;
        drawingElementModelList.removeLast();
        graphicsElementModelList.add(graphicsElementModel);
        updateGraphicsLayerWidget();
        break;
      case OperationType.translateCanvas:
        isTranslatingCanvas = false;
        translatingCanvasOffset = Offset.zero;
        updateAllLayerWidget();
        break;
    }
  }

  void onPointerSignal(PointerSignalEvent event) {
    // if (event is PointerScrollEvent) {
    //   // 鼠标滚轮事件
    //   if (event.scrollDelta.dy < 0) {
    //     // 缩小
    //     operationType = OperationType.scaleCanvas;
    //     centerZoomCanvas(
    //       type: CenterZoomCanvasType.zoomOut,
    //       center: event.position,
    //       stepScale: 0.02,
    //     );
    //     return;
    //   }
    //
    //   if (event.scrollDelta.dy > 0) {
    //     // 放大
    //     operationType = OperationType.scaleCanvas;
    //     centerZoomCanvas(
    //       type: CenterZoomCanvasType.zoomIn,
    //       center: event.position,
    //       stepScale: 0.02,
    //     );
    //     return;
    //   }
    //
    //   if (event.scrollDelta.dy == 0) {
    //     // 缩放结束
    //     operationType = OperationType.scaleCanvas;
    //   }
    // }
  }
}

/// 中心缩放画布的类型enum
enum CenterZoomCanvasType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

/// 中心缩放画布的逻辑
extension CenterZoomCanvasLogic on WhiteBoardViewModel {
  /// 以屏幕中心为缩放中心，通过动画的方式把画布缩放到[targetScale]
  ///
  /// 手动点击放大缩小按钮
  /// 100%
  /// fit
  /// ...
  void scaleTo({
    required targetScale,
    required AnimationController animationController,
    required Tween<double> scaleTween,
  }) {
    scaleTween.begin = curCanvasScale;
    scaleTween.end = targetScale;
    animationController.reset();
    animationController.forward();
  }

  void updateScale({
    required BuildContext context,
    required double scale,
  }) {
    preCanvasScale = curCanvasScale;
    curCanvasScale = scale;
    scalingCanvasScale = scale;
    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    updateAllLayerWidget();
  }

  /// 以任意点为中心缩放画布
  ///
  /// 多指缩放
  /// 鼠标滚轮缩放
  /// ...
  void centerZoomCanvas({
    required CenterZoomCanvasType type,
    required Offset center,
    double stepScale = 0.1,
  }) {
    if (type == CenterZoomCanvasType.zoomOut) {
      // 中心缩小画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) <= minCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = minCanvasScale;
        scalingCanvasScale = minCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale -= stepScale;
        scalingCanvasScale -= stepScale;
      }
    } else if (type == CenterZoomCanvasType.zoomIn) {
      // 中心放大画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) >= maxCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = maxCanvasScale;
        scalingCanvasScale = maxCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale += stepScale;
        scalingCanvasScale += stepScale;
      }
    }

    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: center,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    updateAllLayerWidget();
  }
}

/// 刷新layer
extension UpdateLayer on WhiteBoardViewModel {
  void updateGraphicsLayerWidget() {
    update([
      ConstString.drawingLayerPainterId,
      ConstString.graphicsLayerPainterId,
    ]);
  }

  void updatePencilLayerWidget() {
    update([
      ConstString.drawingLayerPainterId,
      ConstString.pencilLayerPainterId,
    ]);
  }

  void updateToolBarWidgetId() {
    update([
      ConstString.toolBarWidgetId,
    ]);
  }

  void updateAllLayerWidget() {
    update([
      ConstString.drawingLayerPainterId,
      ConstString.graphicsLayerPainterId,
      ConstString.pencilLayerPainterId,
      ConstString.toolBarWidgetId,
    ]);
  }
}
