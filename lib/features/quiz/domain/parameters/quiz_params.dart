
abstract class QuizParams {
  final ForeignKeyParams foreign;
  QuizParams(this.foreign);
}

class ForeignKeyParams {
  final String? fileId;
  ForeignKeyParams({this.fileId});
}