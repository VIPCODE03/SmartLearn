import 'package:flutter/material.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'package:smart_learn/core/router/app_router.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import '../../../../../global.dart';

class HomeAI extends StatelessWidget {
  const HomeAI({super.key});

  @override
  Widget build(BuildContext context) {
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
          /// TIÊU ĐỀ ----------------------------------------------------------
          const Text(
            'Hỏi AI',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),

          /// Ô HỎI ---------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(25),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      appRouter.aiHomework.goAIText(context);
                    },
                    child: const Text(
                    'Tìm kiếm câu trả lời',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                )),

                WdgBounceButton(
                  onTap: () {
                    appRouter.aiHomework.goAICamera(context);
                  },
                  child: Icon(Icons.camera_alt_outlined, color: iconColor(context)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Lịch sử gần đây --------------------------------------------------
          appWidget.aiHomework.history((histories, openDetail) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (histories.isNotEmpty)
                  const Text(
                    'Lịch sử gần đây',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),

                if (histories.isNotEmpty)
                  ...histories.take(2).map((history) => _itemHistory(
                      context,
                      history['title']!,
                      history['id']!,
                      openDetail
                  )),

                if (histories.isNotEmpty)
                  Align(
                  alignment: Alignment.centerRight,
                  child: WdgBounceButton(
                    onTap: () {
                      _showFullHistoryDialog(context, histories, openDetail);
                    },
                    child: const Text('Xem thêm', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  ///-  DIALOG TẤT CẢ LỊCH SỬ -------------------------------------------------------
  void _showFullHistoryDialog(
      BuildContext context,
      List<Map<String, String>> allHistories,
      Function(String id) openDetail
      ) {
    showDialog(
      context: context,
      builder: (_) {
        String searchText = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = allHistories.where((item) {
              final title = item['title']?.toLowerCase() ?? '';
              return title.contains(searchText.toLowerCase());
            }).toList();

            return WdgScaleDialog(
              border: true,
              shadow: true,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 500),
                color: Theme.of(context).cardColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tất cả lịch sử',
                      style: TextStyle(
                        color: primaryColor(context),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Ô TÌM KIẾM  -------------------------------------------------------
                    TextField(
                      decoration: inputDecoration(
                          context: context,
                          hintText: 'Tìm kiếm'
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    ///-  DANH SÁCH LỊCH SỬ ---------------------------------------------
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final title = filtered[index]['title']!;
                          final id = filtered[index]['id']!;
                          return _itemHistory(context, title, id, openDetail);
                        },
                        separatorBuilder: (_, __) => const Divider(height: 10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ///-  ITEM LỊCH SỬ  ----------------------------------------------------------------
  Widget _itemHistory(BuildContext context, String title, String id, Function(String id) openDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: WdgBounceButton(
        onTap: () {
          openDetail(id);
        },
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_outward_rounded, color: primaryColor(context), size: 18),
          ],
        ),
      ),
    );
  }
}
