import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:platform_info/platform_info.dart';
import 'package:unlimited_canvas_plan2/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// [command -] on macOS
/// [control -] on Windows
class CommandMinusShortcut {
  CommandMinusShortcut._();

  /// [command -]的快捷键
  /// 不要使用LogicalKeySet，因为它在快速切换两组按键时会有延时
  /// 见这个issue:https://github.com/flutter/flutter/issues/97589
  // static final ShortcutActivator shortcutActivator = LogicalKeySet(
  //   Platform.I.operatingSystem == OperatingSystem.macOS
  //       ? LogicalKeyboardKey.meta
  //       : LogicalKeyboardKey.control,
  //   LogicalKeyboardKey.minus,
  // );
  static final ShortcutActivator shortcutActivator = SingleActivator(
    LogicalKeyboardKey.minus,
    meta: Platform.I.operatingSystem == OperatingSystem.macOS ? true : false,
    control: Platform.I.operatingSystem == OperatingSystem.macOS ? false : true,
  );

  /// [command -]的意图和意图的类型
  static const Intent intent = _CustomIntent();
  static const Type intentType = _CustomIntent;

  /// [command -]的事件
  static final Action action = _CustomIAction();
}

class _CustomIntent extends Intent {
  const _CustomIntent();
}

class _CustomIAction extends Action<_CustomIntent> {
  _CustomIAction();

  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void invoke(covariant _CustomIntent intent) {
    debugPrint("点击了键盘快捷键===>[command -]");
    // 缩小
    _whiteBoardViewModel.operationType = OperationType.scaleCanvas;
    _whiteBoardViewModel.aroundScreenScaleTo(
      targetScale: double.parse((_whiteBoardViewModel.curCanvasScale -
                      _whiteBoardViewModel.stepScale)
                  .toStringAsFixed(1)) <=
              _whiteBoardViewModel.minCanvasScale
          ? _whiteBoardViewModel.minCanvasScale
          : _whiteBoardViewModel.curCanvasScale -
              _whiteBoardViewModel.stepScale,
      animationController: KeyboardShortcut.animationController!,
      scaleTween: KeyboardShortcut.tween!,
    );
  }
}
