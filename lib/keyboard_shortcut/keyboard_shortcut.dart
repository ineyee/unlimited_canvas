import 'package:flutter/material.dart';
import 'package:unlimited_canvas_plan2/keyboard_shortcut/shortcut/command_add_shortcut.dart';
import 'package:unlimited_canvas_plan2/keyboard_shortcut/shortcut/command_minus_shortcut.dart';

class KeyboardShortcut {
  KeyboardShortcut._();

  /// 快捷键和意图的映射
  static final Map<ShortcutActivator, Intent> shortcuts = {
    CommandMinusShortcut.shortcutActivator: CommandMinusShortcut.intent,
    CommandAddShortcut.shortcutActivator: CommandAddShortcut.intent,
  };

  /// 意图（类型而非实例）和事件的映射
  static final Map<Type, Action<Intent>> actions = {
    CommandMinusShortcut.intentType: CommandMinusShortcut.action,
    CommandAddShortcut.intentType: CommandAddShortcut.action,
  };

  /// 缩放动画相关
  static AnimationController? animationController;
  static Tween<double>? tween;
}
