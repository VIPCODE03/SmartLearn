abstract class AnalysisCommand {}

class DataAnalysisCommand implements AnalysisCommand {
  final String tag;
  final String ownerId;
  final String data;
  final String analysisGuide;

  DataAnalysisCommand({required this.tag, required this.ownerId, required this.data, required this.analysisGuide});
}

class StopWorkerCommand implements AnalysisCommand {}