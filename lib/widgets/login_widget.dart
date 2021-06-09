import 'package:flutter/material.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/model/login_page_model.dart';

import 'bottom_to_top_widget.dart';

class LoginWidget extends StatelessWidget {
  final LoginPageModel loginPageModel;

  const LoginWidget({Key key, @required this.loginPageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final primaryColorLight = Theme.of(context).primaryColorLight;
    final primaryColorDark = Theme.of(context).primaryColorDark;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Form(
        key: loginPageModel.formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BottomToTopWidget(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: loginPageModel.addrController,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                        hintText: '输入连接IP:端口号',
                        labelText: '连接地址',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.http,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => Future.delayed(
                            Duration(milliseconds: 100),
                            () => loginPageModel.addrController?.clear(),
                          ),
                        )),
                  ),
                  index: 0,
                ),
                BottomToTopWidget(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: loginPageModel.dbNameController,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                        hintText: '输入数据库名',
                        labelText: '数据库名',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.data_usage,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => Future.delayed(
                            Duration(milliseconds: 100),
                            () => loginPageModel.dbNameController?.clear(),
                          ),
                        )),
                  ),
                  index: 0,
                ),
                BottomToTopWidget(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: loginPageModel.dbAccountController,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                        hintText: '输入用户名',
                        labelText: '用户名',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.account_circle,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => Future.delayed(
                            Duration(milliseconds: 100),
                            () => loginPageModel.dbAccountController?.clear(),
                          ),
                        )),
                  ),
                  index: 0,
                ),
                BottomToTopWidget(
                  child: TextFormField(
                    controller: loginPageModel.dbPasswdController,
                    keyboardType: TextInputType.text,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: '输入数据库密码',
                      labelText: '密码',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                    ),
                    obscureText: true,
                  ),
                  index: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                BottomToTopWidget(
                  index: 2,
                  child: Container(
                    height: 60,
                    width: size.width - 80,
                    child: FlatButton(
                      color: primaryColor,
                      highlightColor: primaryColorLight,
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text(
                        IntlLocalizations.of(context).logIn,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                      onPressed: loginPageModel.logic.onLogin,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BottomToTopWidget(
                  index: 2,
                  child: Container(
                    height: 60,
                    width: size.width - 80,
                    child: FlatButton(
                      color: primaryColor.withOpacity(0.3),
                      highlightColor: primaryColorLight,
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text(
                        IntlLocalizations.of(context).haveNoAccount,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: primaryColorDark)),
                      onPressed: loginPageModel.logic.onRegister,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                loginPageModel.isFirst
                    ? BottomToTopWidget(
                        child: FlatButton(
                          color: primaryColor,
                          highlightColor: primaryColorLight,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text(IntlLocalizations.of(context).skip),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          onPressed: loginPageModel.logic.onSkip,
                        ),
                        index: 3)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
