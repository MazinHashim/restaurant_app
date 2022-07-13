import 'package:resturant_app/models/customer.dart';

class TableReservation {
  int? _id;
  DateTime? _time;
  int? _status;
  Customer? _customer;

  TableReservation(int? id, DateTime? time, int? status) {
    if (id != null) {
      _id = id;
    }
    if (time != null) {
      _time = time;
    }
    if (status != null) {
      _status = status;
    }
  }

  int? get status => _status!;
  set status(int? status) => _status = status;

  DateTime? get time => _time!;
  set time(DateTime? time) => _time = time;

  int? get id => _id!;
  set id(int? id) => _id = id;

  Customer? get customer => _customer!;
  set customer(Customer? customer) => _customer = customer;
}
