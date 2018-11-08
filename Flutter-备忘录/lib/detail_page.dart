import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
    createState() => new DetailState();

  final String path;
  final String content;
  final Function(String, String) callback;

  const DetailPage({
    Key key,
    this.path,
    this.content,
    this.callback
  }):super(key: key);
}

class DetailState extends State<DetailPage> {
  String _path = '';
  String _content = '';
  TextEditingController _controller;

  @override
    void initState() {
      super.initState();
      _controller = new TextEditingController(text: widget.content);
      setState(() {
        _path = widget.path;
        _content = widget.content;
      });
    }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("备忘录"),
      ),
      body: new Center(
        child: new TextField(
          controller: _controller,
          onChanged: (String str) {
            print('用户输入: $str');
            setState(() {
              _content = str;
            });
            // FileOperation.saveFile(_path, str);
          },
          onSubmitted: (String str) {
            print('用户提交');
          },
          autofocus: true,
          maxLines: 9999,
        )
      ),
    );
  }

  @override
    void deactivate() {
      print('deactivate');
      widget.callback(_path, _content);
      super.deactivate();
    }

  @override
    void dispose() {
      print('dispose');
      super.dispose();
    }
}