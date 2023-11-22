import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/employee.dart';
import 'package:untitled/pages/addpage.dart';
import 'package:untitled/pages/editpage.dart';
import 'package:untitled/services/firebase_crud.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final Stream<QuerySnapshot> employeeRef = FirebaseCrud.readAllEmployee();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext ctx) => AddPage()));
              },
              icon: const Icon(
                Icons.app_registration_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: employeeRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView(
                  children: snapshot.data!.docs.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(e["employeeName"]),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e["position"]),
                                  Text(e["contactno"]),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(10),
                                        foregroundColor: const Color.fromARGB(
                                            255, 144, 233, 255)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext ctx) =>
                                                  EditPage(
                                                      employee: Employee(
                                                    e.id,
                                                    e["employeeName"],
                                                    e["position"],
                                                    e["contactno"],
                                                  ))));
                                    },
                                    child: const Text("Edit"),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(10),
                                        foregroundColor: const Color.fromARGB(
                                            255, 255, 133, 155)),
                                    onPressed: () async {
                                      var response =
                                          await FirebaseCrud.deleteEmployee(
                                              employeeId: e.id);

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(
                                                  response.message.toString()),
                                            );
                                          });
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : const Text(" no data  Available ");
        },
      ),
    );
  }
}
