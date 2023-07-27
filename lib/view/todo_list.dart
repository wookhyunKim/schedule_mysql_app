import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_mysql_app/model/share.dart';
import 'package:schedule_mysql_app/view/deleted_list.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // property
  late List todoList;
  late bool showDoneList;       // 완료된 항목 보여주기 체크박스
  late TextEditingController listController;      // 현재 데이터 베이스 내용 보여주기
  late TextEditingController addListController;   // 입력받을 할 일 목록 추가

  @override
  void initState() {
    super.initState();

    todoList = [];
    showDoneList = false;
    listController = TextEditingController();
    addListController = TextEditingController();
    
    addJSONData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Column(
          children: [
            Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: () => insertAlert(context), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  icon: Icon(
                    Icons.add_outlined,
                    color: color13,
                  ), 
                  label: Text(
                    '할 일 추가',
                    style: TextStyle(
                      color: color13
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Row(
                children: [
                  Checkbox(
                    value: showDoneList, 
                    onChanged: (value1) {
                      showDoneList = value1!;
                      addJSONData();
                      setState(() {
                        
                      });
                    },
                  ),
                  const Text(
                    '완료된 항목 보기',
                    style: TextStyle(
                      fontSize: 15
                    ),)
                ],
              ),
            ],
          ),

            Expanded(
              child: todoList.isEmpty
              ? Column(           // ⭐️ 데이터 베이스 비어있을 때 테스트 해보기
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '데이터가 없습니다.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        insertAlert(context);
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color13,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                      icon: const Icon(Icons.add_outlined), 
                      label: const Text('할 일 추가하기'),
                    ),
                  )
                ],
              ) 
              : ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  TextEditingController listController = TextEditingController(text: todoList[index]['listname']);
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey(todoList[index]['seq']),
                    onDismissed: (direction) async {
                      updateDeleteStatus(todoList[index]['seq']);
                      todoList.remove(todoList[index]);
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
                              value: todoList[index]['checkvalue'] == 1? true : false, 
                              onChanged: (value) {
                                todoList[index]['checkvalue'] = value! ? 1 : 0 ;
                                print(todoList[index]['seq']);
                                print(todoList[index]['checkvalue']);
                                updateCheckValue(todoList[index]['seq'], listController.text, todoList[index]['checkvalue']);
                                setState(() {
                                  
                                });
                                
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 350,
                                  height: 30,
                                  child: TextField(
                                    controller: listController,
                                    // onChanged: (value) {
                                    //   String listText = value;
                                    //   setState(() {
                                    //     listController.text = listText;
                                    //   });
                                    // },         // 실시간 데이터 베이스에 반영 실패 (입력이 역순으로 나가여... sqlite로 다시 도전해보기)
                                    onEditingComplete: () {
                                      String listText = '';
                                      setState(() {
                                        listText = listController.text;
                                      });
                                      print(listText);
                                      updateCheckValue(todoList[index]['seq'], listText, todoList[index]['checkvalue']);
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: todoList[index]['checkvalue'] == 0? Colors.black : Colors.grey,
                                      decoration: todoList[index]['checkvalue'] == 0? TextDecoration.none : TextDecoration.lineThrough,
                                      decorationColor: todoList[index]['checkvalue'] == 0? null : Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  '추가한 날짜 : ${todoList[index]['insertdate']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: todoList[index]['checkvalue'] == 0? Colors.black : Colors.grey,
                                    decoration: todoList[index]['checkvalue'] == 0? TextDecoration.none : TextDecoration.lineThrough,
                                    decorationColor: todoList[index]['checkvalue'] == 0? null : Colors.grey,
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
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: color13,
        foregroundColor: Colors.white,
        activeBackgroundColor: color13,
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 15,
        // 
        children: [
          SpeedDialChild( 
            child: const Icon(Icons.add_outlined),
            shape: const CircleBorder(),
            backgroundColor: Colors.brown[50],
            label: '할 일 추가하기',
            labelStyle: const TextStyle(fontSize: 20),
            onTap: () => insertAlert(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete_forever),
            shape: const CircleBorder(),
            backgroundColor: Colors.teal[50],
            label: '최근 삭제 목록 보기',
            labelStyle: const TextStyle(fontSize: 20),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return const DeleteList();
                  },
                ),
              ).then((value) => addJSONData());
            },
          ),
        ],
      ),
    );
  }

  // ------ functions -------

  // (첫) 화면에서 보여줄 데이터 베이스에서 가져온 리스트들 (완료?)
  addJSONData() async {     // 완료된 항목 보기가 true이면 다 포함된 url, false이면 제외한 url
    var url = Uri.parse(
      showDoneList
      ? 'http://localhost:8080/Flutter/select_done_o_flutter.jsp'        // 모든 데이터가 포함된 리스트 불러오기
      : 'http://localhost:8080/Flutter/select_done_x_flutter.jsp'        // 선택되지 않은(checkvalue=0)인 리스트만 불러오기
    );
    var response = await http.get(url);
    todoList.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    // print(result);
    todoList.addAll(result);
    setState(() {
      
    });
  }

  // 각 리스트의 체크박스 선택 시 전체 화면 구성 다시 하기 (완료?)
  updateCheckValue(int seqNo, String todolist, int checkvalue) async {
    var url = Uri.parse(
      'http://localhost:8080/Flutter/update_checkvalue_flutter.jsp?seq=$seqNo&listname=$todolist&checkvalue=$checkvalue'
    );
    await http.get(url);
    addJSONData();
    setState(() {
      
    });
  }

  // 목록에 할 일 추가할 때 보여줄 alertDialog (완료)
  insertAlert(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_outlined),
              Text('Add To Do List'),
            ],
          ),
          backgroundColor: Colors.green[50],
          content: TextField(
            controller: addListController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: '추가할 일을 작성하세요'
            ),
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    addListController.text = '';
                    Navigator.pop(ctx);
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: color13
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    insertList();
                    addListController.text = '';
                    Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: color13
                    ),),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // 입력받은 할 일 리스트에 추가하기 (완료)
  insertList() async {      // 테이블에 추가
    if(addListController.text.trim().isEmpty) {
      showSnackBar();
    } else {
      var url = Uri.parse(
        'http://localhost:8080/Flutter/insert_flutter_jin.jsp?checkvalue=0&listname=${addListController.text}'
      );
      var response = await http.get(url);
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      var result = dataConvertedJSON["result"];
      addJSONData();
      setState(() {
        
      });
    }
  }

  // 할 일 입력하지 않고 버튼 눌렀을 때 보여줄 스낵바 (완료)
  showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '할 일을 입력하지 않으셨습니다.',
          textAlign: TextAlign.center,
          ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  // swipe로 목록 삭제시 delete status=1, deletedate = now() 입력하기 (완료)
  updateDeleteStatus(int seqNo) async {
    var url = Uri.parse(
      'http://localhost:8080/Flutter/update_deletestatus_flutter.jsp?seq=$seqNo&deletestatus=1&checkvalue=0'
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    addJSONData();
    setState(() {
      
    });
  }



  




} // End