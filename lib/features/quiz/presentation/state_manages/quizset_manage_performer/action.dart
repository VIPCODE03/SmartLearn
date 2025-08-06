import 'package:performer/main.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_add_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_create_ai_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_get_params.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_update_params.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_add_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_create_quiz_ai_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_deleted_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_get_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_update_usecase.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';

abstract class QuizSetManageAction extends ActionUnit<QuizManageState> {
  final UCEQuizAdd add;
  final UCEQuizSetUpdate update;
  final UCEQuizSetGet get;
  final UCEQuizSetDeleted delete;
  final UCEQuizSetCreateQuizAI createQuiz;

  QuizSetManageAction()
      : add = getIt(),
        update = getIt(),
        get = getIt(),
        delete = getIt(),
        createQuiz = getIt();
}

//------
class CreateQuiz extends QuizSetManageAction {
  final QuizAddParams params;
  CreateQuiz({required this.params});

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    final result = await add(params);
    final currentData = current is QuizManageHasDataState ? current.quizzes : [];
    yield result.fold(
            (fail) => const QuizError(),
            (data) => data != null
            ? CreatedQuiz(quizzes: [...currentData, data])
            : const QuizError()
    );
  }
}

//-------
class UpdateQuiz extends QuizSetManageAction {
  final QuizUpdateParams params;
  UpdateQuiz({required this.params});

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    if(current is QuizManageHasDataState) {
      final result = await update(params);
      final currentData = [...current.quizzes];
      yield result.fold(
            (fail) => const QuizError(),
            (data) {
              final index = currentData.indexWhere((element) => element.id == data.id);
              if (index == -1) {
                return const QuizError();
              } else {
                currentData[index] = data;
              }
              return QuizLoaded(quizzes: currentData);
            },
      );
    }
  }
}

//------
class Load extends QuizSetManageAction {
  final QuizGetParams params;
  Load(this.params);

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    await Future.delayed(const Duration(milliseconds: 666));
    final result = await get(params);
    yield result.fold(
            (fail) => const QuizError(),
            (datas) => QuizLoaded(quizzes: datas)
    );
  }
}

class CreateQuizByAI extends QuizSetManageAction {
  final QuizCreateQuizAIParams params;
  CreateQuizByAI(this.params);

  @override
  Stream<QuizManageState> execute(QuizManageState current) async* {
    if (current is QuizManageHasDataState) {
      yield CreatingQuizByAI(quizzes: current.quizzes);
      final result = await createQuiz(params);
      yield result.fold(
              (fail) => current,
              (data) {
            if (data.isEmpty) {
              return current;
            }
            else {
              return CreatedQuizByAI(
                  quizzes: [...current.quizzes, ...data], newQuizzes: data);
            }
          }
      );
    }
  }
}
