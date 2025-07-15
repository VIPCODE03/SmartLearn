import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/flashcard/b_flash_card.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';
import 'package:smart_learn/ui/widgets/textfeild_widget.dart';

class FlashCardManageScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final Function(List<Flashcard>) onDataChanged;

  const FlashCardManageScreen({super.key, required this.cards, required this.onDataChanged});

  @override
  State<FlashCardManageScreen> createState() => _FlashCardManageScreenState();
}

class _FlashCardManageScreenState extends State<FlashCardManageScreen> {
  final List<Flashcard> _cards = [];

  @override
  void initState() {
    super.initState();
    _cards.addAll(widget.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Flashcard'),
      ),

      body: _cards.isNotEmpty ? ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return GestureDetector(
            onTap: () {
              _showEditCardSheet(flashCard: card);
            },
            child: _ItemCard(card, index: index, onChange: (card) {
              if(card == null) {
                setState(() {
                  _cards.removeAt(index);
                  widget.onDataChanged(_cards);
                });
              }
            })
          );
        },
      )
          : const Center(child: Text('No data')),

      floatingActionButton: FloatingActionButton(
        onPressed: _showEditCardSheet,
        tooltip: 'Add new card',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditCardSheet({Flashcard? flashCard}) {
    final frontController = TextEditingController()..text = flashCard?.front ?? "";
    final backController = TextEditingController()..text = flashCard?.back ?? "";
    final formKey = GlobalKey<FormState>();
    final isAdd = flashCard == null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(
              color: primaryColor(context)
            )
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                        child: Text('Flashcard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                    WdgBounceButton(
                        child: Icon(isAdd ? Icons.add_circle_outline : Icons.save_outlined, size: 30),
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if(isAdd) {
                                _cards.add(Flashcard(
                                  front: frontController.text,
                                  back: backController.text,
                                ));
                              }
                              else {
                                final indexOfFlashCard = _cards.indexOf(flashCard);
                                _cards[indexOfFlashCard] = Flashcard(
                                  front: frontController.text,
                                  back: backController.text,
                                );
                              }
                              widget.onDataChanged(_cards);
                            });
                            Navigator.pop(context);
                          }
                        }
                    ),

                  ],
                ),

                const SizedBox(height: 16),
                WdgTextFeildCustom(
                  hintText: 'Mặt trước',
                  controller: frontController,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a front.' : null,
                ),

                const SizedBox(height: 16),
                WdgTextFeildCustom(
                  hintText: 'Mặt sau',
                  controller: backController,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a back.' : null,
                ),

                const SizedBox(height: 50)
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Flashcard flashcard;
  final int index;
  final Function(Flashcard?) onChange;

  const _ItemCard(this.flashcard, {required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),

              WdgBounceButton(
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                  onTap: () {
                    _showConfirm(context, (delete) {
                      if(delete) {
                        onChange(null);
                      }
                    });
                  }
              )
            ],
          ),

          Text(flashcard.front, style: const TextStyle(fontWeight: FontWeight.w300)),

          const SizedBox(height: 6),

          WdgDivider(height: 6, color: primaryColor(context).withAlpha(30)),

          const SizedBox(height: 6),

          Text(flashcard.back, style: const TextStyle(fontWeight: FontWeight.w300)),
        ],
      )
    );
  }

  void _showConfirm(BuildContext context, Function(bool) onAction) {
    showDialog(
      context: context,
      builder: (ctx) => WdgScaleDialog(
        border: true,
        shadow: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Xác nhận xóa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Bạn có chắc chắn muốn xóa thẻ không?', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                TextButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    onAction(true);
                    Navigator.of(ctx).pop();
                  },
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
