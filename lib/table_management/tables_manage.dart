import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/table_management/reservation_filter.dart';
import 'package:resturant_app/table_management/table_shape.dart';

class TableManagement extends StatelessWidget {
  const TableManagement({Key? key, this.tableInstances}) : super(key: key);
  final List<TableInstance>? tableInstances;

  static const routeName = "/table_management";

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context)!.settings.arguments as Map;
    List<TableInstance>? tableInstances =
        map["tableInstances"] as List<TableInstance>;

    TableProvider provider = Provider.of<TableProvider>(context);
    List<int> counters = provider.countOfReservation(tableInstances);
    return Scaffold(
      appBar: AppBar(title: Text(map["type"])),
      body: tableInstances.isEmpty
          ? Center(child: Text("No Avialable Tables for ${map["type"]} Type"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.all(12.0),
                          decoration: const BoxDecoration(
                              color: Colors.amber,
                              boxShadow: [
                                BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 2,
                                    spreadRadius: 3)
                              ]),
                          child: Text("Reservied ${counters[0]}/${counters[2]}",
                              style: const TextStyle(color: Colors.white))),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.all(12.0),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 2,
                                    spreadRadius: 3)
                              ]),
                          child: Text(
                            "Empty ${counters[1]}/${counters[2]}",
                            style: const TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: tableInstances.length,
                    itemBuilder: (ctx, index) {
                      return TableShape(
                        tableInstance: tableInstances[index],
                        reservationFiler: ReservationFiler.all,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
