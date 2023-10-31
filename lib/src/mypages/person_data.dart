import 'package:flutter/material.dart';
import '../utils/strings/lang.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD:lib/src/mypages/person_data.dart
void main() {
  runApp(const person_data());
=======
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main(){
  runApp(person_data());
>>>>>>> develop4:lib/src/mainPages/mypages/person_data.dart
}

class person_data extends StatefulWidget {
  static var body;

  const person_data({super.key});

  @override
  State<person_data> createState() => _person_dataState();
}

class _person_dataState extends State<person_data> {
  

  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool _generateChip = false;

  void _handleButtonClick() {
    setState(() {
      _generateChip = true;
    });
  }

  Future<String> generateNewChipAsync() async {
    await Future.delayed(Duration(seconds: 2));
    String newChipText = "New Chip";
    return newChipText;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD:lib/src/mypages/person_data.dart
    String icons = "";
    // accessible: 0xe03e
    icons += "\uE03e";
    // error:  0xe237
    icons += " \uE237";
    // fingerprint: 0xe287
    icons += " \uE287";
=======
    
>>>>>>> develop4:lib/src/mainPages/mypages/person_data.dart
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("person_data"))),
      body: Column(
<<<<<<< HEAD:lib/src/mypages/person_data.dart
        children: [
          Image.network(
            "https://picsum.photos/250?image=9",
            width: 100.0,
          ),
          const TextField(
            autofocus: true,
            decoration: InputDecoration(
                hintText: "陈鹏", // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
                prefixIcon: Icon(Icons.person)),
          ),
          _radioRow(),
          const TextField(
            autofocus: true,
            decoration: InputDecoration(
                hintText:
                    "一句话描述自己", // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
                prefixIcon: Icon(Icons.person)),
          ),
          const Row(
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
                  child: const SizedBox(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white, // 这里用于表示占据的空间
                  child: const Wrap(
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
            child: const Text('添加标签'),
          ),
        ],
=======
          
          children: [
            ClipOval(
              
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("选择头像"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("拍照"),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(ImageSource.camera);
                            },
                          ),
                          // TODO: 拍照功能未实现
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text("从相册选择"),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(ImageSource.gallery);
                              
                            },
                            
                          ),
                          // TODO: 图片尺寸过大会出现渲染溢出
                        ],
                      ),
                    ),
                  );
                },
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : Image.network(
                        "https://picsum.photos/250?image=9",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
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
                      ], 
                    ),
                  ),
                ),
                
                FutureBuilder<String>(
                  future: generateNewChipAsync(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('生成新的Chip时出错');
                    } else {
                      return _generateChip 
                        ? Chip(
                            label: Text(snapshot.data!),
                          )
                        : Container();
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _handleButtonClick,
              child: Text('生成新的标签'),
              // TODO: 添加标签功能仅生效一次
            ),
          ],
>>>>>>> develop4:lib/src/mainPages/mypages/person_data.dart
      ),
    );
  }

<<<<<<< HEAD:lib/src/mypages/person_data.dart
  Row _radioRow() {
    return Row(
      children: [
        const Text("男"),
        _colorfulCheckBox(1),
        const Text("女"),
        _colorfulCheckBox(2),
        const Text("保密"),
        _colorfulCheckBox(3),
      ],
    );
=======
  

  Row _radioRow(){
    return Row(children: [
      Text("男"),
      _colorfulCheckBox(1),
      Text("女"),
      _colorfulCheckBox(2),
      Text("保密"),
      _colorfulCheckBox(3),
    ],);
>>>>>>> develop4:lib/src/mainPages/mypages/person_data.dart
  }

  int groupValue = 1;
  Radio _colorfulCheckBox(index) {
    return Radio(
        value: index,
        groupValue: groupValue,
        onChanged: (value) {
          //checkboxSelected = !checkboxSelected;
          print(value);
          groupValue = index;
          setState(() {});
        });
  }
}
