import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unlimited_canvas_plan2/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';

/// 键盘快捷键监听Widget
class KeyboardShortcutListener extends StatefulWidget {
  const KeyboardShortcutListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<KeyboardShortcutListener> createState() =>
      _KeyboardShortcutListenerState();
}

class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener>
    with TickerProviderStateMixin {
  final WhiteBoardViewModel _whiteBoardViewModel =
      Get.find<WhiteBoardViewModel>();

  late AnimationController _scaleAnimationController;
  late CurvedAnimation _scaleCurvedAnimation;
  late Tween<double> _scaleTween;
  late Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _scaleCurvedAnimation = CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.linear);
    _scaleTween = Tween<double>();
    _scaleAnimation = _scaleTween.animate(_scaleCurvedAnimation);
    _scaleAnimation.addListener(() {
      _whiteBoardViewModel.updateLayerWidgetScale(
        scale: _scaleAnimation.value,
      );
    });
    _scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _whiteBoardViewModel.updateToolBarWidget();
        _whiteBoardViewModel.updatePresentationLayerWidget();
      }
    });

    KeyboardShortcut.animationController = _scaleAnimationController;
    KeyboardShortcut.tween = _scaleTween;
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: KeyboardShortcut.shortcuts,
      child: Actions(
        actions: KeyboardShortcut.actions,
        child: Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            debugPrint("222===>$event");
            return KeyEventResult.ignored;
          },
          child: widget.child,
        ),
      ),
    );
  }
}
