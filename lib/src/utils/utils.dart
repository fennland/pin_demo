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
    if (children.length > 0) {
      for (final FileSystemEntity child in children) {
        total += await getTotalSizeOfFilesInDir(child);
      }
    }
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
  static const double defaultOpacity = 0;

  ///是否浮窗
  static bool isOnTop = false;

  ///窗口初始化设置
  static Future ensureInitialized() async {
    return await windowManager.ensureInitialized();
  }

  ///初始化参数配置，这里根据自己的模块业务而定，我窗口默认是140,210
  static void setWindowFunctions({bool? isMacOS}) async {
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(360.0, 480.0),
      center: true,
      // backgroundColor: Colors.transparent,
      //设置窗口是否显示在 任务栏或 Dock 上
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
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



// 正则表达式判断

// class RegExpUtils {
//   RegExpUtils._();

//   ///检查字符串是否只包含数字。
//   ///数字型不接受双精度数据类型的"。
//   static bool isNumericOnly(String s) => hasMatch(s, r'^\d+$');

//   ///检查字符串是否只包含字母。(没有空格)
//   static bool isAlphabetOnly(String s) => hasMatch(s, r'^[a-zA-Z]+$');

//   ///检查字符串是否至少包含一个大写字母
//   static bool hasCapitalletter(String s) => hasMatch(s, r'[A-Z]');

//   ///检查string是否是有效的用户名。
//   static bool isUsername(String s) =>
//       hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

//   ///检查string是否为URL。
//   static bool isURL(String s) => hasMatch(s,
//       r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9-.]+.[a-zA-Z]{2,6}(:[0-9]{1,5})*(/($|[a-zA-Z0-9.,;?'\+&amp;%$#=~_-]+))*$");

//   ///检查字符串是否为email。
//   static bool isEmail(String s) => hasMatch(s,
//       r'^(([^<>()[]\.,;:\s@"]+(.[^<>()[]\.,;:\s@"]+)*)|(".+"))@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}])|(([a-zA-Z-0-9]+.)+[a-zA-Z]{2,}))$');

//   ///检查字符串是否为电话号码。
//   static bool isPhoneNumber(String s) {
//     if (s.length > 16 || s.length < 9) return false;
//     return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]*$');
//   }

//   ///检查string是否为DateTime (UTC或Iso8601)。
//   static bool isDateTime(String s) =>
//       hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

//   /// Checks if string is MD5 hash.
//   static bool isMD5(String s) => hasMatch(s, r'^[a-f0-9]{32}$');

//   /// Checks if string is SHA1 hash.
//   static bool isSHA1(String s) =>
//       hasMatch(s, r'(([A-Fa-f0-9]{2}:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

//   /// Checks if string is SHA256 hash.
//   static bool isSHA256(String s) =>
//       hasMatch(s, r'([A-Fa-f0-9]{2}:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

//   /// Checks if string is SSN (Social Security Number).
//   static bool isSSN(String s) => hasMatch(s,
//       r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

//   /// Checks if string is binary.
//   static bool isBinary(String s) => hasMatch(s, r'^[0-1]+$');

//   /// Checks if string is IPv4.
//   static bool isIPv4(String s) =>
//       hasMatch(s, r'^(?:(?:^|.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

//   /// Checks if string is IPv6.
//   static bool isIPv6(String s) => hasMatch(s,
//       r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b).){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b).){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b).){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

//   ///检查string是否是十六进制。
//   /// 示例: HexColor => #12F
//   static bool isHexadecimal(String s) =>
//       hasMatch(s, r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

//   ///检查字符串是否为回文。
//   static bool isPalindrom(String string) {
//     final cleanString = string
//         .toLowerCase()
//         .replaceAll(RegExp(r"\s+"), '')
//         .replaceAll(RegExp(r"[^0-9a-zA-Z]+"), "");

//     for (var i = 0; i < cleanString.length; i++) {
//       if (cleanString[i] != cleanString[cleanString.length - i - 1]) {
//         return false;
//       }
//     }

//     return true;
//   }

//   /// 检查字符串是否为护照号。
//   static bool isPassport(String s) =>
//       hasMatch(s, r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

//   /// 检查string是否为货币。
//   static bool isCurrency(String s) => hasMatch(s,
//       r'^(S?$|\₩|Rp|\¥|\€|\₹|\₽|fr|R$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

//   /// 检查num是否为cnpj
//   static bool isCnpj(String cnpj) {
//     // Obter somente os números do CNPJ
//     final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

//     // Testar se o CNPJ possui 14 dígitos
//     if (numbers.length != 14) {
//       return false;
//     }

//     // Testar se todos os dígitos do CNPJ são iguais
//     if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
//       return false;
//     }

//     // Dividir dígitos
//     final digits = numbers.split('').map(int.parse).toList();

//     // Calcular o primeiro dígito verificador
//     var calcDv1 = 0;
//     var j = 0;
//     for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
//       calcDv1 += digits[j++] * i;
//     }
//     calcDv1 %= 11;
//     final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

//     // Testar o primeiro dígito verificado
//     if (digits[12] != dv1) {
//       return false;
//     }

//     // Calcular o segundo dígito verificador
//     var calcDv2 = 0;
//     j = 0;
//     for (var i in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
//       calcDv2 += digits[j++] * i;
//     }
//     calcDv2 %= 11;
//     final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

//     // Testar o segundo dígito verificador
//     if (digits[13] != dv2) {
//       return false;
//     }

//     return true;
//   }

//   /// 检查cpf是否有效。
//   static bool isCpf(String cpf) {
//     // if (cpf == null) {
//     //   return false;
//     // }

//     // get only the numbers
//     final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
//     // Test if the CPF has 11 digits
//     if (numbers.length != 11) {
//       return false;
//     }
//     // Test if all CPF digits are the same
//     if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
//       return false;
//     }

//     // split the digits
//     final digits = numbers.split('').map(int.parse).toList();

//     // Calculate the first verifier digit
//     var calcDv1 = 0;
//     for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
//       calcDv1 += digits[10 - i] * i;
//     }
//     calcDv1 %= 11;

//     final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

//     // Tests the first verifier digit
//     if (digits[9] != dv1) {
//       return false;
//     }

//     // Calculate the second verifier digit
//     var calcDv2 = 0;
//     for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
//       calcDv2 += digits[11 - i] * i;
//     }
//     calcDv2 %= 11;

//     final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

//     // Test the second verifier digit
//     if (digits[10] != dv2) {
//       return false;
//     }

//     return true;
//   }

//   /// credits to "ReCase" package.
//   static final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
//   static final _symbolSet = {' ', '.', '/', '_', '\', '-'};
//   static List<String> _groupIntoWords(String text) {
//     var sb = StringBuffer();
//     var words = <String>[];
//     var isAllCaps = text.toUpperCase() == text;

//     for (var i = 0; i < text.length; i++) {
//       var char = text[i];
//       var nextChar = i + 1 == text.length ? null : text[i + 1];
//       if (_symbolSet.contains(char)) {
//         continue;
//       }
//       sb.write(char);
//       var isEndOfWord = nextChar == null ||
//           (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
//           _symbolSet.contains(nextChar);
//       if (isEndOfWord) {
//         words.add('$sb');
//         sb.clear();
//       }
//     }
//     return words;
//   }



//   /// Extract numeric value of string
//   /// Example: OTP 12312 27/04/2020 => 1231227042020ß
//   /// If firstword only is true, then the example return is "12312"
//   /// (first found numeric word)
//   static String numericOnly(String s, {bool firstWordOnly = false}) {
//     var numericOnlyStr = '';

//     for (var i = 0; i < s.length; i++) {
//       if (isNumericOnly(s[i])) {
//         numericOnlyStr += s[i];
//       }
//       if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == " ") {
//         break;
//       }
//     }

//     return numericOnlyStr;
//   }

//   static bool hasMatch(String? value, String pattern) {
//     return (value == null) ? false : RegExp(pattern).hasMatch(value);
//   }

// }