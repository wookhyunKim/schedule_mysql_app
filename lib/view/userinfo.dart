import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late List data;

  @override
  void initState() {
    super.initState();
    data = [];
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User INFO",
        ),
      ),
      body: Center(
        child: data.isEmpty
            ? const Text(
                "데이터가 없습니다.",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Text(
                          "ID : ${data[index]["uid"]}",
                        ),
                        Text(
                          "PW : ${data[index]["upassword"]}",
                        ),
                        Text(
                          "E-mail : ${data[index]["uemail"]}",
                        ),
                        Text(
                          "Gender : ${data[index]["ugender"] == 1 ? "여성" : "남성"}",
                        ),
                        Text(
                          "탈퇴여부 : ${data[index]["udeleted"] == 0 ? "X" : "O"}",
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

//function

//select
  getJSONData() async {
    var url = Uri.parse(
        "http://192.168.35.51:8080/Flutter/select_schdule_userinfo.jsp");
    var response = await http.get(url); // 데이터불러오기전에 화면이 켜지는 것 방지. await
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    data.addAll(result);
    setState(() {});
  }
} //end
