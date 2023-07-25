import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/share.dart';
import 'ab_insert_kkg.dart';
import 'ab_update_kkg.dart';

class AccountBook extends StatefulWidget {
  const AccountBook({super.key});

  @override
  State<AccountBook> createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
  late List G_abList;

  @override
  void initState() {
    super.initState();
    G_abList = [];

    _getGABList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color02,
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: color02,
                height: 630,
                child: ListView(
                  children: [
                    Card(
                      color: coloradditional,
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 85,
                            height: 30,
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(' 항목 '),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('날짜'),
                                ],
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('금액'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (int i = 0; i < G_abList.length; i++)
                      Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: ValueKey(i),
                        onDismissed: (direction) {
                          _deleteAB(G_abList[i]['code']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: SizedBox(
                            height: 110,
                            child: GestureDetector(
                              onTap: () {
                                _updateAB(G_abList[i]['code']);
                              },
                              child: Card(
                                color: decColor(i),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 85,
                                            height: 70,
                                            child: Icon(
                                              Icons.access_alarm,
                                              size: 50,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      G_abList[i]['title'],
                                                      style: TextStyle(
                                                        color: contentColor(i),
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                              width: 90,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    G_abList[i]['confirmdate'],
                                                    style: TextStyle(
                                                      color: contentColor(i),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    G_abList[i]['amount'] +
                                                        ' 원',
                                                    style: TextStyle(
                                                      color: contentColor(i),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '입력/수정일 : ' +
                                                G_abList[i]['in_update'] +
                                                '  ',
                                            style: TextStyle(
                                              color: contentColor(i),
                                            ),
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
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: color02,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 430,
                  height: 83,
                  child: GestureDetector(
                    onTap: () {
                      _insertAB();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 3),
                      child: Card(
                        color: coloradditional,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  decColor(int i) {
    late Color col;

    switch (G_abList[i]['confirm']) {
      case '0':
        col = colorSpendPre1;

        break;
      case '1':
        col = colorSpendConfirm1;

        break;
      case '10':
        col = colorIncomePre1;

        break;
      case '11':
        col = colorIncomeConfirm1;

        break;
    }

    return col;
  }

  contentColor(int i) {
    late Color col;

    switch (G_abList[i]['confirm']) {
      case '0':
        col = color01;

        break;
      case '1':
        col = color02;

        break;
      case '10':
        col = color01;

        break;
      case '11':
        col = color02;

        break;
    }

    return col;
  }

  dateColor(int i) {
    late Color col;

    switch (G_abList[i]['confirm']) {
      case '0':
        col = colorSpendPre3;

        break;
      case '1':
        col = colorSpendConfirm3;

        break;
      case '10':
        col = colorIncomePre3;

        break;
      case '11':
        col = colorIncomeConfirm3;

        break;
    }

    return col;
  } //function

  _getGABList() async {
    G_abList.clear();
    var url = Uri.parse(
        "http://localhost:8080/Flutter/bty/bty_accountbook.jsp?userID=${Share.userID}");
    var response = await http.get(url);
    // print(Share.userID);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    List result = dataConvertedJSON['abList'];
    // print(result);
    G_abList.addAll(result);
    setState(() {});
  }

  _updateAB(String code) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ABupdate(code: int.parse(code));
      },
    )).then((value) => _getGABList());
  }

  _deleteAB(String code) async {
    var url = Uri.parse(
        "http://localhost:8080/Flutter/bty/bty_delete_AB.jsp?code=${code}");

    await http.get(url);
    //var response = await http.get(url);
    // print(Share.userID);

    //var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    //print(dataConvertedJSON['result']);

    _getGABList();
  }

  _insertAB() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const ABinsert();
      },
    )).then((value) => _getGABList());
  }
}//end
