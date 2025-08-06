import 'package:uuid/uuid.dart';

class UTIGenerateID {
  static const Uuid _uuid = Uuid();

  static String random() => _uuid.v4();
}
