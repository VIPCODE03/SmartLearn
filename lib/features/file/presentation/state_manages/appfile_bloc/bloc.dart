import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/delete_params.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';
import 'package:smart_learn/features/file/domain/parameters/load_params.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_create_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_delete_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_load_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_update_usecase.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/events.dart';
import 'package:smart_learn/features/file/presentation/state_manages/appfile_bloc/states.dart';
import 'package:smart_learn/app/services/storage_service.dart';

class AppFileBloc extends Bloc<AppFileEvent, AppFileState> {
  final List<Map<String, String>> stackFolder = [];
  String get currentPathID => stackFolder.last['pathId'] ?? '';
  bool get isRoot => stackFolder.length == 1;
  FileExtenalValue? fileExtenal;

  final UCEAppFileCreate create;
  final UCEAppFileDelete delete;
  final UCEAppFileUpdate update;
  final UCEAppFileLoad load;

  AppFileBloc({
    required this.create,
    required this.delete,
    required this.update,
    required this.load,
  }) : super(const AppFileInitial()) {
    on<AppFileLoadEvent>(_onLoad);
    on<AppFileCreateEvent>(_onCreate);
    on<AppFileUpdateEvent>(_onUpdate);
    on<AppFileDeleteEvent>(_onDelete);
    on<AppFileBackFolder>(_onBackFolder);
  }

  void _updateStack(String pathID, String nameFolder) {
    for(var i = stackFolder.length - 1; i >= 0; i--) {
      if(stackFolder[i]['pathId'] == pathID) {
        stackFolder.removeRange(i, stackFolder.length);
        break;
      }
    }
    stackFolder.add({
      'pathId': pathID,
      'nameFolder': nameFolder
    });
  }

  void _onLoad(AppFileLoadEvent event, Emitter<AppFileState> emit) async {
    fileExtenal ??= event.params.link;
    _updateStack(event.params.pathId, event.nameFolder);
    emit(const AppFileLoading());
    final result = await load(event.params);
    result.fold(
          (failure) => emit(const AppFileLoadError('Đã xảy ra lỗi')),
          (files) => emit(AppFileLoaded(files, stackFolder: stackFolder)),
    );
  }

  void _onCreate(AppFileCreateEvent event, Emitter<AppFileState> emit) async {
    final currentState = state;
    if(currentState is AppFileHasData) {
      emit(AppFileCreating(currentState.files, stackFolder: currentState.stackFolder));
      Either<Failure, ENTAppFile> result = await create(event.params);

      result.fold(
            (failure) => emit(AppFileCreateError(currentState.files, 'Đã xảy ra lỗi')),
            (file) {
              final newFiles = List<ENTAppFile>.from(currentState.files)..add(file);
              emit(AppFileCreated(newFiles, file, stackFolder: currentState.stackFolder));
            },
      );
    }
  }

  void _onUpdate(AppFileUpdateEvent event, Emitter<AppFileState> emit) async {
    final currentState = state;
    if(currentState is AppFileHasData) {
      emit(AppFileUpdating(currentState.files, stackFolder: currentState.stackFolder));
      Either<Failure, ENTAppFile>? result = await update(event.params);
      result.fold(
              (failure) => emit(AppFileUpdateError(currentState.files, 'Đã xảy ra lỗi', stackFolder: currentState.stackFolder)),
              (fileUpdated) {
                final newFiles = List<ENTAppFile>.from(currentState.files);
                final index = newFiles.indexWhere((file) => file.id == fileUpdated.id);
                newFiles[index] = fileUpdated;
                emit(AppFileUpdated(newFiles, stackFolder: currentState.stackFolder));
          }
      );
    }
  }

  void _onDelete(AppFileDeleteEvent event, Emitter<AppFileState> emit) async {
    if(state is AppFileHasData) {
      final currentState = state as AppFileHasData;
      emit(const AppFileLoading());
      final result = await delete(AppFileDeleteParams(file: event.file));
      result.fold(
            (failure) => emit(const AppFileLoadError('Đã xảy ra lỗi')),
            (completed) {
              emit(AppFileDeleted(currentState.files.where((file) => file.id != event.file.id).toList()));

              final file = event.file;
              if(file is ENTAppFileSystem) {
                AppStorageService.deleteFile(file.filePath);
              }
            },
      );
    }
  }

  void _onBackFolder(AppFileBackFolder event, Emitter<AppFileState> emit) async {
    if(stackFolder.length > 1 && fileExtenal != null) {
      stackFolder.removeLast();
      emit(const AppFileLoading());
      final result = await load(AppFileLoadParams(
          fileExtenal!,
          pathId: currentPathID
      ));
      result.fold(
            (failure) => emit(const AppFileLoadError('Đã xảy ra lỗi')),
            (files) => emit(AppFileLoaded(files, stackFolder: stackFolder)),
      );
    }
  }
}


