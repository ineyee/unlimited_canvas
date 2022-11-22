import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 笔迹层Widget
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
    debugPrint("PencilLayerWidget===repaint");

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
          ..color = Colors.purple
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PencilLayerPainter oldDelegate) {
    // 新增笔迹再重绘，其它情况下都不需要重绘
    if (_whiteBoardViewModel.operationType == OperationType.drawPencil) {
      return true;
    }

    return false;
  }
}
