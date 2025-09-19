

// 如果是bool类型的，直接复用
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderBool extends Notifier<bool> {
  @override
  bool build() => false;

  void setValue(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

class ProviderBoolNull extends Notifier<bool?> {
  @override
  bool? build() => null;

  void setValue(bool? value) {
    state = value;
  }
}

class ProviderBoolTrue extends Notifier<bool> {
  @override
  bool build() => true;

  void setValue(bool value) {
    state = value;
  }
}

// 如果是string类型的，直接复用
class ProviderString extends Notifier<String> {
  @override
  String build() => "";

  void setValue(String value) {
    state = value;
  }
}

class ProviderStringBar extends Notifier<String> {
  @override
  String build() => "-";

  void setValue(String value) {
    state = value;
  }
}

class ProviderStringNull extends Notifier<String?> {
  @override
  String? build() => null;

  void setValue(String? value) {
    state = value;
  }
}

// 如果是int类型的，直接复用
class ProviderInt extends Notifier<int> {
  @override
  int build() => 0;

  void setValue(int value) {
    state = value;
  }
}

class ProviderIntMinusOne extends Notifier<int> {
  @override
  int build() => -1;

  void setValue(int value) {
    state = value;
  }
}

// 如果是double类型的，直接复用
class ProviderDouble extends Notifier<double> {
  @override
  double build() => 0.0;

  void setValue(double value) {
    state = value;
  }
}

class ProviderDoubleNull extends Notifier<double?> {
  @override
  double? build() => null;

  void setValue(double? value) {
    state = value;
  }
}

// 如果是List<int>类型的，直接复用
class ProviderListInt extends Notifier<List<int>> {
  @override
  List<int> build() => [];

  void setValue(List<int> value) {
    state = value;
  }
}