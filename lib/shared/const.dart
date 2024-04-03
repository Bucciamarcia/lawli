const String logoPath = "assets/images/lawli_logo.png";

class CloudStorageConstants {
  String getRiassuntoPath(String accountName, String idPratica, String rootFileName) {
    return "accounts/$accountName/pratiche/$idPratica/riassunti/$rootFileName.txt";
  }
}

// Trasforma un filename. Ex input: "Gmail - New Order Confirmation_ IN139829.pdf"
class TransformDocumentName {
  // input: "Gmail - New Order Confirmation_ IN139829.pdf"
  String firebaseDocumentFirename;
  TransformDocumentName(this.firebaseDocumentFirename);

  // Ex: "filename.pdf" -> "filename"
  String getRootFilename() {
    return firebaseDocumentFirename.split(RegExp(r'\.(?!.*\.)')).first;
  }

  // Ex: "filename.pdf" -> "originale_filename.pdf"
  String getOriginaleFilename() {
    return "originale_$firebaseDocumentFirename";
  }

  // Ex: "filename.pdf" -> "filename.txt"
  String getTxtVersion() {
    return "${getRootFilename()}.txt";
  }
}