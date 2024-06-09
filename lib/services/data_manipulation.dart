import 'package:cloud_functions/cloud_functions.dart';

import 'cloud_storage.dart';
import 'models.dart';

class DocumentManipulation {
  List<Documento> orderDocumentByDate(List<Documento> docs) =>
      docs..sort((a, b) => a.data.compareTo(b.data));

  Future<int> countDocumentoTokens(String path) async {
    String text = await DocumentStorage().getTextDocument(path);
    var response = await FirebaseFunctions.instance
        .httpsCallable("count_tokens")
        .call({"text": text});
    return response.data as int;
  }
}
