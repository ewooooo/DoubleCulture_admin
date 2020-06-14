import 'package:flutter/cupertino.dart';

class JoinOrLogin extends ChangeNotifier{
  // 상태가 login 상태인지, join 상태인지를 나타내고 이에 따라 다른 object들에게도 영향을 끼칠 수 있도록 한다.
  bool _isJoin = false; //_isJoin : private으로 처리해주는 이유는 다른 데에서 이 값을 무작정 접근해서 변경이 가능-> 변경된다면 changenotifier를 통해서 알림이 안가게 된다
  bool get isJoin => _isJoin;

  void toggle(){ //toggle이 실행이 되면, isJoin이 false였으면 true로, true 였다면 false로
    _isJoin = !_isJoin;
    notifyListeners(); // notifilistener를 실행하면 이게 changenotifier를 통해서 제공된 데이터들을 현재 사용중인 위젯들에게 알림으로 보냄

  }
}