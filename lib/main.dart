import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CounterState {
  final int counter;
  const CounterState({
    required this.counter,
  });

  factory CounterState.initial() {
    return const CounterState(counter: 0);
  }

  @override
  String toString() {
    return 'CounterState(counter: $counter)';
  }

  CounterState copyWith({
    int? counter,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }
}

class IncrementAction {
  final int payload;
  IncrementAction({
    required this.payload,
  });

  @override
  String toString() => 'IncrementAction(payload: $payload)';
}

class DecrementAction {
  final int payload;
  DecrementAction({
    required this.payload,
  });

  @override
  String toString() => 'DecrementAction(payload: $payload)';
}

CounterState counterReducer(CounterState state, dynamic action) {
  if (action is IncrementAction) {
    return state.copyWith(counter: state.counter + action.payload);
  } else if (action is DecrementAction) {
    return state.copyWith(counter: state.counter - action.payload);
  }
  return state;
}

late final Store<CounterState> store;

void main() {
  store = Store<CounterState>(
    counterReducer,
    initialState: CounterState.initial(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CounterState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CounterState, ViewModel>(
      converter: (Store<CounterState> store) => ViewModel.fromStore(store),
      builder: (BuildContext context, ViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Counter'),
          ),
          body: Center(
            child: Text(
              '${vm.counter}',
              style: const TextStyle(fontSize: 64),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'increment',
                onPressed: () {
                  vm.incrementCounter(1);
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10.0),
              FloatingActionButton(
                heroTag: 'decrement',
                onPressed: () {
                  vm.decrementCounter(1);
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ViewModel {
  final int counter;
  final void Function(int payload) incrementCounter;
  final void Function(int payload) decrementCounter;
  ViewModel({
    required this.counter,
    required this.incrementCounter,
    required this.decrementCounter,
  });

  static fromStore(Store<CounterState> store) {
    return ViewModel(
      counter: store.state.counter,
      incrementCounter: (int payload) => store.dispatch(
        IncrementAction(payload: payload),
      ),
      decrementCounter: (int payload) => store.dispatch(
        DecrementAction(payload: payload),
      ),
    );
  }
}
