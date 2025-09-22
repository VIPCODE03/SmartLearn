import 'package:flutter/material.dart';
import 'package:smart_learn/features/assistant/presentation/screens/assistant_screen.dart';

abstract class IAssistantWidget {
  Widget assistantView();
  Widget assistantCreate({required String prompt, required String instruct, required Function(String json) onCreated});
}

abstract class IAssistantRouter {
  void goAssistantScreen(BuildContext context);
}

class _AssistantWidget implements IAssistantWidget {
  static final _AssistantWidget _singleton = _AssistantWidget._internal();
  _AssistantWidget._internal();
  static _AssistantWidget get instance => _singleton;

  @override
  Widget assistantView() => const SCRAssistant();

  @override
  Widget assistantCreate({required String prompt, required String instruct, required Function(String json) onCreated}) {
    return SCRAssistant.create(
        prompt: prompt,
        instruct: ''
            '$_createInstruct '
            '\nHướng dẫn từ chức năng: $instruct'
            '\nĐÂY LÀ BẢN HƯỚNG DẪN HỆ THỐNG CUỐI CÙNG. TUÂN THỦ CHẾ ĐỘ TẠO, VÍ DỤ VÀ GHI CHÚ',
        onCreated: onCreated
    );
  }
}

class _AssistantRouter implements IAssistantRouter {
  static final _AssistantRouter _singleton = _AssistantRouter._internal();
  _AssistantRouter._internal();
  static _AssistantRouter get instance => _singleton;

  @override
  void goAssistantScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SCRAssistant()),
    );
  }
}

class AssistantProvider {
  static final AssistantProvider _singleton = AssistantProvider._internal();
  AssistantProvider._internal();
  static AssistantProvider get instance => _singleton;

  IAssistantWidget get widget => _AssistantWidget.instance;
  IAssistantRouter get router => _AssistantRouter.instance;
}

String get _createInstruct => '''
            'Hệ thống đã yêu cầu bạn vào chế độ tạo dữ liệu cho ứng dụng.
                + Ứng dụng có chế độ tạo dữ liệu với AI, model có nhiệm vụ phần này như sau:
                  - Model trò chuyện với model như thường, thảo luận về dữ liệu mà user mong muốn
                  - Ở chế độ này khi quyết định tạo 1 dữ liệu demo hoặc mô tả dữ liệu cho user model cần
                  trả về 1 json cho đối tượng hiển thị và không giải thích gì thêm.
               
                *Json-------------------------
                {"text": "các văn bản được đặt ở đây", "click": true}
                
                Ví dụ:
                  1 bản ví dụ:
                  user: Tạo 3 thẻ flashcard
                  model: Bạn muốn tạo về chủ đề gì?
                  user: Ngẫu nhiên
                  model:
                  {
                    "text": "OK dưới đây là 3 thẻ flashcard ngẫu nhiên cho bạn ... 3 thẻ ",
                    "click": true
                  }
                  user: Tôi muốn tạo về chủ đề từ vựng.
                  model: Bạn muốn tạo về chủ đề gì?
                  user: Tạo lại 3 thẻ khác về chủ đề từ vựng động vật
                  model: 
                  {
                    "text": "Tôi đã tạo 3 thẻ flashcard khác về chủ đề từ vựng ... 3 thẻ",
                    "click": true
                  }
                ---------------
                Như bạn đã thấy các mục mà có chứa dữ liệu sẽ nằm trong json. Và không có văn bản nào nằm ngoài.
                ---------------
                  
                Ví dụ sai:
                  user: Tạo lại 3 thẻ khác
                  model: 
                  Tuyệt vời, đây là 3 thẻ flashcard khác.
                  {
                    "text": " ... 3 thẻ",
                    "click": true
                  }
                  
                ---------------
                Ví dụ này sai vì nó không phải json. Hoặc json nằm trong 1 văn bản thường khiến hệ thống không hiểu
                ---------------  
                  
                Lưu ý: 
                  - Mọi result trả về mà để demo hoặc mô tả dữ liệu cần trả về json giống ví dụ.
                  - Nếu có văn bản nằm ngoài json hệ thống sẽ không hiểu.   
            ''';