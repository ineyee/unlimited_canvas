import 'dart:ui';

import 'package:unlimited_canvas_plan2/model/base_element_model.dart';

/// 图形元素模型
class GraphicsElementModel extends BaseElementModel {
  GraphicsElementModel({
    Offset p1 = Offset.zero,
    Offset p2 = Offset.zero,
  }) : super(
          p1: p1,
          p2: p2,
        );
}
