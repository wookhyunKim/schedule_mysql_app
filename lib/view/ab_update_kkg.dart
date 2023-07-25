import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/share.dart';
import 'package:http/http.dart' as http;

class ABupdate extends StatefulWidget {
  final int code;

  const ABupdate({super.key, required this.code});

  @override
  State<ABupdate> createState() => _ABupdateState();
}

class _ABupdateState extends State<ABupdate> {
  late List _data;
  late TextEditingController tecTitle;
  late TextEditingController tecAmount;
  late TextEditingController tecContent;
  late TextEditingController tecConfirmType;
  late TextEditingController tecDuedate;

  @override
  void initState() {
    super.initState();
    tecTitle = TextEditingController();
    tecAmount = TextEditingController();
    tecContent = TextEditingController();
    tecConfirmType = TextEditingController();
    tecDuedate = TextEditingController();

    _data = [];

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color13,
        foregroundColor: color02,
        title: const Text('Better than Yesterday'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey,
                    width: 400,
                    height: 670,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: SizedBox(
                      width: 300,
                      height: 100,
                      child: Card(
                        color: Colors.cyan,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Title'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: tecTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 금액 입력하는 카드 넣기
                  Positioned(
                    top: 120,
                    left: 10,
                    child: SizedBox(
                      width: 180,
                      height: 100,
                      child: Card(
                        color: Colors.amber,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text('금 액 ( 원)')],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: tecAmount,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 200,
                    child: SizedBox(
                      width: 180,
                      height: 100,
                      child: GestureDetector(
                        onTap: () => _selectState(),
                        child: Card(
                          color: Colors.cyan,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Text('상 태')],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          tecConfirmType.text,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 230,
                    left: 10,
                    child: SizedBox(
                      width: 180,
                      height: 100,
                      child: Card(
                        color: Colors.amber,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text('날 짜 (yyyy-mm-dd)')],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: tecDuedate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 340,
                    left: 10,
                    child: SizedBox(
                      width: 360,
                      height: 320,
                      child: Card(
                        color: Colors.cyan,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Text('상세 내용')],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextField(
                                  maxLines: 9,
                                  controller: tecContent,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _cancel(),
                  child: const Text('취소'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => _save(),
                  child: const Text('저장'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _getData() async {
    _data.clear();
    var url = Uri.parse(
        "http://localhost:8080/Flutter/bty/bty_updateAB.jsp?code=${widget.code}");
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    List result = dataConvertedJSON['abList'];
    print(result);
    _data.addAll(result);

    _setData();

    setState(() {});
  }

  _setData() {
    tecTitle.text = _data[0]['title'];
    tecContent.text = _data[0]['content'];
    tecAmount.text = _data[0]['amount'];
    tecDuedate.text = _data[0]['confirmdate'];

    switch (_data[0]['confirm']) {
      case '0':
        tecConfirmType.text = '지출 예정';

        break;

      case '1':
        tecConfirmType.text = '지출 완료';
        tecDuedate.text = _data[0]['confirmdate'];
        break;

      case '10':
        tecConfirmType.text = '입금 예정';

        break;
      case '11':
        tecConfirmType.text = '입금 완료';

        break;
    }
  }

// 상태 수정을 위한 함수
  _selectState() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('상태 선택'),
          actions: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _select(0),
                      child: const Text('지출 예정'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () => _select(1),
                      child: const Text('지출 완료'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _select(10),
                      child: const Text('입금 예정'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () => _select(11),
                      child: const Text('입금 확정'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 상태를 지정하는 함수
  _select(int num) {
    String state = '';
    switch (num) {
      case 0:
        state = '지출 예정';

        break;

      case 1:
        state = '지출 확정';

        break;

      case 10:
        state = '입금 예정';

        break;

      case 11:
        state = '입금 확정';

        break;
    }

    tecConfirmType.text = state;
    Navigator.of(context).pop();
    setState(() {});
  }

  //저장 함수
  _save() async {
    int _case = 0;
    switch (tecConfirmType.text) {
      case '지출 예정':
        _case = 0;

        break;
      case '지출 완료':
        _case = 1;

        break;
      case '입금 예정':
        _case = 10;

        break;
      case '입금 완료':
        _case = 11;

        break;
    }

    var url = Uri.parse(
        "http://localhost:8080/Flutter/bty/bty_update_saveAB.jsp?code=${widget.code}&title=${tecTitle.text}&amount=${tecAmount.text}&state=${_case}&date=${tecDuedate.text}&content=${tecContent.text}");
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    String result = dataConvertedJSON['result'];
    print(result);

    switch (result) {
      case 'OK':
        _complete();
        break;

      case 'ERROR':
      _fail();
        break;
    }

  }

  //취소 함수
  _cancel() {
    Navigator.of(context).pop();
  }
  _fail(){
        showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('실패'),
          content: const Text('저장에 실패했습니다. 입력 내용을 확인해 주세요.'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('확인'))
          ],
        );
      },
    );

  }

  _complete() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('저장 완료'),
          content: const Text('저장이 완료 되었습니다.'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('확인'))
          ],
        );
      },
    );
  }
}
