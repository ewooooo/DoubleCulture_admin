import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './model.dart';
import 'package:fluttertoast/fluttertoast.dart';


void printToast(String mesg){
  Fluttertoast.showToast(
      msg: mesg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

const _API_PREFIX = "http://ec2-18-216-189-42.us-east-2.compute.amazonaws.com/"; //HTTP 주소

class Server {
  String token = "";

  Future<Token> getToken(String id, String pw) async {
    final http.Response response = await http.post(
      _API_PREFIX + "api/token/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {
            'username': id,
            'password': pw
          }
      ),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      String body = utf8.decode(response.bodyBytes);
      dynamic j = json.decode(body);
      Token t = Token.fromJson(j);
      this.token = t.token;
      return t;
    } else if(response.statusCode == 400){
      return null;
    } else {
      printToast("서버와 연결이 원활하지 않습니다. \n 관리자에게 문의해주세요.");
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to connection');
    }
  }


  Future<bool> checkToken() async {
    final http.Response response = await http.post(
      _API_PREFIX + "api/token/verify/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {
            'token': token
          }
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      printToast("서버와 연결이 원활하지 않습니다. \n 관리자에게 문의해주세요.");
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to connection');
    }
  }

  Future<bool> updateStemp(String student_id, String museumID,double latitude,
      double longitude) async {
    final http.Response response = await http.put(
      _API_PREFIX + "app/stemp_staff/",
      headers: <String, String>{
        'Authorization': "jwt " + token,
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
          {
            'museumID' : museumID,
            'student_id' : student_id,
            'latitude': latitude,
            'longitude': longitude
          }
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 202) {
      printToast("현재 위치가 올바르지 않습니다.");
      return false;
    } else if (response.statusCode == 404) {
      printToast("기관정보가 올바르지 않습니다.");
      return false;
    } else if (response.statusCode == 401) {
      printToast("권한이 올바르지 않습니다.");
      return false;
    } else {
      printToast("서버와 연결이 원활하지 않습니다. \n 관리자에게 문의해주세요. "+ response.statusCode.toString());
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to connection');
    }
  }


  Future<bool> serverTest() async {
    final http.Response response = await http.get(
      _API_PREFIX + "app/test/",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }



}

Server server = Server();