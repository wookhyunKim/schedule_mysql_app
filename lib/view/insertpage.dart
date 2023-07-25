import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  // Property
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('일기쓰기'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: dcodeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    prefixIcon: Icon(Icons.approval_rounded),
                    labelText: "몇번째 일기인지 입력해주세요",
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
                  controller: dtitleController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    prefixIcon: Icon(Icons.title),
                    labelText: "제목을 입력해주새요",
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
                    labelText: "내용을 입력해주세요",
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
                    labelText: "날짜를 입력해주세요",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () => insertAction(),
                  child: const Text('등록'),
                ),
              ],
            ),
          ),
        ));
  }
  // funcetion

  // Function----------------------
  // 주의할것은 호스트 주소를 잘 적어야한다.

  // 입력값이 비어있는지 확인 후 스낵바 표시
  // 비어있지않으면 입력완료 비어있으면 스낵바
  insertAction() async {
    if (dcodeController.text.trim().isEmpty) {
      showSnackbar('년도를 입력하세요');
      return;
    } else if (dtitleController.text.trim().isEmpty) {
      showSnackbar('제목을 입력하세요');
      return;
    } else if (ddateController.text.trim().isEmpty) {
      showSnackbar('내용을 입력하세요');
      return;
    } else if (ddateController.text.trim().isEmpty) {
      showSnackbar('날짜를 입력하세요');
      return;
    }

    var url = Uri.parse(
        'http://localhost:8080/Flutter/diary_insert_flutter.jsp?code=${dcodeController.text}&title=${dtitleController.text}&content=${dcontentController.text}&date=${ddateController.text}');
    await http.get(url);
    _showDialog();
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('입력결과'),
            content: const Text('일기 등록이 성공적으로 되었습니다.'),
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

  // 비어있는 갑 확인하기
  voidInsert() {
    if (dcodeController.text.trim().isEmpty) {
      showSnackbar('code');
    } else if (dtitleController.text.trim().isEmpty) {
      showSnackbar('phone');
    } else if (dcontentController.text.trim().isEmpty) {
      showSnackbar('name');
    } else if (ddateController.text.trim().isEmpty) {
      showSnackbar('dept');
    }
  }

  showSnackbar(String attribute) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${attribute}'),
    ));
  }

  // End
}



// ${nameController.text} 다이알로그의 입력자 주석처리 