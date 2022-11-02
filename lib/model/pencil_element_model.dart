import 'dart:ui';

import 'package:unlimited_canvas_plan2/model/base_element_model.dart';

/// 笔迹元素模型
class PencilElementModel extends BaseElementModel {
  /// 笔迹上所有的点
  List<Offset> points = [];

  /// 这条笔迹上最左边的x
  double mostLeftX = 0;

  /// 这条笔迹上最右边的x
  double mostRightX = 0;

  /// 这条笔迹上最上边的y
  double mostTopY = 0;

  /// 这条笔迹上最下边的y
  double mostBottomY = 0;

  /// 绘制完后设置一下P1和P2
  void setP1P2() {
    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      if (i == 0) {
        mostLeftX = point.dx;
        mostRightX = point.dx;
        mostTopY = point.dy;
        mostBottomY = point.dy;
      } else {
        if (point.dx < mostLeftX) {
          mostLeftX = point.dx;
        }

        if (point.dx > mostRightX) {
          mostRightX = point.dx;
        }

        if (point.dy < mostTopY) {
          mostTopY = point.dy;
        }

        if (point.dy > mostBottomY) {
          mostBottomY = point.dy;
        }
      }
    }
    p1 = Offset(mostLeftX, mostTopY);
    p2 = Offset(mostRightX, mostBottomY);
  }
}
