import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _collection = _firestore.collection("Employee");

class FirebaseCrud {
  static Future<Response> addEmpolyee({
    required String employeeName,
    required String position,
    required String contactno,
  }) async {
    Response response = Response(code: 2, message: "message");

    DocumentReference documentReference = _collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "employeeName": employeeName,
      "position": position,
      "contactno": contactno
    };

    await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Employee Added Successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Stream<QuerySnapshot> readAllEmployee() {
    CollectionReference collectionReference = _collection;

    return collectionReference.snapshots();
  }

  static Future<Response> deleteEmployee({required String employeeId}) async {
    Response response = Response(code: 2, message: "message");
    DocumentReference documentReference = _collection.doc(employeeId);
    await documentReference.delete().whenComplete(() {
      response.code = 200;
      response.message = "Employee Deleted";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> updateEmpolyee({
    required String uid,
    required String employeeName,
    required String position,
    required String contactno,
  }) async {
    Response response = Response(code: 2, message: "message");

    DocumentReference documentReference = _collection.doc(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "employeeName": employeeName,
      "position": position,
      "contactno": contactno
    };

    await documentReference.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Employee Updated Successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }
}
