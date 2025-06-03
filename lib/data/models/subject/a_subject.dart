
import 'package:smart_learn/data/models/file/file.dart';

class Subject {
  final int id;
  String name;
  List<AppFile>? theories;
  List<AppFile>? exercises;
  String lastStudyDate;
  List<double> exercisesScores;

  Subject({
    required this.id,
    required this.name,
    this.theories,
    this.exercises,
    required this.lastStudyDate,
    required this.exercisesScores,
  });

  double average() {
    double average = 0;
    int count = 0;
    int limit = exercisesScores.length;

    for (int i = limit - 1; i >= 0; i--) {
      average += exercisesScores[i];
      count++;
      if (count > 10) {
        break;
      }
    }
    return average / count;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'theories': theories?.map((e) => e.toJson()).toList(),
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'lastStudyDate': lastStudyDate,
      'exercisesScores': exercisesScores,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      theories: (map['theories'] as List<dynamic>?)
          ?.map((e) => AppFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      exercises: (map['exercises'] as List<dynamic>?)
          ?.map((e) => AppFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastStudyDate: map['lastStudyDate'],
      exercisesScores: (map['exercisesScores'] as List).cast<double>(),
    );
  }
}