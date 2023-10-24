// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> requestPermission(FileSystemEntity file) async {
  PermissionStatus status = await Permission.storage.status;
  await delDir(file);
}

Future<void> delDir(FileSystemEntity file) async {
  if (file is Directory && file.existsSync()) {
    print(file.path);
    final List<FileSystemEntity> children =
        file.listSync(recursive: true, followLinks: true);
    for (final FileSystemEntity child in children) {
      await delDir(child);
    }
  }
  try {
    if (file.existsSync()) {
      await file.delete(recursive: true);
    }
  } catch (err) {
    print(err);
  }
}

//循环获取缓存大小
Future getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
  //  File

  if (file is File && file.existsSync()) {
    int length = await file.length();
    return double.parse(length.toString());
  }
  if (file is Directory && file.existsSync()) {
    List children = file.listSync();
    double total = 0;
    if (children.length > 0)
      for (final FileSystemEntity child in children)
        total += await getTotalSizeOfFilesInDir(child);
    return total;
  }
  return 0;
}

//格式化文件大小
String renderSize(value) {
  if (value == null) {
    return '0.0';
  }
  List<String> unitArr = ['B', 'K']
    ..add('M')
    ..add('G');
  int index = 0;
  while (value > 1024) {
    index++;
    value = value / 1024;
  }
  String size = value.toStringAsFixed(2);
  return size + unitArr[index];
}

/* --- 
   --- Window Util (Window_manager)
   --- */

class WindowUtil {
  ///默认透明度
  static const double defaultOpacity = 1.0;

  ///是否浮窗
  static bool isOnTop = false;

  ///窗口初始化设置
  static Future ensureInitialized() async {
    return await windowManager.ensureInitialized();
  }

  ///初始化参数配置，这里根据自己的模块业务而定，我窗口默认是140,210
  static void setWindowFunctions({bool? isMacOS}) async {
    WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(320.0, 480.0),
      center: true,
      backgroundColor: Colors.transparent,
      //设置窗口是否显示在 任务栏或 Dock 上
      skipTaskbar: false,
      titleBarStyle:
          isMacOS == true ? TitleBarStyle.normal : TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    //设置当前窗口在屏幕的位置
    // windowManager.setPosition(Offset.zero);
    windowManager.center();
    //设置背景
    //设置窗口透明度
    // setOpacity(opacity: defaultOpacity);
    //设置是否可移动macOS
    windowManager.setMovable(true);
    //设置是否有阴影macOS
    windowManager.setHasShadow(false);
    //设置窗口是否可以由用户手动调整大小
    windowManager.setResizable(true);
    //设置标题
    windowManager.setTitle('一起拼');
    //设置窗口是否总是显示在其他窗口的顶部
    windowManager.setAlwaysOnTop(false);
    // if (isMacOS == true) {
    //   //设置用户是否可以手动关闭该窗口
    //   windowManager.setClosable(fa);
    // } else {
    windowManager.setClosable(true);
    // windowManager.setPreventClose(true);
  }

  //设置拖动窗口
  static void startDragging() async {
    await windowManager.startDragging();
  }

  //关闭窗口
  static void close() async {
    windowManager.destroy();
  }

  //设置窗口透明度
  static void setOpacity([double? opacity]) async {
    opacity ??= defaultOpacity;
    //设置背景
    // windowManager
    //     .setBackgroundColor(AppColors.primaryColor.withOpacity(opacity));
    windowManager.setBackgroundColor(Colors.transparent);
    //透明度小于0.1时，不设置setOpacity，避免窗口看不见
    if (opacity >= 0.1) {
      //设置窗口透明度
      windowManager.setOpacity(opacity);
    }
  }

  //设置浮窗
  static void setAlwaysOnTop([bool? isAlwaysOnTop]) {
    isOnTop = isAlwaysOnTop ?? false;
    //设置窗口是否总是显示在其他窗口的顶部
    windowManager.setAlwaysOnTop(isAlwaysOnTop ?? false);
  }
}
