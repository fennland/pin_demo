import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../../strings/lang.dart';
import '../../components.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main(){
  runApp(follow_list());
}

class follow_list extends StatefulWidget {
  
  static var body;

  const follow_list({super.key});

  @override
  State<follow_list> createState() => _follow_listState();

}



class _follow_listState extends State<follow_list> {
  late File imageFile = File('');

  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void changeImage() async {
    // 弹出本地图库，并返回选择的文件
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // 更新图片文件
        imageFile = File(pickedFile.path);
      });
    }
  }
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
      
      appBar: AppBar(title: Text(languageProvider.get("关注列表(4)"))),
      body: Column(
          
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/250?image=9",
                    placeholder: (context, url) => CircularProgressIndicator(), // 加载中显示的占位符
                    errorWidget: (context, url, error) => Icon(Icons.error), // 加载失败显示的组件
                    width: 100,
                  ),
                ),
                SizedBox(width: 20.0), // 可选项，用于设置图片和标题之间的间距
                Expanded(
                  child: 
                    ListTile(
                      title: Text("三里屯火锅"),
                      subtitle: Text("三里屯火锅"),
                    ),
                ),
              ],
            ),
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/250?image=9",
                    placeholder: (context, url) => CircularProgressIndicator(), // 加载中显示的占位符
                    errorWidget: (context, url, error) => Icon(Icons.error), // 加载失败显示的组件
                    width: 100,
                  ),
                ),
                SizedBox(width: 20.0), // 可选项，用于设置图片和标题之间的间距
                Expanded(
                  child: 
                    ListTile(
                      title: Text("小帅"),
                      subtitle: Text("爱运动爱火锅的小男孩一枚"),
                    ),
                ),
              ],
            ),
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/250?image=9",
                    placeholder: (context, url) => CircularProgressIndicator(), // 加载中显示的占位符
                    errorWidget: (context, url, error) => Icon(Icons.error), // 加载失败显示的组件
                    width: 100,
                  ),
                ),
                SizedBox(width: 20.0), // 可选项，用于设置图片和标题之间的间距
                Expanded(
                  child: 
                    ListTile(
                      title: Text("牛奶咖啡"),
                      subtitle: Text("手冲咖啡爱好者"),
                    ),
                ),
              ],
            ),
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
                      )
                    : Image.network(
                        "https://picsum.photos/250?image=9",
                        width: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
      ),
    );
  }
  
  
}