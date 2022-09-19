// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_employees/models/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Employee List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.parse('https://reqres.in/api/users');
  int? counter;
  var employeeResult;

  Future callEmployee() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var result = employeesFromJson(response.body);
        print(result.data[0].firstName);
        setState(() {
          counter = result.data.length;
          employeeResult = result;
        });
        return result;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: counter != null
              ? ListView.builder(
                  itemCount: counter,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(
                          employeeResult.data[index].firstName +
                              " " +
                              employeeResult.data[index].lastName,
                          style: myTextStyle),
                      subtitle: Text(
                        employeeResult.data[index].email,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(employeeResult.data[index].avatar)),
                    );
                  }),
                )
              : Text(
                  'Press The Button To List Employees',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update),
        backgroundColor: Colors.grey,
        onPressed: () {
          callEmployee();
        },
      ),
    );
  }
}

const myTextStyle =
    TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold);
