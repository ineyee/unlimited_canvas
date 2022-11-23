import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fps_widget/fps_widget.dart';
import 'package:unlimited_canvas_plan2/widget/background_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/graphics_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/pencil_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/drawing_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/gesture_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/tool_bar_widget.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// 白板界面，从下往上分为5层：
///
/// 1、背景层
/// 2、图形层
/// 3、笔迹层
/// 4、实时绘制层
/// 5、手势层
class WhiteBoardPage extends StatelessWidget {
  WhiteBoardPage({Key? key}) : super(key: key);

  final _whiteBoardViewModel = Get.put(WhiteBoardViewModel());

  @override
  Widget build(BuildContext context) {
    _whiteBoardViewModel.visibleAreaSize = MediaQuery.of(context).size;
    _whiteBoardViewModel.visibleAreaCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    // 设置画布的原点为可视区域的中心，即一上来就把画布的原点translate到可视区域中心的位置
    // 桌面端的窗口拖动改变大小时会实时触发这个赋值操作，为了保证只有第一次才赋值所以加个Offset.zero的判断
    if (_whiteBoardViewModel.curCanvasOffset == Offset.zero) {
      _whiteBoardViewModel.curCanvasOffset =
          _whiteBoardViewModel.visibleAreaCenter;
    }

    return Scaffold(
      body: FPSWidget(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            const BackgroundLayerWidget(),
            const GraphicsLayerWidget(),
            const PencilLayerWidget(),
            const DrawingLayerWidget(),
            GestureLayerWidget(),
            const Positioned(
              top: 20,
              right: 20,
              child: ToolBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
