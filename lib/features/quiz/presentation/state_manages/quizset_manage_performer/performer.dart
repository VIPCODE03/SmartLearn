
import 'package:performer/performer.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quizset_manage_performer/state.dart';

class QuizManagePerformer extends Performer<QuizManageState> {
  QuizManagePerformer() : super(data: const QuizManageInitState());

  String get promptAI => 'Bạn muốn tạo về chủ đề nào?';

  String get instructAI => '''
    Model được chuyển vào chế độ tạo dữ liệu cho quiz.
    Có 2 loại quiz trắc nghiệm chọn 1 và nhiều đáp án đúng.
    Khi demo bạn chỉ cần đưa ra câu hỏi, các đáp án
  ''';
}