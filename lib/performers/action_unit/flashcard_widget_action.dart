import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/performers/data_state/flashcard_manage.dart';

import '../../config/widget_config.dart';
import '../../data/models/flashcard/a_flashcardset.dart';
import '../../data/models/flashcard/b_flash_card.dart';

abstract class FlashCardManageAction extends ActionUnit<FlashcardManageState> {}

class FlashCardManageLoad extends FlashCardManageAction {
  static final List<FlashcardSet> _allSets = [
    FlashcardSet(
      id: 'ad-1',
      name: 'Từ vựng tiếng Anh - Unit 1',
      cards: [
        Flashcard(front: 'Apple', back: 'Quả táo'),
        Flashcard(front: 'Banana', back: 'Quả chuối'),
      ],
    ),
    FlashcardSet(
      id: 'ff-1',
      name: 'Từ vựng tiếng Anh - Unit 1',
      cards: [
        Flashcard(front: 'Apple', back: 'Quả táo'),
        Flashcard(front: 'Banana', back: 'Quả chuối'),
      ],
    ),
    FlashcardSet(
      id: 'cc-1',
      name: 'Từ vựng tiếng Anh - Unit 1',
      cards: [
        Flashcard(front: 'Apple', back: 'Quả táo'),
        Flashcard(front: 'Banana', back: 'Quả chuối'),
      ],
    ),
    FlashcardSet(
      id: 'uuid-2',
      name: 'Kiến thức Flutter cơ bản',
      cards: [
        Flashcard(front: 'Widget', back: 'Thành phần cơ bản của UI'),
        Flashcard(front: 'State', back: 'Dữ liệu có thể thay đổi'),
      ],
    ),
  ];

  @override
  Stream<FlashcardManageState> execute(FlashcardManageState current) async* {
    yield FlashcardManageLoadingState();
    await Future.delayed(const Duration(seconds: 2));
    yield FlashcardManageLoadedState(_allSets);
  }
}

class FlashCardManageAdd extends FlashCardManageAction {
  final FlashcardSet cardSet;

  FlashCardManageAdd(this.cardSet);

  @override
  Stream<FlashcardManageState> execute(FlashcardManageState current) async* {
    if(current is FlashcardManageLoadedState) {
      final newCards = List<FlashcardSet>.from(current.cards);
      newCards.add(cardSet);
      yield FlashcardManageLoadedState(newCards);
    }
  }
}

class FlashCardManageUpdate extends FlashCardManageAction {
  final FlashcardSet cardSet;

  FlashCardManageUpdate(this.cardSet);

  @override
  Stream<FlashcardManageState> execute(FlashcardManageState current) async* {
    if(current is FlashcardManageLoadedState) {
      final newCards = List<FlashcardSet>.from(current.cards);
      final index = newCards.indexWhere((element) => element.id == cardSet.id);
      newCards[index] = cardSet;

      if(cardSet.isSelect) {
        if (kIsWeb) {
          //- Không hỗ trợ
        } else if (Platform.isAndroid) {
          await WidgetConfig.platform.invokeMethod(
              WidgetConfig.updateMethodName,
              cardSet.toMap()
          );
        }
      }
      yield FlashcardManageLoadedState(newCards);
    }
  }
}

class FlashCardManageRemove extends FlashCardManageAction {
  final FlashcardSet cardSet;
  final Function(bool) onRemove;
  FlashCardManageRemove({required this.cardSet, required this.onRemove});

  @override
  Stream<FlashcardManageState> execute(FlashcardManageState current) async* {
    if(current is FlashcardManageLoadedState) {
      if (kIsWeb) {
        //- Không hỗ trợ
      } else if (Platform.isAndroid) {
        await WidgetConfig.platform.invokeMethod(
            WidgetConfig.removeMethodName,
            cardSet.toMap()
        );
      }

      current.cards.remove(cardSet);
      final updatedCards = List<FlashcardSet>.from(current.cards);
      yield FlashcardManageLoadedState(updatedCards);
      onRemove(true);
    }
    else {
      onRemove(false);
    }
  }
}

class FlashCardSetSelect extends FlashCardManageAction {
  final FlashcardSet cardSet;
  final Function(bool) onSelect;

  FlashCardSetSelect({required this.cardSet, required this.onSelect});

  @override
  Stream<FlashcardManageState> execute(FlashcardManageState current) async* {
    try {
      if(current is FlashcardManageLoadedState) {
        if(kIsWeb) {
          //- Không hỗ trợ
        } else if(Platform.isAndroid) {
          await WidgetConfig.platform.invokeMethod(
              WidgetConfig.updateMethodName,
              cardSet.toMap()
          );
        }

        final currentCards = List<FlashcardSet>.from(current.cards);
        final currentIndex = currentCards.indexWhere((element) => element.id == cardSet.id);
        final newCardSet = FlashcardSet(
            id: cardSet.id,
            name: cardSet.name,
            cards: cardSet.cards,
            isSelect: true
        );
        currentCards[currentIndex] = newCardSet;
        yield FlashcardManageLoadedState(currentCards);
        onSelect(true);
      }
      else {
        onSelect(false);
      }
    }
    on PlatformException catch (e) {
      onSelect(false);
      debugPrint("Failed to update widget: '${e.message}'.");
    }
  }
}