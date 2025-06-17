import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String firstNumber = "0";
  String number = "0";
  String? operationValue;

  List<String> strings = [];
  List<String> operations = ["+", "-", "*", "/"];
  String equalOperation = "=";
  String clearOption = "AC";

  @override
  void initState() {
    strings.addAll(["7", "8", "9"]);
    strings.add(operations[0]);
    strings.addAll(["4", "5", "6"]);
    strings.add(operations[1]);
    strings.addAll(["1", "2", "3"]);
    strings.add(operations[2]);
    strings.addAll(["0", "."]);
    strings.add(equalOperation);
    strings.add(operations[3]);
    strings.add("AC");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 44,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: MyColors.title, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Text(number,
                style: const TextStyle(fontSize: 20, color: MyColors.title)),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Expanded(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3),
            itemBuilder: (_, index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: TextButton(
                  onPressed: () {
                    _operate(strings[index]);
                  },
                  child: Text(
                    strings[index],
                    style: const TextStyle(color: MyColors.title, fontSize: 16),
                  ),
                ),
              );
            },
            itemCount: strings.length,
          ))
        ],
      ),
    );
  }

  void _operate(String value) {
    if (operations.contains(value)) {
      firstNumber = number;
      number = "0";
      operationValue = value;
    } else if (value == "=") {
      var currentOperation = operationValue;
      if (null == currentOperation) {
        return;
      }
      var operation = OperationFactory.createOperate(currentOperation);
      operation.numberA = double.tryParse(firstNumber) ?? 0.0;
      operation.numberB = double.tryParse(number) ?? 0.0;
      var result = operation.getResult();
      if (result == result.toInt()) {
        number = result.toInt().toString();
      } else {
        number = result.toString();
      }

      firstNumber = "0";
      operationValue = null;
    } else if (value == clearOption) {
      number = "0";
      firstNumber = "0";
      operationValue = null;
    } else {
      number += value;
      if (number.startsWith("0") && !number.startsWith("0.")) {
        number = number.substring(1);
      }
    }

    setState(() {});
  }
}

// 简单工厂方法

class OperationFactory {
  static Operation createOperate(String operate) {
    switch (operate) {
      case "+":
        return OperationAdd();
      case "-":
        return OperationSub();
      case "*":
        return OperationMul();
      case "/":
        return OperationDiv();
    }

    return OperationAdd();
  }
}

abstract class Operation {
  late double numberA;
  late double numberB;

  double getResult();
}

class OperationAdd extends Operation {
  @override
  double getResult() {
    return numberA + numberB;
  }
}

class OperationSub extends Operation {
  @override
  double getResult() {
    return numberA - numberB;
  }
}

class OperationMul extends Operation {
  @override
  double getResult() {
    return numberA * numberB;
  }
}

class OperationDiv extends Operation {
  @override
  double getResult() {
    if (numberB == 0) {
      return 0;
    }

    return numberA / numberB;
  }
}
