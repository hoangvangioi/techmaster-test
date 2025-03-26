import 'dart:ffi';
import 'dart:io';

import 'eight_queens_bindings_generated.dart';

// Gọi hàm solveNQ
void solve() => _bindings.solveNQ();

// Hàm lấy các giải pháp từ thư viện C
Pointer<Int> getSolutions() => _bindings.getSolutions();

const String _libName = 'eight_queens';

/// The dynamic library in which the symbols for [EightQueensBindings] can be found.
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
final EightQueensBindings _bindings = EightQueensBindings(_dylib);
