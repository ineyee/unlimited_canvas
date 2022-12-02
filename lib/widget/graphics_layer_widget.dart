import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/model/graphics_element_model.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 图形层Widget
///
/// 重绘时机：
/// 1、新绘制一个图形结束了
/// 2、开始拖动一个图形（需要把这个图形从图形层移除，提到实时绘制层）
/// 3、结束拖动一个图形（需要把这个图形从实时绘制层移除，下放到图形层）
class GraphicsLayerWidget extends StatelessWidget {
  const GraphicsLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.graphicsLayerWidgetId,
      builder: (WhiteBoardViewModel whiteBoardViewModel) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              whiteBoardViewModel.curCanvasOffset.dx,
              whiteBoardViewModel.curCanvasOffset.dy,
            )
            ..scale(whiteBoardViewModel.curCanvasScale),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: _GraphicsLayerPainter(),
            ),
          ),
        );
      },
    );
  }
}

class _GraphicsLayerPainter extends CustomPainter {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("GraphicsLayerWidget===repaint");

    for (GraphicsElementModel graphicsElementModel
        in _whiteBoardViewModel.graphicsElementModelList) {
      canvas.drawRect(
        Rect.fromPoints(
          graphicsElementModel.p1,
          graphicsElementModel.p2,
        ),
        Paint()..color = Colors.yellow,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphicsLayerPainter oldDelegate) {
    if (_whiteBoardViewModel.operationType == OperationType.drawGraphics ||
        _whiteBoardViewModel.operationType == OperationType.dragElement) {
      return true;
    }

    return false;
  }
}
