import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/algorithm/algorithm_util.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';

/// 笔迹层Widget
class PencilLayerWidget extends StatelessWidget {
  const PencilLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.pencilLayerPainterId,
      builder: (_) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
    canvas.translate(
      _whiteBoardViewModel.curCanvasOffset.dx,
      _whiteBoardViewModel.curCanvasOffset.dy,
    );
    canvas.scale(
      _whiteBoardViewModel.curCanvasScale,
      _whiteBoardViewModel.curCanvasScale,
    );

    Rect visibleAreaRect = Rect.fromLTWH(0, 0, size.width, size.height);
    if (_whiteBoardViewModel.operationType == OperationType.translateCanvas ||
        _whiteBoardViewModel.operationType == OperationType.scaleCanvas ||
        _whiteBoardViewModel.operationType ==
            OperationType.translateAndScaleCanvas) {
      for (PencilElementModel pencilElementModel
          in _whiteBoardViewModel.pencilElementModelList) {
        Rect elementVisibleRect = AlgorithmUtil.visibleRectOfElement(
          baseElementModel: pencilElementModel,
          curCanvasOffset: _whiteBoardViewModel.curCanvasOffset,
          curCanvasScale: _whiteBoardViewModel.curCanvasScale,
        );
        if (visibleAreaRect.overlaps(elementVisibleRect)) {
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
    } else {
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
  }

  @override
  bool shouldRepaint(covariant _PencilLayerPainter oldDelegate) {
    return true;
  }
}
