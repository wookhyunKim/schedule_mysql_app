import 'package:flutter/material.dart';
import 'package:schedule_mysql_app/model/message.dart';
import 'package:schedule_mysql_app/view/diary.dart';
import 'package:schedule_mysql_app/view/mypage.dart';
import 'package:schedule_mysql_app/view/todo_list.dart';

import 'model/share.dart';
import 'view/accountbook.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late String userId;
  late String userNick;
  late String userName;

  late TabController btBar;

  @override
  void initState() {
    super.initState();
    userId = 'lovely_IU@gmail.com';
    userNick = 'Lovely_징짱';
    userName = '이지은';

    btBar = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    btBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Better than Yesterday'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyPage(
                        seq: Message.seq,
                        uid: Message.uid,
                        upassword: Message.upassword,
                        uname: Message.uname,
                        ugender: Message.ugender,
                        uemail: Message.uemail,
                        uphone: Message.uphone,
                        uinsertdate: Message.uinsertdate,
                        udeleted: Message.udeleted);
                  },
                ),
              );
            },
            icon: Icon(
              Icons.person,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: color13,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: color01),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/sample_IU.jpeg'),
              ),
              accountName: Text(userNick),
              accountEmail: Text(userId),
            ),
          ], //Listview >>> children
        ),
      ),
      body: TabBarView(
        controller: btBar,
        children: const [
          TodoList(),
          DiaryPage(),
          AccountBook(),
        ],
      ),

      //Home_main(),

      bottomNavigationBar: Container(
        height: 100,
        color: color02,
        child: TabBar(
          controller: btBar,
          labelColor: color01,
          tabs: [
            Tab(
              icon: Icon(
                Icons.sports_soccer,
                color: color01,
              ),
              text: '해야할일',
            ),
            Tab(
              icon: Icon(
                Icons.person,
                color: color01,
              ),
              text: '일기장',
            ),
            Tab(
              icon: Icon(
                Icons.message,
                color: color01,
              ),
              text: '지출기록',
            ),
          ],
        ),
      ),
    );
  }
}
