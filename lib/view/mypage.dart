import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:schedule_mysql_app/model/message.dart';


class MyPage extends StatefulWidget {
  final int seq;
  final String uid;
  final String upassword;
  final String uname;
  final int ugender;
  final String uemail;
  final String uphone;
  final String uinsertdate;
  final int udeleted;

  const MyPage({
    super.key,
    required this.seq,
    required this.uid,
    required this.upassword,
    required this.uname,
    required this.ugender,
    required this.uemail,
    required this.uphone,
    required this.uinsertdate,
    required this.udeleted,
  });

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //property
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late TextEditingController unameController;
  late TextEditingController uphoneController;
  late TextEditingController uemailController;
  late TextEditingController uinsertdateController;
  late TextEditingController ugenderController;

  @override
  void initState() {
    super.initState();
    uidController = TextEditingController(text: widget.uid); // text : widget으로 초기값주기
    upasswordController = TextEditingController(text: widget.upassword);
    unameController = TextEditingController(text: widget.uname);
    uphoneController = TextEditingController(text: widget.uphone);
    uemailController = TextEditingController(text: widget.uemail);
    uinsertdateController = TextEditingController(text: widget.uinsertdate);
    ugenderController = TextEditingController(
        text: widget.ugender.toString() == "1" ? "여성" : "남성");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "my page",
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: uidController,
                  decoration: const InputDecoration(
                    labelText: "ID",
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: upasswordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: unameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: uphoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: uemailController,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: ugenderController,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                  ),
                  readOnly: true,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: uinsertdateController,
                  decoration: const InputDecoration(
                    labelText: "가입날짜",
                  ),
                  readOnly: true,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  checkID();
                  setState(() {});
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
              ElevatedButton(
                onPressed: () {
                  updateAction();
                  setState(() {});
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
                  "Modify",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  deleteAction();
                  deletesnackBarsFunction();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(70, 35),
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    // 테두리
                    color: Colors.black, // 테두리 색상
                    width: 1.5, // 테두리 두께
                  ),
                ),
                child: const Text(
                  "회원탈퇴",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// function




// 회원정보를 받아서 정보수정 alert
  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "회원정보",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            " ${unameController.text}님의 정보가 변경되었습니다.",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

//functions

  deletesnackBarsFunction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "탈퇴되었습니다.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
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
//user info 변경
updateAction() async {
    var url = Uri.parse(
        "http://192.168.35.51:8080/Flutter/update_schedule_user.jsp?seq=${widget.seq}&uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&ugender=${Message.value}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
    var response = await http.get(url);
    // json은 dart가 모르기때문에 decode해야함
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    if (result == "OK") {
      _showDialog();
    } else {
      errorSnackBar();
    }
    setState(() {});
  }


// delete 회원탈퇴 지만 삭제하지않고 udeleted를 1로 바꿈
deleteAction() async {
    var url = Uri.parse(
        "http://192.168.35.51:8080/Flutter/delete_schedule_user.jsp?seq=${widget.seq}");
    await http.get(url);
    setState(() {});
  }

    errorSnackBar() {
    // 파라미터값을 받아사용
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "error",
        ),
        duration: Duration(seconds: 1), // 2초동안 지속
      ),
    );
  }
















} //end
