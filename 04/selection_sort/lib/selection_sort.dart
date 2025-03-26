import 'dart:ffi';
import 'dart:io';

import 'selection_sort_bindings_generated.dart';

/// Lấy tổng số bước
int getTotalSteps() => _bindings.getTotalSteps();

/// Hàm khởi động thuật toán Selection Sort
/// @param arr: Mảng cần sắp xếp
/// @param length: Độ dài mảng
void selectionSort(Pointer<Int32> arr, int length) =>
    _bindings.startSelectionSort(arr, length);

/// Lấy một bước trong quá trình sắp xếp
/// @param index: Chỉ số bước cần lấy
/// @return Con trỏ đến cấu trúc SortStep tương ứng
SortStep getStep(int index) => _bindings.getStep(index);

const String _libName = 'selection_sort';

/// The dynamic library in which the symbols for [SelectionSortBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final SelectionSortBindings _bindings = SelectionSortBindings(_dylib);
