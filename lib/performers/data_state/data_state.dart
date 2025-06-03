
import 'package:performer/performer.dart';

abstract class Data extends DataState {
  final StateData state;
  const Data(this.state);
}

enum StateData {init, loading, loaded, updating, updated, error}
