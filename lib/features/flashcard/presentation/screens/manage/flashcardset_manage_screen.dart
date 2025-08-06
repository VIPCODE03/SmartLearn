import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/presentation/screens/manage/flashcard_manage_screen.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcardset_performer/action.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcardset_performer/performer.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcardset_performer/state.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/ui/widgets/textfeild_widget.dart';

class SCRFlashCardSetManage extends StatelessWidget {
  const SCRFlashCardSetManage({super.key});

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<FlashcardSetPerformer>.create(
      create: (_) => FlashcardSetPerformer()
        ..add(FlashCardSetLoadAll(FlashCardSetGetAllParams(FlashCardSetForeignParams()))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Set Manage'),
        ),
        body: PerformerBuilder<FlashcardSetPerformer>(
          builder: (context, performer) {
            final state = performer.current;

            if (state is FlashCardSetLoading) {
              return const Center(child: WdgLoading());

            } else if (state is FlashCardSetHasData) {
              return Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: state.cardSets
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
                final performer = PerformerProvider.of<FlashcardSetPerformer>(context);
                _showEditCardSheet(
                  context: context,
                  onDataChanged: (name) {
                    performer.add(FlashCardSetAdd(FlashCardSetAddParams(
                        FlashCardSetForeignParams(),
                        name: name))
                    );
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
  final ENTFlashcardSet cardSet;
  final FlashcardSetPerformer performer;
  const _ItemCardSet({required this.cardSet, required this.performer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        performer.add(FlashCardSetDelete(
            FlashCardSetDeleteParams(cardSet.id))
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SCRFlashCardManage(
            cardSetId: cardSet.id,
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
                    WdgBounceButton(
                        child: Icon(
                          cardSet.isSelect
                            ? Icons.favorite
                            : Icons.favorite_border,
                        ),
                        onTap: () {
                          if(!cardSet.isSelect) {
                            performer.add(FlashCardSetUpdate(
                              FlashCardSetUpdateParams(
                                cardSet,
                                isSelect: true,
                              )
                            ));
                          }
                        }
                    ),

                    WdgBounceButton(
                        onTap: () {
                          _showEditCardSheet(context: context, cardSet: cardSet, onDataChanged: (newName) {
                            performer.add(FlashCardSetUpdate(FlashCardSetUpdateParams(
                              cardSet,
                              name: newName,
                            )));
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

void _showEditCardSheet({
  required BuildContext context,
  ENTFlashcardSet? cardSet,
  required Function(String) onDataChanged,
}) {
  final nameController = TextEditingController()..text = cardSet?.name ?? "";
  final formKey = GlobalKey<FormState>();

  showAppConfirmBottomSheet(
    context: context,
    title: 'FlashCardSet',
    onComfirm: () {
      if (formKey.currentState?.validate() ?? false) {
        onDataChanged(nameController.text);
        Navigator.pop(context);
      }
    },
    child: Form(
      key: formKey,
      child: WdgTextFeildCustom(
        hintText: 'Nhập tên',
        controller: nameController,
        validator: (value) => (value == null || value.trim().isEmpty)
            ? 'Please enter a name.'
            : null,
      ),
    ),
  );
}
