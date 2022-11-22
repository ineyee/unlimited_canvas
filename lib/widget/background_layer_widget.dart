import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/const/const_number.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

/// 背景层Widget
class BackgroundLayerWidget extends StatelessWidget {
  const BackgroundLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(
      id: ConstString.backgroundLayerWidgetId,
      builder: (WhiteBoardViewModel whiteBoardViewModel) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              whiteBoardViewModel.curCanvasOffset.dx - ConstNumber.screenWidth / 2,
              whiteBoardViewModel.curCanvasOffset.dy - ConstNumber.screenHeight / 2,
            )
            ..scale(whiteBoardViewModel.curCanvasScale),
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: _BackgroundLayerPainter(),
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundLayerPainter extends CustomPainter {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("BackgroundLayerWidget===repaint");

    drawDot(canvas);
  }

  @override
  bool shouldRepaint(covariant _BackgroundLayerPainter oldDelegate) {
    return true;
  }

  void drawDot(Canvas canvas) {
    double dotWidth = 1.5;
    double scale = _whiteBoardViewModel.curCanvasScale;
    double space = 40 * scale;

    double screenWidth = ConstNumber.screenWidth;
    double screenHeight = ConstNumber.screenHeight;

    Offset centerPoint = Offset(ConstNumber.screenWidth / 2, ConstNumber.screenHeight / 2);

    int i = 0;
    int j = 0;

    /// 左上角
    i = 0;
    for (double w = centerPoint.dy; w > 0; w -= space) {
      j = 0;
      for (double e = centerPoint.dx; e > 0; e -= space) {
        canvas.drawCircle(
            Offset(centerPoint.dx - space * j, centerPoint.dy - space * i),
            dotWidth,
            Paint());

        j++;
      }

      i++;
    }

    /// 右上角
    i = 0;
    for (double w = centerPoint.dy; w > 0; w -= space) {
      j = 0;
      for (double e = screenWidth - centerPoint.dx; e > 0; e -= space) {
        canvas.drawCircle(
            Offset(centerPoint.dx + space * j, centerPoint.dy - space * i),
            dotWidth,
            Paint());

        j++;
      }

      i++;
    }

    /// 右下角
    i = 0;
    for (double w = screenHeight - centerPoint.dy; w > 0; w -= space) {
      j = 0;
      for (double e = screenWidth - centerPoint.dx; e > 0; e -= space) {
        canvas.drawCircle(
            Offset(centerPoint.dx + space * j, centerPoint.dy + space * i),
            dotWidth,
            Paint());

        j++;
      }

      i++;
    }

    /// 左下角
    i = 0;
    for (double w = screenHeight - centerPoint.dy; w > 0; w -= space) {
      j = 0;
      for (double e = centerPoint.dx; e > 0; e -= space) {
        canvas.drawCircle(
            Offset(centerPoint.dx - space * j, centerPoint.dy + space * i),
            dotWidth,
            Paint());

        j++;
      }

      i++;
    }
  }

  /*
 绘制网格路径
 @param step   小正方形边长
 @param winSize 屏幕尺寸
 */
  Path gridPath(Size winSize, int step) {
    Path path = Path();

    for (int i = 0; i < winSize.height / step + 1; i++) {
      path.moveTo(0, step * i.toDouble());
      path.lineTo(winSize.width, step * i.toDouble());
    }

    for (int i = 0; i < winSize.width / step + 1; i++) {
      path.moveTo(step * i.toDouble(), 0);
      path.lineTo(step * i.toDouble(), winSize.height);
    }
    return path;
  }


  //绘制网格
  drawGrid(Canvas canvas, Size winSize,
      [int step = 10, int color = 0xff06BDF8]) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Color(color);
    paint.isAntiAlias = true;
    canvas.drawPath(gridPath(winSize, step), paint);
  }
}
