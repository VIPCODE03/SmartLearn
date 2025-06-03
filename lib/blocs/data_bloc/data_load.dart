// import 'package:smart_learn/blocs/data_bloc/data_bloc.dart';
// import 'package:smart_learn/data/models/subject/a_subject.dart';
// import 'package:smart_learn/data/models/subject/b_theory.dart';
//
// mixin DataLoad {
//   Future<Object?> load(LoadDataEvent loadEvent) async {
//     return switch (loadEvent) {
//       LoadAllSubject() => [],
//
//       LoadSubjectByName() => {
//         print(loadEvent.name)
//       },
//
//       LoadTheoryBySubject() => [Theory(id: 1, subjectId: 1, title: 'title')],
//
//       LoadDataEvent() => throw UnimplementedError(),
//     };
//   }
// }
//
//
// //-------------------------------LoadSubject--------------------------------------
// ///______________________________________________________________________________
// abstract class LoadSubject extends LoadDataEvent<List<Subject>> {}
//
// class LoadAllSubject extends LoadSubject {}
//
// class LoadSubjectByName extends LoadSubject {
//   final String name;
//   LoadSubjectByName(this.name);
// }
//
// abstract class LoadTheory extends LoadDataEvent<List<Theory>> {}
//
// class LoadTheoryBySubject extends LoadTheory {
//   final int subjectId;
//   LoadTheoryBySubject(this.subjectId);
// }
