import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

final String DEFAULT_MATTING_MODE = "image";
final String DEFAULT_SELECT_STATUS = "选择手机图片";
final String SELECTED_STATUS = "已选择图片";

class PreviewModel with ChangeNotifier {
  int _currentPage = 0;
  bool _isSelected = false;
  String _mattingMode = DEFAULT_MATTING_MODE;
  String _selectStatus = DEFAULT_SELECT_STATUS;
  Asset _selectedBgImage = null;

  get currentPage => _currentPage;
  get mattingMode => _mattingMode;
  get selectStatus => _selectStatus;
  get isSelect => _isSelected;
  get selectedBgImage => _selectedBgImage;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void resetPage() {
    _currentPage = 0;
  }

  void setMattingMode(value) {
    _mattingMode = value;
    notifyListeners();
  }

  void setSelectStatus(isSelected, { Asset path: null }) {
    if (isSelected) {
      _selectStatus = SELECTED_STATUS;
    } else {
      _selectStatus = DEFAULT_SELECT_STATUS;
    }
    _isSelected = isSelected;
    _selectedBgImage = path;
    notifyListeners();
  }
}