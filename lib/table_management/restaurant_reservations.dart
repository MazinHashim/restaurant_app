import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/table_management/reservation_filter.dart';
import 'package:resturant_app/table_management/table_shape.dart';

class RestaurantReservations extends StatelessWidget {
  const RestaurantReservations({Key? key, this.filter}) : super(key: key);
  final ReservationFiler? filter;

  static const routeName = "/new_reservations";
  @override
  Widget build(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context);

    List<TableInstance> tableInstances = provider.tableInstance;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: Colors.black),
          title: Text(filter == ReservationFiler.empty
              ? "History"
              : "New Reservations"),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: tableInstances.length,
          itemBuilder: (ctx, i) {
            return TableShape(
              tableInstance: tableInstances[i],
              reservationFiler: filter!,
            );
          },
        ));
  }
}
