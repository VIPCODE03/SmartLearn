import 'package:bloc/bloc.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_get_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_multi_reset_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_update_usecase.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/event.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final List<ENTFlashCard> _cardsOrigin = [];
  List<ENTFlashCard> _cards = [];
  int _current = 0;
  int get _total => _cards.length;
  int get _currentIndex => _current + 1;
  int get _totalDontRemember => _cards.where((c) => c.rememberLevel == ENTFlashCard.dontRemember).length;
  int get _totalRemember => _cards.where((c) => c.rememberLevel == ENTFlashCard.remember).length;

  final UCEFlashCardGet _get;
  final UCEFlashCardUpdate _update;
  final UCEFlashCardMultiReset _multiReset;
  FlashCardBloc(this._get, this._update, this._multiReset) : super(FlashCardLoading()) {
    on<FlashCardLoadBySetId>(_onLoad);
    on<FlashCardUpdateStatus>(_onUpdate);
    on<FlashCardBack>(_onBack);
    on<ReviewDontRememberEvent>(_onReviewDontRememberer);
    on<ResetAll>(_onResetAll);
  }

  void _onLoad(FlashCardLoadBySetId event, Emitter<FlashCardState> emit) async {
    emit(FlashCardLoading());
    final result = await _get(FlashCardGetAllParams(event.flashCardSetId));
    result.fold(
          (fail) => emit(FlashCardError()),
          (cards) {
            if(cards.isNotEmpty) {
              _cardsOrigin.clear();
              _cardsOrigin.addAll(cards);
              _cardsOrigin.shuffle();
              _cardsOrigin.sort(
                      (a, b) {
                    if (a.isUnknown == b.isUnknown) return 0;
                    return a.isUnknown ? 1 : -1;
                  }
              );
              _cards = _cardsOrigin;
              _current = _cards.indexWhere((card) => card.isUnknown);
              if (_current == -1) {
                emit(FlashCardCompleted(
                    currentIndex: _currentIndex,
                    total: _total,
                    totalDontRemember: _totalDontRemember,
                    totalRemember: _totalRemember
                ));
              }
              else {
                emit(FlashCardCurrent(
                    card: _cards[_current],
                    total: _cards.length,
                    totalDontRemember: _totalDontRemember,
                    totalRemember: _totalRemember,
                    currentIndex: _currentIndex
                ));
              }
            }
            else {
              emit(FlashCardError());
            }
          }
    );
  }

  void _onBack(FlashCardBack event, Emitter<FlashCardState> emit) async {
    if (_current > 0) {
      _current--;
      emit(FlashCardCurrent(
          card: _cards[_current],
          totalDontRemember: _totalDontRemember,
          totalRemember: _totalRemember,
          currentIndex: _currentIndex,
          total: _total
      ));
    }
  }

  void _onUpdate(FlashCardUpdateStatus event, Emitter<FlashCardState> emit) async {
    final result = await _update(FlashCardUpdateParams(event.card, rememberLevel: event.rememberLevel));
    result.fold(
            (fail) => emit(FlashCardError()),
            (cardUpdate) {
              final indexCard = _cards.indexWhere((c) => c.id == cardUpdate.id);
              final indexCardOrigin = _cardsOrigin.indexWhere((c) => c.id == cardUpdate.id);
              _cards[indexCard] = cardUpdate;
              _cardsOrigin[indexCardOrigin] = cardUpdate;
              if(_current < _total - 1) {
                _current++;
                emit(FlashCardCurrent(
                    card: _cards[_current],
                    totalDontRemember: _totalDontRemember,
                    totalRemember: _totalRemember,
                    currentIndex: _currentIndex,
                    total: _total
                ));
              }
              else {
                emit(FlashCardCompleted(
                    currentIndex: _currentIndex,
                    total: _total,
                    totalDontRemember: _totalDontRemember,
                    totalRemember: _totalRemember
                ));
              }
            }
    );
  }

  void _onReviewDontRememberer(ReviewDontRememberEvent event, Emitter<FlashCardState> emit) async {
    emit(FlashCardLoading());
    _cards = [];
    _current = 0;
    for(var card in _cardsOrigin) {
      if(card.rememberLevel == ENTFlashCard.dontRemember) {
        _cards.add(card);
      }
    }
    emit(FlashCardCurrent(
        card: _cards[_current],
        totalDontRemember: _totalDontRemember,
        totalRemember: _totalRemember,
        currentIndex: _currentIndex,
        total: _total
    ));
  }

  void _onResetAll(ResetAll event, Emitter<FlashCardState> emit) async {
    emit(FlashCardLoading());
    final result = await _multiReset(FlashCardMultiResetParams(_cardsOrigin));
    result.fold(
            (fail) => emit(FlashCardError()),
            (cards) {
              _cardsOrigin.clear();
              _cardsOrigin.addAll(cards);
              _cards = _cardsOrigin;
              _current = 0;
              emit(FlashCardCurrent(
                  card: _cards[_current],
                  totalDontRemember: _totalDontRemember,
                  totalRemember: _totalRemember,
                  currentIndex: _currentIndex,
                  total: _total
              ));
        });
  }
}