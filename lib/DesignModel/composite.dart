// 组合模式

// 公司  抽象类
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Company {
  final String name;

  Company(this.name);

  // 增加
  void add(Company company);

  // 移除
  void remove(Company company);

  // 显示
  void display(int depth);

  // 履行职责
  void lineOfDuty();
}

// 具体公司类

class ConcreteCompany extends Company {
  ConcreteCompany(super.name);

  final List<Company> _children = [];

  @override
  void add(Company company) {
    _children.add(company);
  }

  @override
  void display(int depth) {
    debugPrint("${"-" * depth} $name");

    for (var element in _children) {
      element.display(depth + 2);
    }
  }

  @override
  void lineOfDuty() {
    for (var company in _children) {
      company.lineOfDuty();
    }
  }

  @override
  void remove(Company company) {
    _children.remove(company);
  }
}

// 人力资源部与财务部类  树叶节点

class HRDepartment extends Company {
  HRDepartment(super.name);

  @override
  void add(Company company) {
    // DO nothing
  }

  @override
  void display(int depth) {
    debugPrint("${"-" * depth} $name");
  }

  @override
  void lineOfDuty() {
    debugPrint("$name 员工招聘培训管理");
  }

  @override
  void remove(Company company) {
    // DO nothing
  }
}

// 财务部

class FinanceDepartment extends Company {
  FinanceDepartment(super.name);

  @override
  void add(Company company) {
    // DO nothing
  }

  @override
  void display(int depth) {
    debugPrint("${"-" * depth} $name");
  }

  @override
  void lineOfDuty() {
    debugPrint("$name 公司财务收支管理");
  }

  @override
  void remove(Company company) {
    // DO nothing
  }
}

class Composite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text("组合模式"),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
              onPressed: _onClick,
              icon: const Icon(
                Icons.not_started,
                size: 40,
              )),
        ),
      ],
    );
  }

  void _onClick() {
    ConcreteCompany root = ConcreteCompany("北京总公司");
    root.add(HRDepartment("总公司人力资源部"));
    root.add(FinanceDepartment("总公司财务部"));

    ConcreteCompany comp = ConcreteCompany("上海华东分公司");
    comp.add(HRDepartment("华东分公司人力资源部"));
    comp.add(FinanceDepartment("华东分公司财务部"));

    root.add(comp);

    ConcreteCompany comp1 = ConcreteCompany("南京办事处");
    comp1.add(HRDepartment("南京办事处人力资源部"));
    comp1.add(FinanceDepartment("南京办事处财务部"));

    comp.add(comp1);

    ConcreteCompany comp2 = ConcreteCompany("杭州办事处");
    comp2.add(HRDepartment("杭州办事处人力资源部"));
    comp2.add(FinanceDepartment("杭州办事处财务部"));

    comp.add(comp2);

    debugPrint("\n结构图");
    root.display(1);

    debugPrint("\n职责：");
    root.lineOfDuty();
  }
}
