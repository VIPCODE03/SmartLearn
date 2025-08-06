import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';

abstract class AppFileState extends Equatable {
  const AppFileState();

  @override
  List<Object> get props => [];
}

/// State không có dữ liệu
abstract class AppFileNoData extends AppFileState {
  const AppFileNoData();
}

class AppFileInitial extends AppFileNoData {
  const AppFileInitial();
}

class AppFileLoading extends AppFileNoData {
  const AppFileLoading();
}

class AppFileLoadError extends AppFileNoData {
  final String message;
  const AppFileLoadError(this.message);

  @override
  List<Object> get props => [message];
}

/// State có dữ liệu files
abstract class AppFileHasData extends AppFileState {
  final List<ENTAppFile> files;
  final List<Map<String, String>> stackFolder;

  const AppFileHasData(this.files, {this.stackFolder = const []});

  @override
  List<Object> get props => [files, stackFolder];
}

class AppFileLoaded extends AppFileHasData {
  const AppFileLoaded(super.files, {super.stackFolder});
}

class AppFileCreating extends AppFileHasData {
  const AppFileCreating(super.files, {super.stackFolder});
}

class AppFileCreated extends AppFileHasData {
  final ENTAppFile file;
  const AppFileCreated(super.files, this.file, {super.stackFolder});
}

class AppFileUpdating extends AppFileHasData {
  const AppFileUpdating(super.files, {super.stackFolder});
}

class AppFileUpdated extends AppFileHasData {
  const AppFileUpdated(super.files, {super.stackFolder});
}

class AppFileDeleting extends AppFileHasData {
  const AppFileDeleting(super.files, {super.stackFolder});
}

class AppFileDeleted extends AppFileHasData {
  const AppFileDeleted(super.files, {super.stackFolder});
}

/// ❗ State báo lỗi
abstract class AppFileError extends AppFileHasData {
  final String message;
  const AppFileError(super.files, this.message, {super.stackFolder});
  @override
  List<Object> get props => super.props..add(message);
}

class AppFileCreateError extends AppFileError {
  const AppFileCreateError(super.files, super.message, {super.stackFolder});
}

class AppFileUpdateError extends AppFileError {
  const AppFileUpdateError(super.files, super.message, {super.stackFolder});
}

class AppFileDeleteError extends AppFileError {
  const AppFileDeleteError(super.files, super.message, {super.stackFolder});
}