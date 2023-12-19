import 'package:flutter/material.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const person_data());
}

class person_data extends StatefulWidget {
  static var body;

  const person_data({super.key});

  @override
  State<person_data> createState() => _person_dataState();
}

// // 定义一个类来表示每个 ActionChip 的数据
//   class ActionChipData {
//     final Widget label;

//     ActionChipData({required this.label});
//   }

  class ActionChipData {
    final Widget label;
    bool isSelected;
    Color backgroundColor;

    ActionChipData({
      required this.label,
      this.isSelected = false,
      this.backgroundColor = Colors.grey,
    });
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

  @override
  void initState(){
    super.initState();
    setState(() {
        _update("firstInitialized");
    });
  }

  Future<void> _update(String type) async {
    try {
      UserModel? user = await getUserInfo();
      // onChanged: (value) {
      //     if (user != null) {
      //       user.userID = value;  
      //     }
      // };
      if(type == "name"){
        if (user != null) {
          var updateResult = await saveModifiedNameToCloud(
            user.userID,
            _nameEditingController.text,
            user.gender,
            user.sign
          );
          debugPrint("name: ${user?.userName}");
      setState(() {
        if (user != null) {
          name = updateResult["result"]["data"][0]["userName"];
          saveUserInfo(UserModel.fromJson(updateResult["result"]["data"][0]));
        }
      });
        }
      }
      else if(type == "sign"){
        if (user != null) {
          var updateResult = await saveModifiedNameToCloud(
            user.userID,
            user.userName,
            user.gender,
            _signEditingController.text
          );
          debugPrint(_signEditingController.text);
          debugPrint("sign: ${user?.sign}");
      setState(() {
        if (user != null) {
          sign = updateResult["result"]["data"][0]["sign"];
          saveUserInfo(UserModel.fromJson(updateResult["result"]["data"][0]));
        }
      });
        }
      }
      else if(type == "firstInitialized"){
        setState(() {
          name = user?.userName;
          sign = user?.sign;
        });
      }
      
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Future<void> _update() async {
  //   try {
  //     UserModel? user = await getUserInfo();
  //     onChanged: (value) {
  //         if (user != null) {
  //           user.userID = value;  
  //         }
  //     };
  //     var updateResult = await saveModifiedNameToCloud(
  //       (user?.userID ??""),
  //       _nameEditingController.text,
  //       0,
  //       _signEditingController.text
  //     );
  //     setState(() {
  //       if (user != null) {
  //         name = user.userName;
  //         sign = user.sign;
  //       }
  //     });
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   }
  // }

  // 定义异步函数
  Future<void> updateUserProfile() async {
    String username = _nameEditingController.text;

    // 调用修改个人资料的方法
    Map<String, dynamic> response = await changePersonData(username);

    // 处理响应结果
    if (response["code"] == 200) {
      // 修改成功，可以进行相应的处理
    } else {
      // 修改失败，可以进行相应的处理
    }
  }
  
  String? name = 'name';
  int gender = 0;
  String? sign = 'sign';

  bool _generateChip = false;
  
  String editedText = '';
  bool _isEditing = false;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _signEditingController = TextEditingController();

  void showTimeoutSnackbar(BuildContext context) {
    bool timedOut = false; // 设置超时标记

    Future.delayed(const Duration(seconds: 5), () {
      if (!timedOut) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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

  // Future<String> generateNewChipAsync() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   String newChipText = "New Chip";
  //   return newChipText;
  // }

  // List<Widget> _generatedChips = [];

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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('生成新的Chip时出错');
        } else {
          String chipText = snapshot.data!;
          ActionChipData newChipData = ActionChipData(
            label: Text(chipText),
            isSelected: false,
            backgroundColor: Colors.grey,
          );
          return GestureDetector(
            onTap: () {
              setState(() {
                newChipData.isSelected = !newChipData.isSelected;
                if (newChipData.isSelected) {
                  newChipData.backgroundColor = Colors.blue;
                } else {
                  newChipData.backgroundColor = Colors.grey;
                }
              });
              SnackBar sb = const SnackBar(content: Text("单击"));
              ScaffoldMessenger.of(context).showSnackBar(sb);
            },
            onDoubleTap: () {
              setState(() {
                if (textEditingController.text == '') {
                  buttonText = '运动';
                } else {
                  buttonText = textEditingController.text;
                }
              });
              SnackBar sb = const SnackBar(content: Text("双击"));
              ScaffoldMessenger.of(context).showSnackBar(sb);
            },
            child: ActionChip(
              backgroundColor: _backgroundColor,
              pressElevation: 10,
              tooltip: "点击",
              labelPadding: const EdgeInsets.all(2),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports,
                    color: _backgroundColor,
                  ),
                  const SizedBox(width: 2),
                  Text(buttonText),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> generateNewChipAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    String newChipText = "New Chip";
    return newChipText;
  }

  String buttonText = '运动';
  TextEditingController textEditingController =
      TextEditingController(); // 添加一个文本编辑控制器

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("person_data"))),
      body: 
      // FutureBuilder(
      //   future: _update(bool),
      //   builder: (context, snapshot) {
          // if (snapshot.hasData) {
            // final user = snapshot.data;
            // return 
            Column(
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
                      placeholder: FileImage(File('lib/src/static/images/avatar.jpeg')), // AssetImage('assets/placeholder.jpg'),
                      image: FileImage(File('lib/src/static/images/avatar.jpeg')),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          TextField(
            controller: _nameEditingController,
            // onChanged: (value) {
            //   setState(() {
            //     if (user != null) {
            //       user.userName = value;
            //       name = (user?.userName ??"");
            //       print(name);
            //     }
            //   });
            // },
            // onSubmitted: (value) => _update(),
            
            onSubmitted: (value) async { await _update("name");},
            autofocus: true,
            decoration: InputDecoration(
                hintText: name, // (user?.userName ??languageProvider.get("curUser")),
                // hintText: "陈鹏", // TODO: 改成保存当前名字，点选后可以删掉再改，而不是hint作为placeholder getUserInfo(userName)
                prefixIcon: Icon(Icons.person)),
                
          ),
          // ElevatedButton(
          //   onPressed: () async {    
          //     onChanged: (value) {
          //       setState(() {
          //         if (user != null) {
          //           user.userID = value;  
          //         }
          //       });
          //     };
          //     var loginResult = await saveModifiedNameToCloud(
          //                           (user?.userID ??languageProvider.get("curUser")),
          //                           _nameEditingController.text,
          //                           0,
          //                           _signEditingController.text);
          //     print(loginResult["code"]);
          //     print(loginResult["result"]);
          //     setState(() {
          //       if (user != null) {
          //         name = _nameEditingController.text;
          //         print(name);
          //       }
          //     });
          //   },
            
          //   child: Text('Change Person Data'),
            
          // ),
          _radioRow(),
          TextField(
            controller: _signEditingController,
            onSubmitted: (value) async { await _update("sign");},
            autofocus: true,
            decoration: InputDecoration(
                hintText: sign, // (user?.sign ??languageProvider.get("curUserSigning")),
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
                      // TextField(
                      //   controller: textEditingController,
                      //   decoration: InputDecoration(
                      //     hintText: "输入按钮文本",
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSelected = !_isSelected;
                            if(_isSelected){
                              _backgroundColor = Colors.blue;
                            }
                            else{
                              _backgroundColor = Colors.grey;
                            }
                          });
                          SnackBar sb = const SnackBar(content: Text("单击"));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        },
                        onDoubleTap: () {
                          setState(() {
                            if (textEditingController.text == '') {
                              buttonText = '运动';
                            } else {
                              buttonText = textEditingController.text;
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
                      
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSelected = !_isSelected;
                            if(_isSelected){
                              _backgroundColor = Colors.blue;
                            }
                            else{
                              _backgroundColor = Colors.grey;
                            }
                          });
                          SnackBar sb = const SnackBar(content: Text("单击"));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        },
                        onDoubleTap: () {
                          setState(() {
                            if (textEditingController.text == '') {
                              buttonText = '运动';
                            } else {
                              buttonText = textEditingController.text;
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
                              if (!Platform.isWindows) // 判断平台为Windows时不显示拍照选项
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text("拍照"),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              // TODO: 拍照功能未实现
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text("从相册选择"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              // TODO: 图片尺寸过大会出现渲染溢出
                            ],
                          ),
                        ),
                      ),

                      ..._generatedChips,
                    ],
                  ),
                ),
              ),

            ],
          ),
          ElevatedButton(
            onPressed: _handleButtonClick,
            child: Text('生成新的标签'),
          ),
        ],
      ),
          // }
          // else{
          //   return  const Center(child: CircularProgressIndicator(),);
          // }
    //     },
    // ),
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
                const Text("男"),
                _colorfulCheckBox(1),
                const Text("女"),
                _colorfulCheckBox(0),
                const Text("保密"),
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
