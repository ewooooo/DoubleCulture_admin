import 'package:flutter/material.dart';
import 'package:doublecultureadmin/main.dart';
import 'package:doublecultureadmin/myHttp/AdapHttp.dart';
import 'package:doublecultureadmin/myHttp/model.dart';
import 'package:doublecultureadmin/data/UserData.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //globalkey를 이용해서 Form에다가 Formkey를 지정해주고 --> Unique한 ID가 되는 것!
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("exit?"),
        actions: <Widget>[
          FlatButton(
            child: Text("ok"),
            onPressed: () => Navigator.pop(context, true),
          ),
          FlatButton(
            child: Text("cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size =
        MediaQuery.of(context).size; //App이 가지고 있는 size을 가지고와서 size를 넣어줌!

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logoImage,

            _inputForm(size),


            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,60.0),
              child: SizedBox(
                height: 50,
                width: size.width * 0.6,
                child: RaisedButton(
                  child: Text(
                    "로그인",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: Color(0xFF1a2d74),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //formkey를 가져와서 currentstate를 확인하고 validate를 실행해서 이 안의 Text가 우리가 원하는 건지 확인해서 아니면 에러를 내보내고 맞으면
                      String id = _emailController.text;
                      String pw = _passwordController.text;
                      Token token = await server.getToken(id, pw);
                      if (token == null) {
                        printToast("아이디 or 비밀번호를 확인하세요.");
                      } else {
                        _emailController.text = "";
                        _passwordController.text = "";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()),
                        );
                      }
                    }
                  },
                ),
              ),
            ), // gap
          ],
        ),
      ),
    );
  }

  Widget get _logoImage => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50,50,50,0),
        child: Image.asset('assets/KGU_Logo.png'),
      ),
    ),
  );

  Widget _inputForm(Size size) {
    //Size를 사용하지 못하기에 여기에 던져줌
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        // new widget으로 감싸기 커서 놓고 Alt+enter
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 6,
        child: Padding(
          padding:
          const EdgeInsets.only(left: 12.0, right: 16, top: 15, bottom: 32),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle), labelText: "ID : 학번"),
                    validator: (String value) {
                      // validator : 유저가 작성 뒤 로그인 버튼 누를 때 이메일필드에 작성한 내용을 가져와서 옳은지 체크
                      if (value.isEmpty) {
                        return "올바른 학번 ID를 기입하세요.";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: true, // password ****표시
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key), labelText: "비밀번호"),
                    validator: (String value) {
                      // validator : 유저가 작성 뒤 로그인 버튼 누를 때 이메일필드에 작성한 내용을 가져와서 옳은지 체크
                      if (value.isEmpty) {
                        return "올바른 비밀번호를 입력하세요.";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 5,
                  ),
                  Text("비밀번호를 잊어버린경우 관리자에게 문의하세요."),
                ],
              )),
        ),
      ),
    );
  }
}
