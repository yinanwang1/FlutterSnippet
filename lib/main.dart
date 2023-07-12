import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/Common/MaterialAppUtil.dart';
import 'package:flutter_snippet/Widgets/gradient_border.dart';

void main() {
  runApp(ProviderScope(child: createMaterialApp((settings) => MaterialPageRoute(builder: (_) => const MyApp()), {})));
  // runApp(const ProviderScope(child: MyHomePage()));
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的新世界"),
      ),
      body: const Center(
        child: GradientBorder(
          child: Text("渐变色边框", style: TextStyle(color: Colors.black, fontSize: 16),),
        ),
      ),
    );
  }
}

const Map<String, List<String>> CITY_NAMES = {
  '北京':['东城区','西城区','海淀区','朝阳区','石景山区','顺义区'],
  '上海':['黄浦区','徐汇区','长宁区','静安区','普陀区','闸北区'],
  '广州':['越秀','海珠','荔湾','天河','白云','黄埔','南沙'],
  '深圳':['南山','福田','罗湖','盐田','龙岗','宝安','龙华'],
  '杭州':['上城区','下城区','江干区','拱墅区','西湖区','滨江区'],
  '苏州':['姑苏区','吴中区','相城区','高新区','虎丘区','工业园区','吴江区'],
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("列表展开与收起"),
        ),
        body: ListView(
          children: _buildList(),
        ),
      ),

    );
  }
  List<Widget> _buildList(){
    List<Widget> widgets = [];
    for (var key in CITY_NAMES.keys) {
      widgets.add(_item(key, CITY_NAMES[key] ?? []));
    }
    return widgets;
  }
  Widget _item(String city,List<String> subCities){
    return ExpansionTile(
      title: Text(
        city,
        style: const TextStyle(color: Colors.black54,fontSize: 20),
      ),
      children: subCities.map((subCity)=>_buildSub(subCity)).toList(),
    );
  }

  Widget _buildSub(String subCity){
    //可以设置撑满宽度的盒子 称之为百分百布局
    return FractionallySizedBox(
      //宽度因子 1为百分百撑满
      widthFactor: 1,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(color: Colors.lightBlueAccent),
        child: Text(subCity),
      ),
    );
  }
}
