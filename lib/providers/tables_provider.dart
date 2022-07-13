import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/customer.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/models/table_seats.dart';

class TableProvider extends ChangeNotifier {
  final List<TableSeats> _tableTypes = [
    TableSeats(1, "Extra Large", 3, 12),
    TableSeats(2, "Large", 2, 8),
    TableSeats(3, "Mideum", 0, 5),
    TableSeats(4, "Small", 1, 2)
  ];
  final List<TableInstance> _tableInstance = [];

  TableProvider() {
    _tableInstance.addAll([
      TableInstance(1, tableTypes[0]),
      TableInstance(2, tableTypes[0]),
      TableInstance(3, tableTypes[0]),
      TableInstance(4, tableTypes[1]),
      TableInstance(5, tableTypes[1]),
      TableInstance(6, tableTypes[3])
    ]);
    for (TableInstance table in _tableInstance) {
      table.reservations!.addAll([
        TableReservation(Random().nextInt(500), DateTime.now(), 1),
        TableReservation(Random().nextInt(500), DateTime.now(), 1)
      ]);

      for (TableReservation reservation in table.reservations!) {
        reservation.customer = Customer(
            Random().nextInt(500),
            "Captin Hema",
            "+249965414756",
            "pic",
            ["Rice", "Hotdog", "Rice", "Hotdog", "Rice", "Hotdog"],
            5,
            3,
            "late");
      }
    }
  }
  List<TableSeats> get tableTypes {
    return [..._tableTypes];
  }

  List<TableInstance> get tableInstance {
    return [..._tableInstance];
  }

  TableInstance findTableById(int id) {
    return _tableInstance.firstWhere((table) => table.id == id);
  }

  TableReservation cancelReservation(int tableId, int id) {
    TableInstance table = findTableById(tableId);
    TableReservation reservation =
        table.reservations!.firstWhere((reservation) => reservation.id == id);
    reservation.status = 0;
    reservation.customer!.status = "canceled";
    notifyListeners();
    return reservation;
  }

  void leftResaurant(int tableId, int id) {
    TableReservation reservation = cancelReservation(tableId, id);
    reservation.customer!.status = "confirmed";
    notifyListeners();
  }

  void confirmReservation(int tableId, int id) {
    TableInstance table = findTableById(tableId);
    TableReservation reservation =
        table.reservations!.firstWhere((reservation) => reservation.id == id);
    reservation.status = 2;
    reservation.customer!.status = "confirmed";
    notifyListeners();
  }

  void addTableType(TableSeats tableSeats) {
    _tableTypes.add(tableSeats);
    notifyListeners();
  }

  void addTableInstance(TableInstance tableInstance) {
    _tableInstance.add(tableInstance);
    tableInstance.tableType!.quantity = tableInstance.tableType!.quantity! + 1;
    notifyListeners();
  }

  void removeTableInstance(TableSeats tableType) {
    if (tableType.quantity! > 0) {
      TableInstance table = _tableInstance.firstWhere((TableInstance tb) {
        return tableType.id == tb.tableType!.id && tb.reservations!.isEmpty;
      });
      _tableInstance.remove(table);
      table.tableType!.quantity = table.tableType!.quantity! - 1;
    }
    notifyListeners();
  }

  List<int> countOfReservation(List<TableInstance>? tables) {
    int count = 0;
    int resCount = 0;
    int emCount = 0;
    tables?.forEach((table) {
      for (TableReservation reservation in table.reservations!) {
        if ([1, 2].contains(reservation.status)) {
          resCount++;
        } else if (reservation.status == 0) {
          emCount++;
        }
        count++;
      }
    });
    return [resCount, emCount, count];
  }
}
