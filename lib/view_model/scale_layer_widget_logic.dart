import 'package:flutter/material.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/algorithm/algorithm_util.dart';

enum ScaleLayerWidgetType {
  /// 中心缩小画布
  zoomOut,

  /// 中心放大画布
  zoomIn,
}

extension ScaleLayerWidgetLogic on WhiteBoardViewModel {
  /// 以屏幕中心为缩放中心，通过动画的方式把画布缩放到[targetScale]
  ///
  /// 手动点击放大、缩小按钮
  /// 100%
  void aroundScreenScaleTo({
    required targetScale,
    required AnimationController animationController,
    required Tween<double> scaleTween,
  }) {
    scaleTween.begin = curCanvasScale;
    scaleTween.end = targetScale;
    animationController.reset();
    animationController.forward();
  }

  void updateLayerWidgetScale({
    required BuildContext context,
    required double scale,
  }) {
    preCanvasScale = curCanvasScale;
    curCanvasScale = scale;
    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    updateToolBarWidget();
    updatePresentationLayerWidget();
  }

  /// 以任意点为中心缩放画布
  ///
  /// 多指缩放
  /// 鼠标滚轮缩放
  void aroundCenterScale({
    required Offset center,
    required ScaleLayerWidgetType type,
    double stepScale = 0.1,
  }) {
    if (type == ScaleLayerWidgetType.zoomOut) {
      // 中心缩小画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) <= minCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = minCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale -= stepScale;
      }
    } else if (type == ScaleLayerWidgetType.zoomIn) {
      // 中心放大画布
      if (double.parse(curCanvasScale.toStringAsFixed(1)) >= maxCanvasScale) {
        preCanvasScale = curCanvasScale;
        curCanvasScale = maxCanvasScale;
      } else {
        preCanvasScale = curCanvasScale;
        curCanvasScale += stepScale;
      }
    }

    curCanvasOffset += AlgorithmUtil.centerZoomAlgorithm(
      center: center,
      curCanvasOffset: curCanvasOffset,
      curCanvasScale: curCanvasScale,
      preCanvasScale: preCanvasScale,
    );

    updateToolBarWidget();
    updatePresentationLayerWidget();
  }
}
