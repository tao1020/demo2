import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
    var a=' ';var b=' ';var c=' ';
    var d=' ';var e=' ';var f=' ';
    var g=' ';var h=' ';var i=' ';
   var msg="名单"; //msg默认文字
   @override
   Widget build(BuildContext context) {
       return Scaffold(
            appBar: AppBar(
              title: Text("Demo"),
            ),
            body: Center(
                      child:Column(
                              children:<Widget>[
                                  Text(msg), //根据变量值，显示文字

                                  OutlineButton(
                                      color: Colors.blue,
                                      textColor: Colors.blue,
                                      onPressed: () async {
                                          Dio dio=new Dio();
                                            Response res =await dio.get("http://192.168.1.104:8000/persons");
                                           var items =res.data['persons'];
                                          // print(items);
                                        //   print(items);
                                            // print(res.data['persons']);
                                            setState(() {
                                              this.msg="查询结果";
                                             this.a=items[0]['id'].toString();
                                              this.b=items[0]['first_name'].toString();
                                              this.c=items[0]['last_name'].toString();
                                              this.d=items[1]['id'].toString();
                                              this.e=items[1]['first_name'].toString();
                                              this.f=items[1]['last_name'].toString();
                                              this.g=items[2]['id'].toString();
                                              this.h=items[2]['first_name'].toString();
                                              this.i=items[2]['last_name'].toString();
                                            });
                                      },
                                      child: Text(
                                        "查询",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                  ),
                                Table(
                                 columnWidths: const {
                                   //列宽
                                   0: FixedColumnWidth(100.0),
                                   1: FixedColumnWidth(100.0),
                                   2: FixedColumnWidth(100.0),
                                 },
                                 border: TableBorder.all(
                                   color: Colors.blue,
                                   width: 2.0,
                                   style: BorderStyle.solid,
                                 ),
                                   children:[
                                     TableRow(
                                         children: [
                                           //增加行高
                                           SizedBox(
                                             height: 30.0,
                                             child:
                                             Text('ID',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                           ),
                                           Text('姓名',style: TextStyle(fontWeight: FontWeight.bold),),
                                           Text('地点',style: TextStyle(fontWeight: FontWeight.bold),),
                                         ]
                                     ),
                                     TableRow(
                                         children: [
                                           Text(a),
                                           Text(b),
                                           Text(c),
                                         ]
                                     ),
                                     TableRow(
                                         children: [
                                           Text(d),
                                           Text(e),
                                           Text(f),
                                         ]
                                     ),
                                     TableRow(
                                         children: [
                                           Text(g),
                                           Text(h),
                                           Text(i),
                                         ]
                                     ),
                                   ]
                               )
                              ]
                      )
                  )
      );
  }  

}