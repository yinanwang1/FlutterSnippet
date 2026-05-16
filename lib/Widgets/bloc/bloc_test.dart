import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snippet/Widgets/bloc/counter_bloc.dart';
import 'package:flutter_snippet/Widgets/bloc/counter_event.dart';
import 'package:flutter_snippet/Widgets/bloc/counter_state.dart';

class BlocTest extends StatelessWidget {
  const BlocTest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc Demo"),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(builder: (context, state) {
          return Text(
            '${state.count}',
            style: TextStyle(fontSize: 50),
          );
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(IncrementEvent());
            },
            heroTag: "add",
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterBloc>().add(DecrementEvent());
            },
            heroTag: "sub",
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
