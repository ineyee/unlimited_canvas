import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/algorithm/algorithm_util.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';

/// 笔迹层Widget
class PencilLayerWidget extends StatelessWidget {
  PencilLayerWidget({Key? key}) : super(key: key);

  final WhiteBoardViewModel _whiteBoardViewModel =
  Get.find<WhiteBoardViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.pencilLayerPainterId,
      builder: (_) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              _whiteBoardViewModel.curCanvasOffset.dx,
              _whiteBoardViewModel.curCanvasOffset.dy,
            )
            ..scale(_whiteBoardViewModel.curCanvasScale),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: RepaintBoundary(
              child: CustomPaint(
                isComplex: true,
                painter: _PencilLayerPainter(),
              ),
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
          ..color = Colors.red
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PencilLayerPainter oldDelegate) {
    if (_whiteBoardViewModel.operationType == OperationType.translateCanvas &&
        _whiteBoardViewModel.isTranslatingCanvas) {
      return false;
    }

    if (_whiteBoardViewModel.operationType == OperationType.scaleCanvas) {
      return false;
    }

    return true;
  }
}
