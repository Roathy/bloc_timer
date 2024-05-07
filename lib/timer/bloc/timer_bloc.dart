import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_timer/timer/bloc/timer_event.dart';
import 'package:bloc_timer/timer/bloc/timer_state.dart';

import '../../ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onTimerStartedHandler);
    on<TimerPaused>(_onTimerPausedHandler);
    on<TimerResumed>(_onTimerResumedHandler);
    on<TimerReset>(_onTimerResetHandler);
    on<TimerTicked>(_onTimerTickedHandler);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  final Ticker _ticker;
  static const int _duration = 60;
  StreamSubscription<int>? _tickerSubscription;

  FutureOr<void> _onTimerStartedHandler(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: event.duration).listen((duration) => add(TimerTicked(duration: duration)));
  }

  FutureOr<void> _onTimerPausedHandler(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  FutureOr<void> _onTimerResumedHandler(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  FutureOr<void> _onTimerResetHandler(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  FutureOr<void> _onTimerTickedHandler(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0 ? TimerRunInProgress(event.duration) : TimerRunComplete(event.duration),
    );
  }
}
