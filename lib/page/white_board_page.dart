import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fps_widget/fps_widget.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/widget/background_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/graphics_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/pencil_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/gesture_layer_widget.dart';
import 'package:unlimited_canvas_plan2/widget/tool_bar_widget.dart';

/// 白板界面
class WhiteBoardPage extends StatelessWidget {
  WhiteBoardPage({Key? key}) : super(key: key);

  final _whiteBoardViewModel = Get.put(WhiteBoardViewModel());

  @override
  Widget build(BuildContext context) {
    // 设置画布的原点为可视区域的中心，即一上来就把画布的原点translate到可视区域中心的位置
    // _whiteBoardViewModel.curCanvasOffset = Offset(
    //   MediaQuery.of(context).size.width / 2,
    //   MediaQuery.of(context).size.height / 2,
    // );

    return Scaffold(
      body: FPSWidget(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            // const BackgroundLayerWidget(),
            const GraphicsLayerWidget(),
            // const PencilLayerWidget(),
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
