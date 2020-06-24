import 'package:doublecultureadmin/data/UserData.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'myHttp/AdapHttp.dart';
import 'myHttp/model.dart';
import 'screen/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '학교 밖 수원을 보다 - 관리자',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: const Color(0xFF1a2d74),
          accentColor: const Color(0xFF1a2d74),
          canvasColor: const Color(0xFFaabdf5),
        ),
        //home:MyHomePage(),
        debugShowCheckedModeBanner: false, // Debug 배너 제거
        home:  AuthPage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _student_id = TextEditingController();
  final TextEditingController _museumID = TextEditingController();

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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
          centerTitle: true,
        ),
        //body: _menu[_index],
        body: Column(
          children: <Widget>[
            Container(
              height: 30,
            ),// gap
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _student_id,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.account_circle),
                  labelText: "처리할 학생의 학번을 입력하세요",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _museumID,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.account_circle),
                  labelText: "기관 이름을 입력하세요(ex 소성박물관)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              height: 20,
            ),// gap
            SizedBox(
              height: 50,
              width: 100,
              child: RaisedButton(
                child: Text(
                  '전송',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.black12,
                onPressed: () async{
                  if(!_student_id.text.isEmpty && !_museumID.text.isEmpty){
                    Position position = await getGPS();
                    double long;
                    if(position.longitude<0){
                      long = -position.longitude;
                    }else{
                      long = position.longitude;
                    }
                    if(await server.updateStemp(_student_id.text,_museumID.text,position.latitude,long)) {
                      printToast("정상 처리되었습니다.");
                    }else{
                      Token token = await server.getToken(userData.username, userData.password);
                      await server.updateStemp(_student_id.text,_museumID.text,position.latitude,position.longitude);
                    }
                  }else{
                    printToast("모든 값을 입력해주세요.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<Position> getGPS() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    return position;
  }
}
