import 'package:flutter/material.dart';

enum ViewMode { listView, gridView }

class ViewProvider with ChangeNotifier {
  ViewMode mode;
  ViewProvider({this.mode = ViewMode.listView});

  void toggleMode() {
    mode = mode == ViewMode.listView ? ViewMode.gridView : ViewMode.listView;
    notifyListeners();
  }
}
