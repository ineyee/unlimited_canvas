import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/model/base_element_model.dart';
import 'package:unlimited_canvas_plan2/model/graphics_element_model.dart';
import 'package:unlimited_canvas_plan2/model/pencil_element_model.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 实时绘制层Widget
class DrawingLayerWidget extends StatelessWidget {
  const DrawingLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.drawingLayerWidgetId,
      builder: (WhiteBoardViewModel whiteBoardViewModel) {
        return Container(
          color: Colors.red.withOpacity(0.5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: _DrawingLayerPainter(),
            ),
          ),
        );
      },
    );
  }
}

class _DrawingLayerPainter extends CustomPainter {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("DrawingLayerWidget===repaint");

    canvas.translate(
      _whiteBoardViewModel.curCanvasOffset.dx,
      _whiteBoardViewModel.curCanvasOffset.dy,
    );
    canvas.scale(
      _whiteBoardViewModel.curCanvasScale,
      _whiteBoardViewModel.curCanvasScale,
    );

    for (BaseElementModel baseElementModel
        in _whiteBoardViewModel.drawingElementModelList) {
      if (baseElementModel is GraphicsElementModel) {
        canvas.drawRect(
          Rect.fromPoints(
            baseElementModel.p1,
            baseElementModel.p2,
          ),
          Paint()..color = Colors.yellow,
        );
      } else if (baseElementModel is PencilElementModel) {
        Path path = Path();
        int i = 0;
        for (Offset item in baseElementModel.points) {
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
            ..style = PaintingStyle.stroke
            ..blendMode = BlendMode.srcOver,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingLayerPainter oldDelegate) {
    return true;
  }
}
