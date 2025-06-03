// import 'package:smart_learn/data/models/file/file.dart';
//
// class Theory {
//   AppFile? content;
//   final int subjectId;
//
//   Theory({
//     required this.subjectId,
//     this.content,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'subjectId': subjectId,
//       'title': title,
//       'contents': contents?.map((e) => e.toJson()).toList(),
//     };
//   }
//
//   factory Theory.fromJson(Map<String, dynamic> json) {
//     return Theory(
//       id: json['id'],
//       subjectId: json['subjectId'],
//       title: json['title'],
//       contents: (json['contents'] as List<dynamic>?)
//           ?.map((e) => AppFile.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
