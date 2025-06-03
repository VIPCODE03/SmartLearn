// import 'package:smart_learn/data/models/file/file.dart';
//
// class Exercise {
//   int subjectId;
//   AppFile? fileQuizz;
//
//   Exercise({
//     required this.subjectId,
//     this.fileQuizz,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'subjectId': subjectId,
//       'fileQuizz': fileQuizz?.toJson()
//     };
//   }
//
//   factory Exercise.fromMap(Map<String, dynamic> map) {
//     return Exercise(
//         subjectId: map['subjectId'],
//         fileQuizz: (AppFile.fromJson(map['fileQuizz'] as Map<String, dynamic>))
//     );
//   }
// }