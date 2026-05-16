import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snippet/Widgets/bloc/counter_event.dart';
import 'package:flutter_snippet/Widgets/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<IncrementEvent>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<DecrementEvent>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}
