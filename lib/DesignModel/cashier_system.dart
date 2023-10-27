import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snippet/Common/my_colors.dart';

// 策略模式

class CashierSystem extends StatefulWidget {
  const CashierSystem({super.key});

  @override
  State createState() {
    return _CashierSystemState();
  }
}

class _CashierSystemState extends State<CashierSystem> {
  final TextEditingController _priceTextEditingController = TextEditingController(text: "0");
  final TextEditingController _amountTextEditingController = TextEditingController(text: "1");
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  CashSuper? _cashSuper;
  String? _operationType;
  String orderDetail = "";
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background,
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(flex: 5, child: _inputViews()),
              Expanded(flex: 2, child: _buttonViews()),
            ],
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: MyColors.mainTranslucentColor, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: SingleChildScrollView(
              child: Text(orderDetail),
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                const Text(
                  "总计：",
                  style: TextStyle(color: MyColors.title, fontSize: 16),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    "$total",
                    style: const TextStyle(fontSize: 50, color: MyColors.title),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _inputViews() {
    var style = const TextStyle(fontSize: 16, color: MyColors.title);
    var titleWidth = 100.0;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: titleWidth,
              child: Text(
                "单价：",
                style: style,
              ),
            ),
            Expanded(
                child: CupertinoTextField(
              controller: _priceTextEditingController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              focusNode: _priceFocusNode,
            ))
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Row(
          children: [
            SizedBox(
              width: titleWidth,
              child: Text(
                "数量：",
                style: style,
              ),
            ),
            Expanded(
                child: CupertinoTextField(
              controller: _amountTextEditingController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              focusNode: _amountFocusNode,
            ))
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Row(
          children: [
            SizedBox(
              width: titleWidth,
              child: Text(
                "计算方法：",
                style: style,
              ),
            ),
            DropdownButton(
                value: _operationType,
                items: CashFactory.chargeTypes
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: style),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _operationType = value;
                    _cashSuper = CashFactory.createCashAccept(value);
                  });
                })
          ],
        )
      ],
    );
  }

  Widget _buttonViews() {
    return Column(
      children: [
        OutlinedButton(onPressed: null == _cashSuper ? null : _onClickConfirm, child: const Text("确定")),
        OutlinedButton(
            onPressed: () {
              setState(() {
                total = 0.0;
                orderDetail = "";
                _priceTextEditingController.value = const TextEditingValue(text: "0");
                _amountTextEditingController.value = const TextEditingValue(text: "1");
              });
            },
            child: const Text("重置")),
      ],
    );
  }

  void _hideKeyboard() {
    _priceFocusNode.unfocus();
    _amountFocusNode.unfocus();
  }

  void _onClickConfirm() {
    _hideKeyboard();
    if (null == _cashSuper) {
      return;
    }

    double price = double.tryParse(_priceTextEditingController.value.text) ?? 0.0;
    int amount = int.tryParse(_amountTextEditingController.value.text) ?? 0;
    var total = _cashSuper?.acceptCash(price * amount) ?? 0.0;
    this.total += total;
    String content = "单价：$price 数量: $amount $_operationType 合计：$total";

    if (orderDetail.isNotEmpty) {
      orderDetail = "$orderDetail\n$content";
    } else {
      orderDetail = content;
    }

    setState(() {});
  }
}

// 收银系统

abstract class CashSuper {
  double acceptCash(double money);
}

class CashRebate extends CashSuper {
  final double _moneyRebate;

  CashRebate(String moneyRebate) : _moneyRebate = double.tryParse(moneyRebate) ?? 1.0;

  @override
  double acceptCash(double money) {
    return money * _moneyRebate;
  }
}

class CashNormal extends CashSuper {
  @override
  double acceptCash(double money) {
    return money;
  }
}

class CashReturn extends CashSuper {
  final double moneyCondition;
  final double moneyReturn;

  CashReturn(String moneyCondition, String moneyReturn)
      : moneyCondition = double.tryParse(moneyCondition) ?? 0.0,
        moneyReturn = double.tryParse(moneyReturn) ?? 0.0;

  @override
  double acceptCash(double money) {
    double result = money;
    if (moneyCondition > 0 && money > moneyCondition) {
      result = money - (money / moneyCondition).floor() * moneyReturn;
    }

    return result;
  }
}

class CashFactory {
  static const String _normal = "正常收费";
  static const String _return300To100 = "满300返100";
  static const String _rebate8 = "打8折";
  static List<String> chargeTypes = [_normal, _return300To100, _rebate8];

  static CashSuper? createCashAccept(String? type) {
    switch (type) {
      case _normal:
        return CashNormal();
      case _return300To100:
        return CashReturn("300", "100");
      case _rebate8:
        return CashRebate("0.8");
    }

    return null;
  }
}
