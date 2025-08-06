import 'package:smart_learn/features/file/domain/parameters/file_params.dart';

enum TypeFile {
  folder, txt, draw, quiz, system
}

class AppFileCreateParams {
  final FileForeignParams link;
  final String name;
  final String pathId;
  final TypeFile type;
  final dynamic data;

  const AppFileCreateParams.folder(this.link, {required this.name, required this.pathId}) : type = TypeFile.folder, data = null;
  const AppFileCreateParams.txt(this.link, {required this.name, required this.pathId, String? content}) : type = TypeFile.txt, data = content;
  const AppFileCreateParams.draw(this.link, {required this.name, required this.pathId, String? json}) : type = TypeFile.draw, data = json;
  const AppFileCreateParams.quiz(this.link, {required this.name, required this.pathId}) : type = TypeFile.quiz, data = null;
  const AppFileCreateParams.system(this.link, {required this.name, required this.pathId, required String filePath}) : type = TypeFile.system, data = filePath;
}