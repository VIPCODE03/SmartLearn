
class ENTAnalysis {
  final String id;
  final String tag;
  final String ownerId;
  final Map<int, String> analysis;
  final int version;

  ENTAnalysis({
    required this.id,
    required this.tag,
    required this.ownerId,
    required this.analysis,
    required this.version,
  });
}