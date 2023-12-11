import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(person_data());
}

class person_data extends StatefulWidget {
  static var body;

  const person_data({super.key});

  @override
  State<person_data> createState() => _person_dataState();
}

class _person_dataState extends State<person_data> {
  bool _isSelected = false;
  Color _backgroundColor = Colors.grey;

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

  void showTimeoutSnackbar(BuildContext context) {
    bool timedOut = false; // 设置超时标记

    Future.delayed(Duration(seconds: 5), () {
      if (!timedOut) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('信号灯超时'),
              ],
            ),
          ),
        );
      }
    });

    // 在需要的地方设置超时标记为true，比如异步请求的回调中
    // 如果超时了，在回调中设置 timedOut = true;
  }

  Future<String> generateNewChipAsync() async {
    await Future.delayed(Duration(seconds: 2));
    String newChipText = "New Chip";
    return newChipText;
  }

  List<Widget> _generatedChips = [];

  void _handleButtonClick() {
    setState(() {
      _generatedChips.add(_buildNewChip());
    });
  }

  Widget _buildNewChip() {
    return FutureBuilder<String>(
      future: generateNewChipAsync(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('生成新的Chip时出错');
        } else {
          return Chip(
            label: Text(snapshot.data!),
          );
        }
      },
    );
  }

  String buttonText = '运动';
  TextEditingController textEditingController = TextEditingController(); // 添加一个文本编辑控制器

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("person_data"))),
      body: Column(
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
                        if (!Platform.isWindows) // 判断平台为Windows时不显示拍照选项
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("拍照"),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(ImageSource.gallery);
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
                  : FadeInImage(
                      placeholder: AssetImage('assets/placeholder.jpg'),
                      image: NetworkImage('https://picsum.photos/250?image=9'),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                hintText: "陈鹏", // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
                prefixIcon: Icon(Icons.person)),
          ),
          _radioRow(),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                hintText:
                    "一句话描述自己", // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder
                prefixIcon: Icon(Icons.person)),
          ),
          Row(
            children: [
              Text('兴趣关键词'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 2.0,
                    alignment: WrapAlignment.start,
                    children: [
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "输入按钮文本",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSelected = !_isSelected;
                            if(_isSelected){
                              _backgroundColor = Color.fromARGB(0, 255, 0, 0);
                            }
                            else{
                              _backgroundColor = Color.fromARGB(0, 154, 76, 76);
                            }
                          });
                          SnackBar sb = const SnackBar(content: Text("单击"));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        },
                        onDoubleTap: () {
                          setState(() {
                            if (_isSelected) {
                              buttonText = textEditingController.text.isNotEmpty
                                  ? textEditingController.text
                                  : '运动';
                            } else {
                              buttonText = '';
                            }
                          });
                          SnackBar sb = const SnackBar(content: Text("双击"));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        },
                        child: ActionChip(
                          backgroundColor: _backgroundColor,
                          pressElevation: 10,
                          tooltip: "点击",
                          labelPadding: EdgeInsets.all(2),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.sports,
                                color: _backgroundColor,
                              ),
                              SizedBox(width: 2),
                              Text(buttonText),
                            ],
                          ),
                        ),
                      ),
                      
                        
                        // onPressed: () {
                        //   setState(() {
                        //     _isSelected = !_isSelected;
                        //     if (_isSelected) {
                        //       _backgroundColor = Colors.blue;
                              
                        //     } else {
                        //       _backgroundColor = Colors.grey;
                              
                        //     }
                        //   });
                        //   SnackBar sb = const SnackBar(content: Text("点击"));
                        //   ScaffoldMessenger.of(context).showSnackBar(sb);
                        // },
                      
                      ..._generatedChips,
                      Chip(label: Text('标签1')),
                      Chip(label: Text('标签2')),
                      Chip(label: Text('标签3')),
                      Chip(label: Text('标签4')),
                      Chip(label: Text('标签5')),
                    ],
                  ),
                ),
              ),

            ],
          ),
          ElevatedButton(
            onPressed: _handleButtonClick,
            child: Text('生成新的标签'),
            // TODO: 添加标签功能仅生效一次
          ),
        ],
      ),
    );
  }

  Row _radioRow() {
    return Row(
      children: [
        const Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(8.0), child: Text("性别"))),
        const SizedBox(),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("男"),
                _colorfulCheckBox(1),
                Text("女"),
                _colorfulCheckBox(0),
                Text("保密"),
                _colorfulCheckBox(-1),
              ],
            ))
      ],
    );
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
