import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:untitled9/model.dart';

void main() {
  runApp(const MyApp());
}

List show = [false, false, false];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List show = [true];

  Future<ExchangeModel> returnApi() async {
    final response = await http.get(Uri.parse(
        "https://www.nrb.org.np/api/forex/v1/rates?from=2022-08-15&to=2022-08-22&per_page=100&page=1"));

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return ExchangeModel.fromJson(data);
    } else {
      return ExchangeModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Currency Rates"),
              Icon(Icons.search),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<ExchangeModel>(
                future: returnApi(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: snapshot.data!.data!.payload!.length,
                            itemBuilder: (context, position) {
                              var showList = List.generate(
                                  snapshot.data!.data!.payload!.length,
                                  (index) => false);
                              var reversedList = new List.from(
                                  snapshot.data!.data!.payload!.reversed);
                              for (int i = 0;
                                  i < snapshot.data!.data!.payload!.length - 1;
                                  i++) {
                                show.add(false);
                              }
                              return Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade300,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    show[position] = !show[position];
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reversedList[position]
                                                  .date
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                      ),
                                      Visibility(
                                        visible: show[position],
                                        child: ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.data!
                                                .payload![0].rates!.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: ListTile(
                                                      leading:  Container(
                                                        height:40,
                                                        
                                                        child: Image.asset(
                                                                    "assets/${snapshot.data!.data!.payload![0].rates![index].currency!.iso3}.png"),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(40)
                                                        ),
                                                      ),


                                                      subtitle: Text(
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .payload![0]
                                                            .rates![index]
                                                            .buy
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      title: Text(
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .payload![0]
                                                            .rates![index]
                                                            .currency!
                                                            .name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ));
  }
}
