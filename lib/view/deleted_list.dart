import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_mysql_app/model/share.dart';

class DeleteList extends StatefulWidget {
  const DeleteList({super.key});

  @override
  State<DeleteList> createState() => _DeleteListState();
}

class _DeleteListState extends State<DeleteList> {

  // property
  late List deletedList;
  late bool checkvalue;

  @override
  void initState() {
    super.initState();
    deletedList = [];
    checkvalue = false;

    addJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color13,
        foregroundColor: Colors.white,
        title: const Column(
          children: [
            Text(
              'Deleted List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              checkDelete();
              setState(() {
                
              });
            }, 
            icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                '최근 30일간 삭제된 목록만 보입니다.',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            Expanded(
              child: deletedList.isEmpty
              ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 100,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 100,),
                    Text(
                      '최근 30일 간 삭제된 목록이 없습니다.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: deletedList.length,
                itemBuilder: (context, index) {

                  checkvalue = deletedList[index]['checkvalue'] == 1 ? true : false;

                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey(deletedList[index]['seq']),
                    onDismissed: (direction) {
                      deleteJSONwitSeq(deletedList[index]['seq']);
                      deletedList.removeAt(index);
                      setState(() {
                        
                      });
                    }, 
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        color: index % 3 == 0? Colors.green[50] : index % 3 == 1? Colors.brown[50] : Colors.teal[50],
                        child: Row(
                          children: [
                            Checkbox(
                              value: deletedList[index]['checkvalue'] == 1 ? true : false , 
                              onChanged: (value) {
                                deletedList[index]['checkvalue'] = value! ? 1 : 0 ;
                                if (deletedList[index]['checkvalue'] == 1) checkAlert(context, deletedList[index]['seq']) ;
                                setState(() {
                                  
                                });
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deletedList[index]['deletelist'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: deletedList[index]['checkvalue'] == 0? Colors.black : Colors.grey,
                                    decoration: deletedList[index]['checkvalue'] == 0? TextDecoration.none : TextDecoration.lineThrough,
                                    decorationColor: deletedList[index]['checkvalue'] == 0? null : Colors.grey,
                                  ), 
                                ),
                                Text(
                                  '삭제된 날짜 : ${deletedList[index]['insertdate']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: deletedList[index]['checkvalue'] == 0? Colors.black : Colors.grey,
                                    decoration: deletedList[index]['checkvalue'] == 0? TextDecoration.none : TextDecoration.lineThrough,
                                    decorationColor: deletedList[index]['checkvalue'] == 0? null : Colors.grey,
                                  ), 
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------- functions ------
  // 첫 화면 구성 (완료)
  addJSONData() async{
    var url = Uri.parse(
      'http://localhost:8080/Flutter/select_deletestatus_flutter.jsp'
    );
    var response = await http.get(url);
    deletedList.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    // print(result);
    deletedList.addAll(result);
    setState(() {
      
    });
  }

  // 체크 박스 선택시 확인창 (복원 여부) 띄우기 (완료)
  checkAlert(BuildContext context, int seq) {
    showDialog(
      context: context, 
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.help_outline),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('알람'),
              )
            ],
          ),
          backgroundColor: Colors.green[50],
          content: const Text('To Do List로 복원하시겠습니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                updateDeleteStatusN(seq, 1, 1);
                Navigator.pop(context);
              }, 
              child: const Text('아니오'),
            ),
            ElevatedButton(
              onPressed: () {
                updateDeleteStatus(seq, 0, 0);
                Navigator.pop(context);
                setState(() {
                  
                });
              }, 
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }

  // 삭제버튼 클릭시 경고창 띄우기
  checkDelete() {
    if (checkvalue == true) {
      showAlertMessage(context);
    }
  }

  showAlertMessage(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red[400],
              ),
              Text(
                ' 경고',
                style: TextStyle(
                  color: Colors.red[400],
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          backgroundColor: Colors.green[50],
          content: const Text('삭제하시면 복원할 수 없습니다.\n영구삭제를 진행하시겠습니까?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ), 
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.red[400]
                    ),
                  ),
                ),
                const SizedBox(width: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  onPressed: () {
                    deleteJSON();
                    Navigator.pop(context, true);
                  }, 
                  child: Text(
                    '삭제하기',
                    style: TextStyle(
                      color: Colors.red[400]
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  // 체크박스 눌렀을 때 복원여부(Y) 선택시 할 일 (완료)
  updateDeleteStatus(int seqNo, int deletestatus, int checkvalue) async {
    var url = Uri.parse(
      'http://localhost:8080/Flutter/update_insertdate_flutter.jsp?seq=$seqNo&deletestatus=$deletestatus&checkvalue=$checkvalue'
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    addJSONData();
    setState(() {
      
    });
  }
  
  // 체크박스 눌렀을 때 복원여부(N) 선택시 할 일 (완료)
  updateDeleteStatusN(int seqNo, int deletestatus, int checkvalue) async {
    var url = Uri.parse(
      'http://localhost:8080/Flutter/update_deletestatus_flutter.jsp?seq=$seqNo&deletestatus=$deletestatus&checkvalue=$checkvalue'
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    addJSONData();
    setState(() {
      
    });
  }

  // 데이터베이스에서 삭제하기 (아이콘 클릭시) => checkvalue, delete status 값 가지고 삭제 (완료)
  deleteJSON() async{
    var url = Uri.parse(
      'http://localhost:8080/Flutter/todoList_delete_flutter.jsp'
    );
    await http.get(url);
    deleteDone();
    addJSONData();
    setState(() {
      
    });

  }

  // 데이터베이스에서 삭제하기 (swipe 삭제시) => seq 번호 가지고 삭제 (완료)
  deleteJSONwitSeq(int seq) async{
    var url = Uri.parse(
      'http://localhost:8080/Flutter/todoList_delete_seq_flutter.jsp?seq=$seq'
    );
    await http.get(url);
    deleteDone();
    addJSONData();
    setState(() {
      
    });

  }

  // 삭제 완료 창 띄워주기 (완료)
  deleteDone() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('삭제 완료'),
          content: const Text('삭제가 완료 되었습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

  }

} // END