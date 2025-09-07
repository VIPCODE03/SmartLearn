import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:get_it/get_it.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/core/shared_features/personalization/analysis_injection.dart';
import 'package:smart_learn/core/shared_features/personalization/api/analysis/commands/activi_record_command.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/parameters/dataanalysis_params.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/usecases/add_usecase.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/usecases/get_usecase.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/usecases/update_usecase.dart';
import 'package:smart_learn/core/shared_features/personalization/services/gemini_analysis_service.dart';

class APIAnalytics {
  Isolate? _isolate;
  SendPort? _sendPort;
  final _mainReceivePort = ReceivePort();
  final Completer<void> _isReady = Completer();

  Future<void> start() async {
    if (_isolate != null) return;

    _isolate = await Isolate.spawn(_workerEntryPoint, _mainReceivePort.sendPort);

    _mainReceivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        if (!_isReady.isCompleted) _isReady.complete();
      } else {
        logDev("Message from worker: $message");
      }
    });
  }

  Future<void> saveAnalysis(String tag, String ownerId, String data, String analysisGuide) async {
    await _isReady.future;
    _sendPort?.send(DataAnalysisCommand(tag: tag, ownerId: ownerId, data: data, analysisGuide: analysisGuide));
  }

  void dispose() {
    _sendPort?.send(StopWorkerCommand());
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _mainReceivePort.close();
  }
}

void _workerEntryPoint(SendPort mainSendPort) async {
  final workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  final getIt = GetIt.instance;
  await initAnalysisDI(getIt);
  final addUseCase = getIt<UCEAnalysisAdd>();
  final updateUseCase = getIt<UCEAnalysisUpdate>();
  final getUseCase = getIt<UCEDataAnalysisGetData>();

  await for (final command in workerReceivePort) {
    if (command is DataAnalysisCommand) {
      ENTAnalysis? analysis;
      final result = await getUseCase(PARDataAnalysisGetByOwnerId(command.ownerId));
      result.fold(
              (l) {
            logDev('error: getUseCase', context: '_workerEntryPoint');
            mainSendPort.send({'status': 'error', 'message': l.toString()});
          },
              (datas) {
            analysis = datas;
          });
      if(analysis != null) {
        final newData = command.data;
        final oldData = analysis!.analysis.toString();
        final data = ''
            'Dữ liệu phân tích cũ: $oldData'
            '\nDữ liệu cần phân tích: $newData';
        final resultAnalysis = await SERGeminiAnalysis.instance.analysis(data, command.analysisGuide);
        if(resultAnalysis != null) {
          if(resultAnalysis.isNotEmpty) {
            try {
              final resultAnalysisMap = jsonDecode(resultAnalysis) as Map<int, String>;
              final newAnalysis = {...analysis!.analysis, ...resultAnalysisMap};
              final updateParams = PARDataAnalysisUpdate(analysis!, analysis: newAnalysis);
              final resultUpdate = await updateUseCase(updateParams);
              resultUpdate.fold(
                    (l) => mainSendPort.send({'status': 'error', 'message': l.toString()}),
                    (r) => mainSendPort.send({'status': 'done', 'tag': command.tag}),
              );
            }
            catch(e, s) {
              logError(e.toString(), stackTrace: s, context: '_workerEntryPoint');
              mainSendPort.send({'status': 'error', 'message': e.toString()});
            }
          }
        }
      }
      else {}

      // final resultAdd = await addUseCase(params);
      // resultAdd.fold(
      //       (l) => mainSendPort.send({'status': 'error', 'message': l.toString()}),
      //       (r) => mainSendPort.send({'status': 'done', 'tag': command.tag}),
      // );
    } else if (command is StopWorkerCommand) {
      break;
    }
  }

  workerReceivePort.close();
  logDev("✅ Worker isolate stopped gracefully.");
}
