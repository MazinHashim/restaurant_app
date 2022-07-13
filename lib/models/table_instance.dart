import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/models/table_seats.dart';

class TableInstance {
  int? _id;
  TableSeats? _tableType;
  List<TableReservation>? _reservations;

  TableInstance(int? id, TableSeats? tableType) {
    if (id != null) {
      _id = id;
    }
    if (tableType != null) {
      _tableType = tableType;
    }
    _reservations = [];
  }

  TableSeats? get tableType => _tableType!;
  set tableType(TableSeats? tableType) => _tableType = tableType;

  List<TableReservation>? get reservations => _reservations!;
  set reservations(List<TableReservation>? reservations) =>
      _reservations = reservations;

  int? get id => _id!;
  set id(int? id) => _id = id;
}
