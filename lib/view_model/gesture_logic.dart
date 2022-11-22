import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:unlimited_canvas_plan2/model/graphics_element_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/algorithm/algorithm_util.dart';

extension GestureDetectorLogic on WhiteBoardViewModel {
  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount >= 2) {
      operationType = OperationType.translateAndScaleCanvas;
      lastScaleUpdateDetails = null;
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
      lastScaleUpdateDetails = null;
    }
  }

  // 执行缩放
  void _executeScaling(ScaleUpdateDetails details) {
    if (lastScaleUpdateDetails == null) {
      lastScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - lastScaleUpdateDetails!.scale;
    if (scaleIncrement < 0) {
      // 缩小
      aroundCenterScale(
        type: ScaleLayerWidgetType.zoomOut,
        center: details.localFocalPoint,
        stepScale: -scaleIncrement,
      );
    }
    if (scaleIncrement > 0) {
      // 放大
      aroundCenterScale(
        type: ScaleLayerWidgetType.zoomIn,
        center: details.localFocalPoint,
        stepScale: scaleIncrement,
      );
    }

    // 缩放过程中实时更新上一次缩放的数据
    lastScaleUpdateDetails = details;
  }

  // 执行平移
  void _executeTranslating(ScaleUpdateDetails details) {
    curCanvasOffset += details.focalPointDelta;
  }
}

extension ListenerLogic on WhiteBoardViewModel {
  void onPointerDown(PointerDownEvent event) {
    // 触摸的点如果在图形内，那就进入拖动元素模式
    for (GraphicsElementModel graphicsElementModel
        in graphicsElementModelList) {
      Rect visibleRect = AlgorithmUtil.visibleRectOfElement(
        baseElementModel: graphicsElementModel,
        curCanvasOffset: curCanvasOffset,
        curCanvasScale: curCanvasScale,
      );
      bool isDragElement = AlgorithmUtil.pointInRect(
        screenPoint: event.localPosition,
        rect: visibleRect,
      );
      if (isDragElement) {
        operationType = OperationType.dragElement;
        drawingElementModelList.add(graphicsElementModel);
        graphicsElementModelList.remove(graphicsElementModel);

        updateDrawingLayerWidget();
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

        updateDrawingLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel = GraphicsElementModel();
        graphicsElementModel.p1 = point;
        graphicsElementModel.p2 = point;
        drawingElementModelList.add(graphicsElementModel);

        updateDrawingLayerWidget();
        break;
    }
  }

  void onPointerMove(PointerMoveEvent event) {
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

        updateDrawingLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel =
            drawingElementModelList.last as GraphicsElementModel;
        graphicsElementModel.p2 = point;

        updateDrawingLayerWidget();
        break;
      case OperationType.translateCanvas:
        curCanvasOffset += event.localDelta;

        updatePresentationLayerWidget();
        break;
      case OperationType.dragElement:
        drawingElementModelList.last.p1 += event.localDelta / curCanvasScale;
        drawingElementModelList.last.p2 += event.localDelta / curCanvasScale;

        updateDrawingLayerWidget();
        break;
    }
  }

  void onPointerUp(PointerUpEvent event) {
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
        pencilElementModelList.add(pencilElementModel);
        drawingElementModelList.removeLast();

        updateDrawingLayerWidget();
        updatePencilLayerWidget();
        break;
      case OperationType.drawGraphics:
        GraphicsElementModel graphicsElementModel =
            drawingElementModelList.last as GraphicsElementModel;
        graphicsElementModel.p2 = point;
        graphicsElementModelList.add(graphicsElementModel);
        drawingElementModelList.removeLast();

        updateDrawingLayerWidget();
        updateGraphicsLayerWidget();
        break;
      case OperationType.translateCanvas:
        updatePresentationLayerWidget();
        break;
      case OperationType.dragElement:
        drawingElementModelList.last.p1 += event.localDelta / curCanvasScale;
        drawingElementModelList.last.p2 += event.localDelta / curCanvasScale;
        graphicsElementModelList
            .add(drawingElementModelList.last as GraphicsElementModel);
        drawingElementModelList.clear();

        updateDrawingLayerWidget();
        updateGraphicsLayerWidget();
        break;
    }
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // 鼠标滚轮事件
      if (event.scrollDelta.dy < 0) {
        // 缩小
        operationType = OperationType.scaleCanvas;
        aroundCenterScale(
          type: ScaleLayerWidgetType.zoomOut,
          center: event.position,
          stepScale: 0.02,
        );
        return;
      }

      if (event.scrollDelta.dy > 0) {
        // 放大
        operationType = OperationType.scaleCanvas;
        aroundCenterScale(
          type: ScaleLayerWidgetType.zoomIn,
          center: event.position,
          stepScale: 0.02,
        );
        return;
      }

      if (event.scrollDelta.dy == 0) {
        // 缩放结束
        operationType = OperationType.scaleCanvas;

        updateToolBarWidget();
        updatePresentationLayerWidget();
      }
    }
  }
}
