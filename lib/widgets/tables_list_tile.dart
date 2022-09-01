import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_seats.dart';
import 'package:resturant_app/providers/tables_provider.dart';

class TablesListTile extends StatefulWidget {
  const TablesListTile(
      {Key? key, required this.tableTypes, required this.index})
      : super(key: key);
  final int index;
  final List<TableSeats> tableTypes;

  @override
  State<TablesListTile> createState() => _TablesListTileState();
}

class _TablesListTileState extends State<TablesListTile> {
  void incrementCounter(TableProvider provider) {
    provider.addTableInstance(
        TableInstance(Random().nextInt(500), widget.tableTypes[widget.index]));
  }

  void decrementCounter(TableProvider provider, TableSeats table) {
    provider.removeTableInstance(table);
  }

  @override
  Widget build(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context);
    return ListTile(
      title: Text(widget.tableTypes[widget.index].tableType!),
      dense: true,
      subtitle: Text(
          "Table that contains ${widget.tableTypes[widget.index].maxSeats!} seat${widget.tableTypes[widget.index].maxSeats != 1 ? 's' : ''}"),
      trailing: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(blurRadius: 2, color: Colors.grey)
                  ]),
              child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    decrementCounter(provider, widget.tableTypes[widget.index]);
                  },
                  icon: const Icon(Icons.remove)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                provider.tableTypes[widget.index].quantity.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(blurRadius: 2, color: Colors.grey)
                  ]),
              child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    incrementCounter(provider);
                  },
                  icon: const Icon(Icons.add)),
            ),
          ],
        ),
      ),
    );
  }
}
