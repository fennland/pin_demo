import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../../strings/lang.dart';
import '../../components.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(person_data());
}

class person_data extends StatefulWidget {
  static var body;

  const person_data({super.key});

  @override
  State<person_data> createState() => _person_dataState();
}

class _person_dataState extends State<person_data> {
  List<String> interestKeywords = ['标签1', '标签2', '标签3', '标签4', '标签5'];
  @override
  Widget build(BuildContext context) {
    String icons = "";
            // accessible: 0xe03e
            icons += "\uE03e";
            // error:  0xe237
            icons += " \uE237";
            // fingerprint: 0xe287
            icons += " \uE287";
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("person_data"))),
      body: Column(
        
          children: [
            Image.network(
              "https://picsum.photos/250?image=9",
              width: 100.0,
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
              hintText: "陈鹏",  // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
              prefixIcon: Icon(Icons.person)
              ),
            ),
            
            _radioRow(),

            TextField(
              autofocus: true,
              decoration: InputDecoration(
              hintText: "一句话描述自己",  // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
              prefixIcon: Icon(Icons.person)
              ),
            ),

            Row(
              children: [
                Text('兴趣关键词'),
              ],
            ),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.red, // 这里用于表示剩余的空间
                    child: SizedBox(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white, // 这里用于表示占据的空间
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      alignment: WrapAlignment.start,
                      children: [
                        Chip(label: Text('标签1')),
                        Chip(label: Text('标签2')),
                        Chip(label: Text('标签3')),
                        Chip(label: Text('标签4')),
                        Chip(label: Text('标签5')),
                        //interestKeywords.map((keyword) => Chip(label: Text(keyword))).toList(),
                        // TODO: 添加标签功能不生效
                      ], 
                    ),
                  ),
                ),
                
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  interestKeywords.add('新标签');
                });
              },
              child: Text('添加标签'),
            ),
          ],
      ),
      
    );
  }

  Row _radioRow(){
    return Row(children: [
      Text("男"),
      _colorfulCheckBox(1),
      Text("女"),
      _colorfulCheckBox(2),
      Text("保密"),
      _colorfulCheckBox(3),
    ],);
  }

  int groupValue = 1;
  Radio _colorfulCheckBox(index){
    return Radio(
        value: index,
        groupValue: groupValue,
        onChanged: (value){
          //checkboxSelected = !checkboxSelected;
          print(value);
          groupValue = index;
          setState(() {
          });
        }
    );
  }
}