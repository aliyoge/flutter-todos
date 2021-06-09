import 'package:shared_preferences/shared_preferences.dart';
export 'package:todo_list/config/keys.dart';
import 'package:todo_list/config/keys.dart';

class SharedUtil {
  factory SharedUtil() => _getInstance();

  static SharedUtil get instance => _getInstance();
  static SharedUtil _instance;

  SharedUtil._internal() {
    //初始化
  }

  static SharedUtil _getInstance() {
    if (_instance == null) {
      _instance = new SharedUtil._internal();
    }
    return _instance;
  }

  Future remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.remove(key);
  }

  Future saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == Keys.account) {
      await prefs.setString(key, value);
      return;
    }
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setString(key, value);
  }

  Future saveInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setInt(key, value);
  }

  Future saveDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setDouble(key, value);
  }

  Future saveBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setBool(key, value);
  }

  Future saveStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setStringList(key, list);
  }

  Future<bool> readAndSaveList(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key) ?? [];
    if (strings.length >= 10) return false;
    strings.add(data);
    await prefs.setStringList(key, strings);
    return true;
  }

  void readAndExchangeList(String key, String data, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key) ?? [];
    strings[index] = data;
    await prefs.setStringList(key, strings);
  }

  void readAndRemoveList(String key, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key) ?? [];
    strings.removeAt(index);
    await prefs.setStringList(key, strings);
  }

  //-----------------------------------------------------get----------------------------------------------------

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == Keys.account) {
      return prefs.getString(key);
    }
    // String account = prefs.getString(Keys.account) ?? "default";
    return prefs.getString(key);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    return prefs.getInt(key);
  }

  Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    return prefs.getDouble(key);
  }

  Future<bool> getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    return prefs.getBool(key) ?? false;
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    return prefs.getStringList(key);
  }

  Future<List<String>> readList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String account = prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key) ?? [];
    return strings;
  }
}
