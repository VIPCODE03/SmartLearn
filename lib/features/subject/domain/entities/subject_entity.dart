class ENTSubject {
  final String id;
  final String name;
  final DateTime lastStudyDate;
  final List<String> tags;
  final String level;
  final List<double> exercisesScores;

  const ENTSubject({
    required this.id,
    required this.name,
    required this.lastStudyDate,
    required this.tags,
    required this.level,
    required this.exercisesScores,
  });

  double get averageCore {
    double average = 0;
    int count = 0;
    int limit = exercisesScores.length;
    if(limit == 0) return -1;

    for (int i = limit - 1; i >= 0; i--) {
      average += exercisesScores[i];
      count++;
    }
    return average / count;
  }
}