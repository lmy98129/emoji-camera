import 'package:flutter/material.dart';

class PreviewModel with ChangeNotifier {
  int _currentPage = 0;

  get currentPage => _currentPage;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void resetPage() {
    _currentPage = 0;
  }

}