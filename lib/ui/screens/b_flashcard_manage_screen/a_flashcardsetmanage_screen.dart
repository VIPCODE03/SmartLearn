import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/action_unit/flashcard_widget_action.dart';
import 'package:smart_learn/performers/data_state/flashcard_manage.dart';
import 'package:smart_learn/performers/performer/flashcard_manage_performer.dart';
import 'package:smart_learn/ui/screens/b_flashcard_manage_screen/b_flashcard_manage_screen.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';

import '../../../data/models/flashcard/a_flashcardset.dart';
import '../../widgets/textfeild_widget.dart';

class FlashCardSetManageScreen extends StatelessWidget {
  const FlashCardSetManageScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return PerformerProvider<FlashcardPerformer>.create(
      create: (_) => FlashcardPerformer()..add(FlashCardManageLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Set Manage'),
        ),
        body: PerformerBuilder<FlashcardPerformer>(
          builder: (context, performer) {
            final state = performer.current;

            if (state is FlashcardManageLoadingState) {
              return const Center(child: WdgLoading());

            } else if (state is FlashcardManageLoadedState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: state.cards
                      .map((cardSet) => _ItemCardSet(cardSet: cardSet, performer: performer))
                      .toList(),
                ),
              );
            }

            return const Center(child: Text('No Data'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final performer = PerformerProvider.of<FlashcardPerformer>(context);
                _showEditCardSheet(
                  context: context,
                  onDataChanged: (cardSet) {
                    performer.add(FlashCardManageAdd(cardSet));
                  },
                );
              },
              tooltip: 'Add new card',
              child: const Icon(Icons.add),
            );
          },
        ),

      ),
    );
  }
}

class _ItemCardSet extends StatelessWidget {
  final FlashcardSet cardSet;
  final FlashcardPerformer performer;
  const _ItemCardSet({required this.cardSet, required this.performer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlashCardManageScreen(
              cards: cardSet.cards,
              onDataChanged: (newCards) {
                performer.add(FlashCardManageUpdate(
                    FlashcardSet(
                        id: cardSet.id,
                        name: cardSet.name,
                        isSelect: cardSet.isSelect,
                        cards: newCards
                )));
              }
          )),
        );
      },
      child: Container(
          height: 200,
          width: 180,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.grey,
                  width: 1.5
              ),
            boxShadow: [
              BoxShadow(
                color: primaryColor(context).withAlpha(10),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ]
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Hero(
                      tag: cardSet.id,
                      child: Text(
                          cardSet.name,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng: ${cardSet.cards.length}',
                        style: const TextStyle(color: Colors.grey)
                    ),

                    WdgBounceButton(
                        child: Icon(
                          cardSet.isSelect
                            ? Icons.favorite
                            : Icons.favorite_border,
                        ),
                        onTap: () {
                          if(!cardSet.isSelect) {
                            performer.add(FlashCardSetSelect(
                                cardSet: cardSet,
                                onSelect: (selected) {
                                  if(!context.mounted) return;
                                  if(selected) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Select card set successfully!'),
                                        backgroundColor: Colors.green,
                                      ));
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Select card set failed!'),
                                            backgroundColor: Colors.red
                                        ));
                                  }
                                }
                            ));
                          }
                        }
                    ),

                    WdgBounceButton(
                        onTap: () {
                          _showEditCardSheet(context: context, cardSet: cardSet, onDataChanged: (newCardSet) {
                            performer.add(FlashCardManageUpdate(newCardSet));
                          });
                        },
                        child: const Icon(Icons.edit)
                    )
                  ],
                )
              ]
          )
      )
    );
  }
}

void _showEditCardSheet({required BuildContext context, FlashcardSet? cardSet, required Function(FlashcardSet) onDataChanged}) {
  final nameController = TextEditingController()..text = cardSet?.name ?? "";
  final formKey = GlobalKey<FormState>();

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
                    child: Text('FlashCardSet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  WdgBounceButton(
                      child: Icon(
                          cardSet != null
                              ? Icons.save_outlined
                              : Icons.add_circle_outline,
                          size: 30
                      ),
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          onDataChanged(FlashcardSet(
                            id: cardSet?.id ?? '',
                            name: nameController.text,
                            cards: cardSet?.cards ?? [],
                            isSelect: cardSet?.isSelect ?? false,
                          ));
                          Navigator.pop(context);
                        }
                      }
                  ),

                ],
              ),

              const SizedBox(height: 16),
              WdgTextFeildCustom(
                hintText: 'Nhập tên',
                controller: nameController,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name.' : null,
              ),

              const SizedBox(height: 50)
            ],
          ),
        ),
      );
    },
  );
}
