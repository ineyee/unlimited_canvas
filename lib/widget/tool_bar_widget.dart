import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 工具条Widget
class ToolBarWidget extends StatefulWidget {
  const ToolBarWidget({Key? key}) : super(key: key);

  @override
  State<ToolBarWidget> createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBarWidget>
    with SingleTickerProviderStateMixin {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;
  late Tween<double> _scaleTween;
  late Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _scaleTween = Tween<double>();
    _scaleAnimation = _scaleTween.animate(_curvedAnimation);
    _scaleAnimation.addListener(() {
      _whiteBoardViewModel.updateLayerWidgetScale(
        context: context,
        scale: _scaleAnimation.value,
      );
    });
    _scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _whiteBoardViewModel.updateToolBarWidget();
        _whiteBoardViewModel.updatePresentationLayerWidget();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.toolBarWidgetId,
      builder: (_) {
        return Row(
          children: [
            _drawPencilWidget(),
            _drawGraphicsWidget(),
            _translateCanvasWidget(),
            _zoomOutWidget(context),
            _canvasScaleWidget(),
            _zoomInWidget(context),
          ],
        );
      },
    );
  }

  Widget _drawPencilWidget() {
    return IconButton(
      icon: const Icon(Icons.brush),
      onPressed: () {
        _whiteBoardViewModel.operationType = OperationType.drawPencil;
      },
    );
  }

  Widget _drawGraphicsWidget() {
    return IconButton(
      icon: const Icon(Icons.rectangle),
      onPressed: () {
        _whiteBoardViewModel.operationType = OperationType.drawGraphics;
      },
    );
  }

  Widget _translateCanvasWidget() {
    return IconButton(
      icon: const Icon(Icons.pan_tool),
      onPressed: () {
        _whiteBoardViewModel.operationType = OperationType.translateCanvas;
      },
    );
  }

  Widget _zoomOutWidget(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.zoom_out),
      onPressed: () {
        _whiteBoardViewModel.operationType = OperationType.scaleCanvas;
        _whiteBoardViewModel.aroundScreenScaleTo(
          targetScale: double.parse((_whiteBoardViewModel.curCanvasScale -
                          _whiteBoardViewModel.stepScale)
                      .toStringAsFixed(1)) <=
                  _whiteBoardViewModel.minCanvasScale
              ? _whiteBoardViewModel.minCanvasScale
              : _whiteBoardViewModel.curCanvasScale -
                  _whiteBoardViewModel.stepScale,
          animationController: _animationController,
          scaleTween: _scaleTween,
        );
      },
    );
  }

  Widget _canvasScaleWidget() {
    return GestureDetector(
      child: Text("${(_whiteBoardViewModel.curCanvasScale * 100).toInt()}%"),
      onTap: () {
        _whiteBoardViewModel.aroundScreenScaleTo(
          targetScale: 1.0,
          animationController: _animationController,
          scaleTween: _scaleTween,
        );
      },
    );
  }

  Widget _zoomInWidget(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.zoom_in),
      onPressed: () {
        _whiteBoardViewModel.operationType = OperationType.scaleCanvas;
        _whiteBoardViewModel.aroundScreenScaleTo(
          targetScale: double.parse((_whiteBoardViewModel.curCanvasScale +
                          _whiteBoardViewModel.stepScale)
                      .toStringAsFixed(1)) >=
                  _whiteBoardViewModel.maxCanvasScale
              ? _whiteBoardViewModel.maxCanvasScale
              : _whiteBoardViewModel.curCanvasScale +
                  _whiteBoardViewModel.stepScale,
          animationController: _animationController,
          scaleTween: _scaleTween,
        );
      },
    );
  }
}
