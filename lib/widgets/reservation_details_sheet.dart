import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/providers/tables_provider.dart';

class ReservationDetails extends StatelessWidget {
  const ReservationDetails({
    Key? key,
    required this.reservation,
    required this.tableInstance,
  }) : super(key: key);

  final TableReservation reservation;
  final TableInstance tableInstance;

  @override
  Widget build(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          width: MediaQuery.of(context).size.width / 3,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img/logo.png'),
                    radius: 25,
                  ),
                  title: Text(reservation.customer!.name!),
                  subtitle: Text(
                    "${reservation.customer!.visitCount!} Prevoius Reservations",
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: reservation.customer!.status == "late"
                        ? Colors.amber
                        : reservation.customer!.status == "confirmed"
                            ? Colors.green
                            : Colors.red,
                    radius: 5,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  horizontalTitleGap: -10,
                  title: Text("Phone number: ${reservation.customer!.phone!}",
                      textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  horizontalTitleGap: -10,
                  title: Text(
                      "Group of ${reservation.customer!.noOfPeoples!} peoples",
                      textAlign: TextAlign.start),
                ),
                const ListTile(
                    leading: Icon(Icons.menu_open),
                    horizontalTitleGap: -10,
                    title:
                        Text("List of food order", textAlign: TextAlign.start)),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (con, j) => const VerticalDivider(
                          width: 4, indent: 20, endIndent: 20),
                      itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Chip(
                              elevation: 5,
                              backgroundColor: Colors.white,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              label: Text(
                                  reservation.customer!.foodPreferences![i]),
                            ),
                          ),
                      itemCount: reservation.customer!.foodPreferences!.length),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if ([1, 2].contains(reservation.status))
                      TextButton.icon(
                          label: Text(
                            reservation.status == 2 ? "Left" : "Cancel",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(20),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            if (reservation.status == 1) {
                              provider.cancelReservation(
                                  tableInstance.id!, reservation.id!);
                            } else {
                              provider.leftResaurant(
                                  tableInstance.id!, reservation.id!);
                            }
                          },
                          icon: Icon(
                            reservation.status == 2
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: Colors.white,
                          )),
                    if (reservation.status == 1)
                      TextButton.icon(
                          label: const Text(
                            "Arrvied",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            provider.confirmReservation(
                                tableInstance.id!, reservation.id!);
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(20),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          )),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: reservation.customer!.status == "late"
                        ? Colors.amber
                        : reservation.customer!.status == "confirmed"
                            ? Colors.green
                            : Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "Customer Status ${reservation.customer!.status!.toUpperCase()}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
