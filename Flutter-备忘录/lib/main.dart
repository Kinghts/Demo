import 'package:flutter/material.dart';
import 'dart:convert';
import './detail_page.dart';
import './file.dart';


// 生成列表的items
List<Widget> buildItems(BuildContext context, Map map, Function(String, String) callback) {
  // 设置字体样式
  TextStyle textStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0);
  
  List<Widget> items = [];
  if (map.keys.length == 0) {
    return items;
  }
  map.forEach((k, v) {
    Widget w = new GestureDetector(
      onTap: () { // 处理item的点击事件
        // Navigator.pushNamed(context, 'detail_page');
        print('foreach: $k $v');
        // 跳转到详情页
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return DetailPage(path: k, content: v['content'], callback: callback,);
        }));
      },
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Text(v['content'], style: textStyle),
        decoration: BoxDecoration( // 下划线
          border: Border(bottom: BorderSide(color: Colors.black26))
        ),
      ),
    );
    items.add(w);
  });

  return items;
}

class MyHome extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<MyHome> {
  Map _map = new Map();

  callback(p, c) {
    print('$p $c');
    print(_map);
    setState(() {
      _map[p]['content'] = c;
    });
  }

  @override
    void initState() {
      super.initState();
      print('home init');
      // map.json文件，初始化_map
      FileOperation.readFile('map.json').then((String str) {
        if (str.length > 0) {
          try {
            _map = json.decode(str);
            print(_map);
          } on FormatException {
            print('不是json格式');
          }
        }
      });
    }

  @override
  Widget build(BuildContext context) {

    FileOperation.saveFile('map.json', json.encode(_map));

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('备忘录')
        ),
        body: new ListView(children: buildItems(context, _map, callback)),
        floatingActionButton: new FloatingActionButton( // app的'新增'按钮
          child: new Text('新增'),
          onPressed: () { // 处理'新增'按钮的点击事件
            String path = '${new DateTime.now().millisecondsSinceEpoch}';
            print('新增:$path');
            setState(() { // 修改组件的状态时一定要用setState，这样build方法才会执行，页面才会重新渲染
              _map[path] = { 'content': '' };
            });
            // 跳转到详情页
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return DetailPage(path: path, content: '', callback: callback);
            }));
          },
        )
    );
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: MyHome()
    );
  }
}
