import 'package:flutter/material.dart';
import 'package:smart_learn/ui/screens/ai_question_screen/a_ai_screen.dart';

import '../../../../../global.dart';
import '../../../../widgets/bouncebutton_widget.dart';

class HomeAI extends StatelessWidget {
  const HomeAI({super.key});

  @override
  Widget build(BuildContext context) {
    final allHistories = [
      'Hai cộng hai bằng mấy?',
      'Định nghĩa của trọng lực?',
      'Làm sao để học từ vựng hiệu quả?',
      'Khí CO2 có độc không?',
    ];

    // Hiển thị tối đa 2 dòng đầu
    final latestHistories = allHistories.take(2).toList();
    final hasMore = allHistories.length > 2;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor(context).withAlpha(50),
            blurRadius: 2,
            offset: const Offset(0, 1)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Tiêu đề
          const Text(
            'Hỏi AI',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),

          /// Ô hỏi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(25),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AIScreen.text()));
                    },
                    child: const Text(
                    'Tìm kiếm câu trả lời',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                )),

                WdgBounceButton(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AIScreen.camera()));
                  },
                  child: Icon(Icons.camera_alt_outlined, color: primaryColor(context).withAlpha(150)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Lịch sử gần đây
          if (latestHistories.isNotEmpty)
            const Text(
              'Lịch sử gần đây',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),

          ...latestHistories.map((text) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: GestureDetector(
              onTap: () {
                // Gửi lại câu hỏi này
              },
              child: Row(
                children: [
                  const Icon(Icons.history, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_outward_rounded, color: primaryColor(context), size: 18),
                ],
              ),
            ),
          ),
          ),

          /// Nút xem thêm
          if (hasMore)
            Align(
              alignment: Alignment.centerRight,
              child: WdgBounceButton(
                onTap: () {
                  _showFullHistoryDialog(context, allHistories);
                },
                child: const Text('Xem thêm', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullHistoryDialog(BuildContext context, List<String> allHistories) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tất cả lịch sử'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: allHistories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(allHistories[index]),
                onTap: () {
                  Navigator.pop(context);
                  // Gửi lại câu hỏi từ lịch sử
                },
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
