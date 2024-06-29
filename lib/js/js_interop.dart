@JS()
library js_interop;

import 'package:js/js.dart';
import 'dart:js_util';

@JS('selectFolderAndUpload')
external void selectFolderAndUpload(Function callback);