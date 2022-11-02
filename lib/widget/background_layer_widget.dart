import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/const/const_number.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// 背景层Widget，本质上就是一个画布
class BackgroundLayerWidget extends StatelessWidget {
  const BackgroundLayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhiteBoardViewModel>(builder: (_) {
      return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: BGPainter(
          visibleAreaWidth: MediaQuery.of(context).size.width / 2,
          visibleAreaHeight: MediaQuery.of(context).size.height / 2,
        ),
      );
    });
  }
}

class BGPainter extends CustomPainter {
  BGPainter({
    this.visibleAreaWidth = 0,
    this.visibleAreaHeight = 0,
  });

  final double visibleAreaWidth;
  final double visibleAreaHeight;
  final WhiteBoardViewModel _canvasViewModel = Get.find<WhiteBoardViewModel>();

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.translate(_canvasViewModel.curCanvasOffset.dx,
    //     _canvasViewModel.curCanvasOffset.dy);
    // canvas.scale(
    //     _canvasViewModel.canvasScale, _canvasViewModel.canvasScale);
    // drawGrid(canvas, size);
    // drawCoo(canvas, Size(ConstNumber.screenWidth / 2, ConstNumber.screenHeight / 2), size);
    // drawCenter(canvas, _canvasViewModel.curCanvasOffset);
  }

  @override
  bool shouldRepaint(covariant BGPainter oldDelegate) {
    return true;
  }
}

extension DrawBG on BGPainter {
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

/*
  坐标系路径
  @param coo     坐标点
  @param winSize 屏幕尺寸
  @return 坐标系路径
 */
  Path cooPath(Size coo, Size winSize) {
    Path path = Path();
    //x正半轴线
    path.moveTo(coo.width, coo.height);
    path.lineTo(winSize.width, coo.height);
    //x负半轴线
    path.moveTo(coo.width, coo.height);
    path.lineTo(coo.width - winSize.width, coo.height);
    //y负半轴线
    path.moveTo(coo.width, coo.height);
    path.lineTo(coo.width, coo.height - winSize.height);
    //y负半轴线
    path.moveTo(coo.width, coo.height);
    path.lineTo(coo.width, winSize.height);
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

//绘制坐标系
  drawCoo(Canvas canvas, Size coo, Size winSize) {
    //初始化网格画笔
    Paint paint = Paint();
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;

    //绘制直线
    canvas.drawPath(cooPath(coo, winSize), paint);
    //左箭头
    canvas.drawLine(Offset(winSize.width, coo.height),
        Offset(winSize.width - 10, coo.height - 6), paint);
    canvas.drawLine(Offset(winSize.width, coo.height),
        Offset(winSize.width - 10, coo.height + 6), paint);
    //下箭头
    canvas.drawLine(Offset(coo.width, winSize.height),
        Offset(coo.width - 6, winSize.height - 10), paint);
    canvas.drawLine(Offset(coo.width, winSize.height),
        Offset(coo.width + 6, winSize.height - 10), paint);
  }

//绘制中心点
  drawCenter(Canvas canvas, Offset offset,
      [double radius = 10.0, int color = 0xff06BDe8]) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Colors.red; // || Color(color);
    canvas.drawCircle(offset, radius, paint);
  }
}
