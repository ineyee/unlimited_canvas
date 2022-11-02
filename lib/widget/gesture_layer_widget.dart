import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// 手势层Widget
class GestureLayerWidget extends StatelessWidget {
  GestureLayerWidget({Key? key}) : super(key: key);

  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 专门用来做可触控设备对画布进行的多指缩放操作
      child: Listener(
        // 这个做的就多了，无论什么端：画布的平移操作、鼠标滚轮和触控板对画布的缩放操作、所有的绘制事件等
        behavior: HitTestBehavior.opaque,
        onPointerDown: (PointerDownEvent event) {
          _whiteBoardViewModel.onPointerDown(event);
        },
        onPointerMove: (PointerMoveEvent event) {
          _whiteBoardViewModel.onPointerMove(event);
        },
        onPointerUp: (PointerUpEvent event) {
          _whiteBoardViewModel.onPointerUp(event);
        },
        onPointerSignal: (PointerSignalEvent event) {
          _whiteBoardViewModel.onPointerSignal(event);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
      onScaleStart: (ScaleStartDetails details) {
        _whiteBoardViewModel.onScaleStart(details);
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _whiteBoardViewModel.onScaleUpdate(details);
      },
      onScaleEnd: (ScaleEndDetails details) {
        _whiteBoardViewModel.onScaleEnd(details);
      },
    );
  }
}
