import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_mysql_app/view/dpage.dart';
import 'package:schedule_mysql_app/view/update.dart';

import 'insertpage.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  //Proerty
  late List data;

  @override
  void initState() {
    super.initState();
    data = [];
    getJSANData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Note'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const InsertPage();
                  },
                ),
              ).then((value) => getJSANData());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: data.isEmpty
            ? const Text(
                'No data',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UpdatePage(
                              rcode: data[index]['code'],
                              rtitle: data[index]['title'],
                              rcontent: data[index]['content'],
                              rdate: data[index]['date'],
                            );
                          },
                        ),
                      ).then((value) => getJSANData());
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Dpage(
                                rcode: data[index]['code'],
                                rtitle: data[index]['title'],
                                rcontent: data[index]['content'],
                                rdate: data[index]['date'],
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        color: Colors.white,
                        child: ListTile(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(200), // 모서리 효과
                          // ),
                          // tileColor: Colors.grey,
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            child: FittedBox(
                              child: Text(
                                '${data[index]['code']}',
                              ),
                            ),
                          ),
                          title: Text(
                            'Title : ${data[index]['title']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('제목 : ${data[index]['title']}'),
                              Text(
                                'content: ${data[index]['content']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'date : ${data[index]['date']}',
                                style: TextStyle(fontSize: 10),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return UpdatePage(
                                              rcode: data[index]['code'],
                                              rtitle: data[index]['title'],
                                              rcontent: data[index]['content'],
                                              rdate: data[index]['date'],
                                            );
                                          },
                                        ),
                                      ).then((value) => getJSANData());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(30, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('수정'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return UpdatePage(
                                              rcode: data[index]['code'],
                                              rtitle: data[index]['title'],
                                              rcontent: data[index]['content'],
                                              rdate: data[index]['date'],
                                            );
                                          },
                                        ),
                                      ).then((value) => getJSANData());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(30, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                },
              ),
      ),
      // 하단 등록버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const InsertPage();
              },
            ),
          ).then((value) => getJSANData());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 오른쪽 하단에 버튼 배치
    );
  }

  //Function

  // (1) 순서
  getJSANData() async {
    // Java의 Dao에서 데이터를 연결하는 것
    // 데이터를 가져오는 것
    // Uri 내 정보도 같이 넘어간다.
    var url =
        Uri.parse('http://localhost:8080/Flutter/diary_query_flutter.jsp');
    var response = await http.get(url); // url 정보 가져온다. 데이터 불러올떄까지 기다려라
    // print(response.body);
    data.clear(); // 데이터 클리어
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    data.addAll(result);
    setState(() {}); // 이걸안하면 화면구성하기전에 나온다.
  }
}
