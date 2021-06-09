import 'package:flutter/cupertino.dart';
import 'package:todo_list/config/provider_config.dart';
import 'package:todo_list/database/database.dart';
import 'package:todo_list/model/all_model.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/pages/navigator/settings/about/webview_page.dart';
import 'package:todo_list/utils/shared_util.dart';
import 'package:todo_list/widgets/net_loading_widget.dart';

class LoginPageLogic {
  final LoginPageModel _model;

  LoginPageLogic(this._model);

  void onExit() {
    _model.currentAnimation = "move_out";
    _model.showLoginWidget = false;
    _model.refresh();
  }

  void onLogin() {
    final context = _model.context;
    showDialog(
        context: _model.context,
        builder: (ctx) {
          return NetLoadingWidget();
        });
    _onLoginRequest(context);
  }

  void onForget() {
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return ProviderConfig.getInstance().getResetPasswordPage(isReset: false);
    }));
  }

  void onRegister() {
    Navigator.of(_model.context).push(CupertinoPageRoute(builder: (ctx) {
                          return WebViewPage(
                            'https://memfiredb.com/db?utm_source=todoshwj',
                            title: 'MemFireDb',
                          );
                        }));
  }

  void onSkip() {
    SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
    Navigator.of(_model.context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) {
      return ProviderConfig.getInstance().getMainPage();
    }), (router) => router == null);
  }

  void _showDialog(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            content: Text(text),
          );
        });
  }

  void _onLoginRequest(BuildContext context) async {
    final dbAddr = _model.addrController.text;
    final dbName = _model.dbNameController.text;
    final dbAccount = _model.dbAccountController.text;
    final dbPasswd = _model.dbPasswdController.text;
    if (dbAddr == null || dbName == null || dbAccount == null || dbPasswd == null ||
        dbAddr == '' || dbName == '' || dbAccount == '' || dbPasswd == '') {
      Navigator.of(context).pop();
      _showDialog('请将数据库资料填写完整', context);
      return;
    }

    await SharedUtil.instance.saveString(Keys.dbAddr, dbAddr);
    await SharedUtil.instance.saveString(Keys.dbName, dbName);
    await SharedUtil.instance.saveString(Keys.dbAccount, dbAccount);
    await SharedUtil.instance.saveString(Keys.dbPasswd, dbPasswd);
    await SharedUtil.instance.saveString(Keys.account, dbAccount);
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, true);

    DBProvider.db.clear();

    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) {
      return ProviderConfig.getInstance().getMainPage();
    }), (router) => router == null);
  }
}
