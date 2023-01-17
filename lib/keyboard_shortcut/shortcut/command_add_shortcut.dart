import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:platform_info/platform_info.dart';
import 'package:unlimited_canvas_plan2/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// [command +] on macOS
/// [control +] on Windows
///
/// 注意：可能是 + 的兼容性没做好，这个组合键没反应，此处用 = 替代加号，
/// 因为 + = 是一个按键
class CommandAddShortcut {
  CommandAddShortcut._();

  /// [command/control +]的快捷键
  // static final ShortcutActivator shortcutActivator = LogicalKeySet(
  //   Platform.I.operatingSystem == OperatingSystem.macOS
  //       ? LogicalKeyboardKey.meta
  //       : LogicalKeyboardKey.control,
  //   LogicalKeyboardKey.equal,
  // );
  static final ShortcutActivator shortcutActivator = SingleActivator(
    LogicalKeyboardKey.equal,
    meta: Platform.I.operatingSystem == OperatingSystem.macOS ? true : false,
    control: Platform.I.operatingSystem == OperatingSystem.macOS ? false : true,
  );

  /// [command/control +]的意图和意图的类型
  static const Intent intent = _CustomIntent1();
  static const Type intentType = _CustomIntent1;

  /// [command/control +]的事件
  static final Action action = _CustomIAction1();
}

class _CustomIntent1 extends Intent {
  const _CustomIntent1();
}

class _CustomIAction1 extends Action<_CustomIntent1> {
  _CustomIAction1();

  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  @override
  void invoke(covariant _CustomIntent1 intent) {
    debugPrint("点击了键盘快捷键===>[command +]");
    // 放大
    _whiteBoardViewModel.operationType = OperationType.scaleCanvas;
    _whiteBoardViewModel.aroundScreenScaleTo(
      targetScale: double.parse((_whiteBoardViewModel.curCanvasScale +
                      _whiteBoardViewModel.stepScale)
                  .toStringAsFixed(1)) >=
              _whiteBoardViewModel.maxCanvasScale
          ? _whiteBoardViewModel.maxCanvasScale
          : _whiteBoardViewModel.curCanvasScale +
              _whiteBoardViewModel.stepScale,
      animationController: KeyboardShortcut.animationController!,
      scaleTween: KeyboardShortcut.tween!,
    );
  }
}
