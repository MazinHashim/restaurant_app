import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/customer.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/models/table_seats.dart';

class TableProvider extends ChangeNotifier {
  final List<TableSeats> _tableTypes = [
    TableSeats(1, "Extra Large", 3, 8),
    TableSeats(2, "Large", 2, 6),
    TableSeats(3, "Mideum", 0, 4),
    TableSeats(4, "Small", 1, 2),
    TableSeats(4, "Extra Small", 1, 1)
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
      int reservationId1 = Random().nextInt(1000);
      int reservationId2 = Random().nextInt(1000);
      int reservationId3 = Random().nextInt(1000);
      table.reservations!.addAll([
        TableReservation(
            reservationId1,
            DateTime.now()
                .subtract(Duration(hours: (reservationId1 / 1000).round())),
            1),
        TableReservation(
            reservationId2,
            DateTime.now()
                .subtract(Duration(hours: (reservationId2 / 100).round())),
            1),
        TableReservation(
            reservationId3,
            DateTime.now()
                .add(const Duration(days: 1))
                .subtract(Duration(hours: (reservationId3 / 100).round())),
            1)
      ]);

      for (TableReservation reservation in table.reservations!) {
        int customerId = Random().nextInt(500);
        reservation.customer = Customer(
            customerId,
            "Captin Hema ${reservation.id}",
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

  TableReservation findReservationById(TableInstance table, int id) {
    return table.reservations!
        .firstWhere((reservation) => reservation.id == id);
  }

  TableReservation cancelReservation(int tableId, int id) {
    TableInstance table = findTableById(tableId);
    TableReservation reservation = findReservationById(table, id);
    reservation.status = 0;
    reservation.customer!.status = "canceled";
    notifyListeners();
    return reservation;
  }

  void leftResaurant(int tableId, int id) {
    TableInstance table = findTableById(tableId);
    TableReservation reservation = findReservationById(table, id);
    reservation.status = 0;
    reservation.customer!.status = "confirmed";
    notifyListeners();
  }

  void confirmReservation(int tableId, int id) {
    TableInstance table = findTableById(tableId);
    TableReservation reservation = findReservationById(table, id);
    reservation.status = 2;
    reservation.customer!.status = "confirmed";
    notifyListeners();
  }

  void addTableType(TableSeats tableSeats) {
    _tableTypes.add(tableSeats);
    notifyListeners();
  }

  void addTableInstance(TableInstance tableInstance) {
    if (tableInstance.tableType!.quantity! < 10) {
      _tableInstance.add(tableInstance);
      tableInstance.tableType!.quantity =
          tableInstance.tableType!.quantity! + 1;
    }
    notifyListeners();
  }

  void removeTableInstance(TableSeats tableType) {
    if (tableType.quantity! > 0) {
      TableInstance table = _tableInstance.firstWhere((TableInstance tb) {
        List<TableReservation> vations =
            tb.reservations!.where((TableReservation res) {
          return res.status == 1;
        }).toList();
        print("Contains : ${vations.length} ${vations.isEmpty}");
        return tableType.id == tb.tableType!.id && vations.isEmpty;
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

  void editReservationTime(int? tableId, int? resId, DateTime newTime) {
    TableInstance table = findTableById(tableId!);
    TableReservation reservation = findReservationById(table, resId!);
    reservation.time = newTime;
    notifyListeners();
  }
}
