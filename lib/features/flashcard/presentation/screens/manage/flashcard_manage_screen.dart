import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/app/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_manage_bloc/bloc.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_manage_bloc/events.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_manage_bloc/state.dart';

import '../../../domain/parameters/flashcard_params.dart';

class SCRFlashCardManage extends StatefulWidget {
  final String cardSetId;
  const SCRFlashCardManage({super.key, required this.cardSetId});

  @override
  State<SCRFlashCardManage> createState() => _SCRFlashCardManageState();
}

class _SCRFlashCardManageState extends State<SCRFlashCardManage> {
  final FlashCardManageBloc _flashCardBloc = FlashCardManageBloc();

  @override
  void initState() {
    super.initState();
    _flashCardBloc.add(GetAllFlashCardEvent(FlashCardGetAllParams(widget.cardSetId)));
  }

  @override
  void dispose() {
    _flashCardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Flashcard'),
      ),

      body: BlocProvider<FlashCardManageBloc>.value(
        value: _flashCardBloc,
        child: BlocBuilder<FlashCardManageBloc, FlashCardState>(builder: (context, state) {
          if(state is FlashCardNoDataState) {
            if (state is FlashCardLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FlashCardErrorState) {
              return const Center(child: Text('Error'));
            }
          }
          else if(state is FlashCardHasDataState) {
            final cards = state.cards;
            final isCreating = state is FlashCardCreatingState;

            return Stack(
              children: [
                IgnorePointer(
                  ignoring: isCreating,
                  child: Opacity(
                    opacity: isCreating ? 0.5 : 1.0,
                    child: cards.isNotEmpty
                        ? ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return GestureDetector(
                          onTap: () {
                            _showEditCardSheet(flashCard: card);
                          },
                          child: _ItemCard(
                            card,
                            index: index,
                            onChange: (value) {
                              if (value == null) {
                                _flashCardBloc.add(DeleteFlashCardEvent(FlashCardDeleteParams(card.id)));
                              }
                            },
                          ),
                        );
                      },
                    )
                        : const Center(child: Text('No data')),
                  ),
                ),

                if (isCreating)
                  const Center(child: WdgLoading()),
              ],
            );
          }

          return const SizedBox();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditCardSheet,
        tooltip: 'Add new card',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditCardSheet({ENTFlashCard? flashCard}) {
    final frontController = TextEditingController()..text = flashCard?.front ?? "";
    final backController = TextEditingController()..text = flashCard?.back ?? "";
    final formKey = GlobalKey<FormState>();
    final isAdd = flashCard == null;

    showAppConfirmBottomSheet(
        context: context,
        title: 'FlashCard',
        onConfirm: () {
          if (formKey.currentState!.validate()) {
            if(isAdd) {
              _flashCardBloc.add(AddFlashCardEvent(
                  FlashCardAddParams(
                    front: frontController.text,
                    back: backController.text,
                    cardSetId: widget.cardSetId,
                  )
              ));
            }
            else {
              _flashCardBloc.add(UpdateFlashCardEvent(
                  FlashCardUpdateParams(
                    flashCard,
                    front: frontController.text,
                    back: backController.text,
                  ))
              );
            }
            Navigator.pop(context);
          }
        },
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isAdd)
              _buildOptionCard(
                  icon: Icons.smart_toy,
                  color: context.style.color.primaryColor.withValues(alpha: 0.5),
                  title: 'Tạo bằng AI',
                  subtitle: 'Tạo các thẻ flashcard bằng AI',
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: appWidget.assistant.assistantCreate(
                                prompt: _flashCardBloc.promptAI,
                                instruct: _flashCardBloc.instructAI,
                                onCreated: (json) {
                                  _flashCardBloc.add(AIFlashcardEvent(FlashCardGetWithAIParams(cardSetId: widget.cardSetId,instruct: 'Tạo các dữ liệu với $json')));
                                }),
                          );
                        });
                  }
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
            ],
          ),
        ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return WdgBounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700])
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ENTFlashCard flashcard;
  final int index;
  final Function(ENTFlashCard?) onChange;

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

          WdgDivider(height: 6, color: context.style.color.primaryColor.withAlpha(30)),

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
