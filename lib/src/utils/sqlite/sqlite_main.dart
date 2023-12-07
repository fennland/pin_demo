import 'package:pin_demo/src/utils/sqlite/sqlite_util.dart';

void main() async {
  await SqliteUtil.getInstance("test");

}
