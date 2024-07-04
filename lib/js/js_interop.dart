@JS()
library js_interop;

import 'package:js/js.dart';

@JS('selectFolderAndUpload')
external Future<void> selectFolderAndUpload(Function callback);