import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_mysql_app/model/message.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late TextEditingController unameController;
  late TextEditingController uemailController;
  late TextEditingController uphoneController;
  late int _radioValue; // ugender 판단

  @override
  void initState() {
    super.initState();

    uidController = TextEditingController();
    upasswordController = TextEditingController();
    unameController = TextEditingController();
    uemailController = TextEditingController();
    uphoneController = TextEditingController();
    _radioValue = 0; // 0 : 남성, 1 : 여성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            width: 350,
            color: const Color(0xFFF5F5DC),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: uidController,
                      decoration: const InputDecoration(
                        labelText: "아이디를 입력하세요.",
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          checkID();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // 버튼 배경색
                          foregroundColor: Colors.white, // 버튼 글씨색
                          minimumSize: const Size(70, 35),
                          shape: RoundedRectangleBorder(
                            //  버튼 모양 깎기
                            borderRadius: BorderRadius.circular(20), // 10은 파라미터
                          ),
                        ),
                        child: const Text(
                          "Check",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: upasswordController,
                    decoration: const InputDecoration(
                      labelText: "비밀번호를 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: unameController,
                    decoration: const InputDecoration(
                      labelText: "이름을 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: uphoneController,
                    decoration: const InputDecoration(
                      labelText: "전화번호를 입력하세요.",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: uemailController,
                    decoration: const InputDecoration(
                      labelText: "이메일을 입력하세요.",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("성별 : "),
                    Radio(
                      value: 0,
                      groupValue: _radioValue, //radio grouping
                      onChanged: (value) {
                        Message.value = value!;
                        _radioChange(value);
                      },
                    ),
                    const Text(
                      "남성",
                    ),
                    Radio(
                      value: 1,
                      groupValue: _radioValue, //radio grouping
                      onChanged: (value) {
                        Message.value = value!;
                        _radioChange(value);
                      },
                    ),
                    const Text(
                      "여성",
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    insertAction();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색
                    foregroundColor: Colors.white, // 버튼 글씨색
                    minimumSize: const Size(100, 35),
                    shape: RoundedRectangleBorder(
                      //  버튼 모양 깎기
                      borderRadius: BorderRadius.circular(5), // 5 파라미터
                    ),
                  ),
                  child: const Text(
                    "Register",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _radioChange(int? value) {
    // type이 int? 이유는 radio 가 check 될 수 도 있고 안 될 수도 있기 때문
    _radioValue = value!;
    setState(() {});
  }

//중복메세지 스낵바
  snackBarFunction() {
    // 파라미터값을 받아사용
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "중복된 ID 입니다.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
        backgroundColor: Colors.red,
      ),
    );
  }

//아이디 사용가능 스낵바
  snackBarsFunction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "사용가능한 ID입니다.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
        backgroundColor: Colors.green,
      ),
    );
  }

// 회원정보를 받아서 가입승인 alert
  _showDialog() {
    showDialog(
      context: context, // 전 화면의 구성 dialog죽으면 다시 구성해야하기때문에 알고있어야함
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "가입승인",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            " ${unameController.text}님의 가입을 축하드립니다 !",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

// insert
  insertAction() async {
    if (uidController.text.trim().isNotEmpty &
        upasswordController.text.trim().isNotEmpty &
        unameController.text.trim().isNotEmpty &
        uphoneController.text.trim().isNotEmpty &
        uemailController.text.trim().isNotEmpty) {
      var url = Uri.parse(
          "http://192.168.35.51:8080/Flutter/insert_schedule_user_register.jsp?uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&ugender=${Message.value}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
      await http.get(url);
      _showDialog();
    } else {
      errorSnackBar();
    }
  }
//중복체크
  checkID() async {
    var url = Uri.parse(
        "http://192.168.35.51:8080/Flutter/select_schdule_dupcheck_flutter.jsp?uid=${uidController.text.trim()}");
    var response = await http.get(url);
    // json은 dart가 모르기때문에 decode해야함
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    if (result == "OK") {
      // 아이디가 중복일때
      snackBarFunction();
    } else {
      // 아이디가 중복아닐때
      snackBarsFunction();
    }
    setState(() {});
  }

  errorSnackBar() {
    // 파라미터값을 받아사용
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "회원가입이 취소되었습니다.",
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
      ),
    );
  }
} //end
