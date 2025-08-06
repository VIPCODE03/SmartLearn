class ENTMatrixSquare {
  final String value;
  final String type;
  final bool isHide;

  ENTMatrixSquare({
    required this.value,
    this.type = '',
    this.isHide = false,
  });

  bool check(String value) {
    return this.value == value;
  }

  @override
  String toString() {
    return '(value: $value, type: $type, isHide: $isHide)';
  }
}
