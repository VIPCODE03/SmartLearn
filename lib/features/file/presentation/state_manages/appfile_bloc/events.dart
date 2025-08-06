import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/create_params.dart';
import 'package:smart_learn/features/file/domain/parameters/load_params.dart';
import 'package:smart_learn/features/file/domain/parameters/update_params.dart';

abstract class AppFileEvent extends Equatable {
  const AppFileEvent();

  @override
  List<Object?> get props => [];
}

class AppFileLoadEvent extends AppFileEvent {
  final String nameFolder;
  final AppFileLoadParams params;
  const AppFileLoadEvent({required this.params, this.nameFolder = ''});
}

//- Tạo mới -
class AppFileCreateEvent extends AppFileEvent {
  final AppFileCreateParams params;
  const AppFileCreateEvent(this.params);
}

//- Cập nhật  -
class AppFileUpdateEvent extends AppFileEvent {
  final AppFileUpdateParams params;
  const AppFileUpdateEvent(this.params);
}

//- Xóa -
class AppFileDeleteEvent extends AppFileEvent {
  final ENTAppFile file;
  const AppFileDeleteEvent({required this.file});
}