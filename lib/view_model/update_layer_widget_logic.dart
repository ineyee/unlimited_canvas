import 'package:unlimited_canvas_plan2/view_model/white_board_view_model.dart';
import 'package:unlimited_canvas_plan2/const/const_string.dart';

extension UpdateLayerWidgetLogic on WhiteBoardViewModel {
  void updateBackgroundLayerWidget() {
    update([
      ConstString.backgroundLayerWidgetId,
    ]);
  }

  void updateGraphicsLayerWidget() {
    update([
      ConstString.graphicsLayerWidgetId,
    ]);
  }

  void updatePencilLayerWidget() {
    update([
      ConstString.pencilLayerWidgetId,
    ]);
  }

  void updatePresentationLayerWidget() {
    update([
      ConstString.backgroundLayerWidgetId,
      ConstString.graphicsLayerWidgetId,
      ConstString.pencilLayerWidgetId,
    ]);
  }

  void updateDrawingLayerWidget() {
    update([
      ConstString.drawingLayerWidgetId,
    ]);
  }

  void updateToolBarWidget() {
    update([
      ConstString.toolBarWidgetId,
    ]);
  }
}
