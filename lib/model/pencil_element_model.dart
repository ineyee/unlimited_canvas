import 'dart:ui';

import 'package:unlimited_canvas_plan2/model/base_element_model.dart';

/// 笔迹元素模型
class PencilElementModel extends BaseElementModel {
  /// 笔迹上所有的点
  List<Offset> points = [];

  /// 这条笔迹上最左边的x
  double _mostLeftX = 0;

  /// 这条笔迹上最右边的x
  double _mostRightX = 0;

  /// 这条笔迹上最上边的y
  double _mostTopY = 0;

  /// 这条笔迹上最下边的y
  double _mostBottomY = 0;

  /// 绘制完后设置一下P1和P2
  void setP1P2() {
    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      if (i == 0) {
        _mostLeftX = point.dx;
        _mostRightX = point.dx;
        _mostTopY = point.dy;
        _mostBottomY = point.dy;
      } else {
        if (point.dx < _mostLeftX) {
          _mostLeftX = point.dx;
        }

        if (point.dx > _mostRightX) {
          _mostRightX = point.dx;
        }

        if (point.dy < _mostTopY) {
          _mostTopY = point.dy;
        }

        if (point.dy > _mostBottomY) {
          _mostBottomY = point.dy;
        }
      }
    }
    p1 = Offset(_mostLeftX, _mostTopY);
    p2 = Offset(_mostRightX, _mostBottomY);
  }
}
