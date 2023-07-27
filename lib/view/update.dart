import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final String rcode;
  final String rtitle;
  final String rcontent;
  final String rdate;

  const UpdatePage(
      {super.key,
      required this.rcode,
      required this.rtitle,
      required this.rcontent,
      required this.rdate});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  //Property
  late TextEditingController dcodeController;
  late TextEditingController dtitleController;
  late TextEditingController dcontentController;
  late TextEditingController ddateController;

  @override
  void initState() {
    super.initState();
    dcodeController = TextEditingController();
    dtitleController = TextEditingController();
    dcontentController = TextEditingController();
    ddateController = TextEditingController();

    dcodeController.text = widget.rcode;
    dtitleController.text = widget.rtitle;
    dcontentController.text = widget.rcontent;
    ddateController.text = widget.rdate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Note'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: dcodeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.apple),
                    prefixIcon: Icon(Icons.approval_rounded),
                    labelText: "카운트 입니다.",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: dtitleController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    prefixIcon: Icon(Icons.title),
                    labelText: "제목 입니다.",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: dcontentController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    prefixIcon: Icon(Icons.content_copy_outlined),
                    labelText: "내용 입니다.",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: ddateController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    prefixIcon: Icon(Icons.today_outlined),
                    labelText: "날짜 입니다.",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => updataAction(),
                      child: const Text('수정'),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () => deleteAction(),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Function

  //수정기능
  updataAction() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/diary_update_flutter.jsp?code=${dcodeController.text}&title=${dtitleController.text}&content=${dcontentController.text}&date=${ddateController.text}');

    var response = await http.get(url);
    var dataConvertedJSON =
        json.decode(utf8.decode(response.bodyBytes)); // 제이슨을 가져올수 있도록 바꾸는 것
    var result = dataConvertedJSON['result'];
    if (result == 'OK') {
      _showDialog();
    } else {
      errorSnackBar();
    }
    setState(() {});
  }

  //삭제기능
  deleteAction() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/diary_delet_return_flutter.jsp?code=${dcodeController.text}&title=${dtitleController.text}&content=${dcontentController.text}&date=${ddateController.text}');
    var response = await http.get(url);
    var dataConvertedJSON =
        json.decode(utf8.decode(response.bodyBytes)); // 제이슨을 가져올수 있도록 바꾸는 것
    var result = dataConvertedJSON['result'];
    if (result == 'OK') {
      deletshowDialog();
    } else {
      errorSnackBar();
    }
    setState(() {});
  }

  // 수정 다이알로그
  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('수정결과'),
            content: Text('일기의 수정이 완료되었습니다'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  // 삭제 다이알로그
  deletshowDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('삭제결과'),
            content: const Text('일기의 삭제가 완료되었습니다'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  errorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('일기 정보 입력에 문제가 발생 하였습니다'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // 에러메세지 띄우는 기능
  deletederrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('일기 삭제에 문제가 발생 하였습니다'),
        backgroundColor: Colors.red,
      ),
    );
  }

  //End
}
