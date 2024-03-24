import 'models.dart';

class DocumentManipulation {

  List<Documento> orderDocumentByDate(List<Documento> docs) => docs..sort((a, b) => a.data.compareTo(b.data));

}