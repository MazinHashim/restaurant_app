import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_seats.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/table_management/tables_manage.dart';
import 'package:resturant_app/widgets/tables_list_tile.dart';

class TableList extends StatelessWidget {
  TableList({Key? key, this.tableTypes}) : super(key: key);
  late List<TableSeats>? tableTypes;

  static const routeName = "/table_list";

  @override
  Widget build(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context, listen: true);
    tableTypes = provider.tableTypes;
    List<TableInstance> tableInstances =
        Provider.of<TableProvider>(context).tableInstance;
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.add),
          onPressed: () {
            provider.addTableType(
                TableSeats(Random().nextInt(500), "Extra Small", 0, 1));
          }),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: provider.tableTypes.length,
        itemBuilder: (ctx, index) {
          List<TableInstance>? tables = tableInstances
              .where((TableInstance table) =>
                  table.tableType!.id == tableTypes![index].id)
              .toList();
          List<int> counters = provider.countOfReservation(tables);

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 2)
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Column(children: [
              TablesListTile(tableTypes: tableTypes!, index: index),
              const Divider(indent: 4),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: const [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 2,
                          spreadRadius: 3)
                    ]),
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Reservations ${counters[0]}/${counters[2]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(TableManagement.routeName, arguments: {
                          "tableInstances": tables,
                          "type": tableTypes![index].tableType
                        });
                      },
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20.0),
                          child: Text(
                            "View",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
