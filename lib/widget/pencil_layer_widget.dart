import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 笔迹层Widget
///
/// 重绘时机：
/// 1、新绘制一根笔迹结束了
/// 2、绘制橡皮擦
class PencilLayerWidget extends StatelessWidget {
  const PencilLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.pencilLayerWidgetId,
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
              painter: _PencilLayerPainter(),
            ),
          ),
        );
      },
    );
  }
}

class _PencilLayerPainter extends CustomPainter {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint("PencilLayerWidget===repaint");
    // 笔迹的可绘制区域
    Rect canvasRect = const Rect.fromLTWH(
      -100000000,
      -100000000,
      200000000,
      200000000,
    );
    canvas.saveLayer(
      Rect.fromLTWH(
        canvasRect.left,
        canvasRect.top,
        canvasRect.width,
        canvasRect.height,
      ),
      Paint(),
    );
    for (PencilElementModel pencilElementModel
        in _whiteBoardViewModel.pencilElementModelList) {
      Path path = Path();
      int i = 0;
      for (Offset item in pencilElementModel.points) {
        if (i == 0) {
          path.moveTo(item.dx, item.dy);
        } else {
          path.lineTo(item.dx, item.dy);
        }
        i++;
      }
      canvas.drawPath(
        path,
        Paint()
          ..color =
              pencilElementModel.isEraser ? Colors.transparent : Colors.purple
          ..strokeWidth = pencilElementModel.isEraser ? 20 : 5
          ..style = PaintingStyle.stroke
          ..blendMode =
              pencilElementModel.isEraser ? BlendMode.clear : BlendMode.srcOver,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PencilLayerPainter oldDelegate) {
    if (_whiteBoardViewModel.operationType == OperationType.drawPencil ||
        _whiteBoardViewModel.operationType == OperationType.drawEraser) {
      return true;
    }

    return false;
  }
}
