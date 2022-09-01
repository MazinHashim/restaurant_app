import 'package:flutter/material.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/table_management/reservation_filter.dart';
import 'package:resturant_app/widgets/reservation_details_sheet.dart';

class TableShape extends StatelessWidget {
  const TableShape({
    Key? key,
    required this.tableInstance,
    required this.reservationFiler,
  }) : super(key: key);

  final TableInstance tableInstance;
  final ReservationFiler reservationFiler;

  @override
  Widget build(BuildContext context) {
    double tableWidth = MediaQuery.of(context).size.width /
            20 *
            tableInstance.tableType!.maxSeats! +
        tableInstance.tableType!.maxSeats! * 2;

    tableWidth = tableWidth < 100 ? 100 : tableWidth;

    List<TableReservation> reservations =
        filterReservationOptions(tableInstance.reservations!, reservationFiler);
// Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 InkWell(
//                     onTap: () {
//                       reservations = filterReservationOptions(
//                           tableInstance.reservations!, ReservationFiler.all);
//                     },
//                     child: const Chip(label: Text("All"))),
//                 InkWell(onTap: () {
//                   reservations = filterReservationOptions(
//                           tableInstance.reservations!, ReservationFiler.empty);
//                 }, child: const Chip(label: Text("Empty"))),
//                 InkWell(
//                     onTap: () {
//                       reservations = filterReservationOptions(
//                           tableInstance.reservations!, ReservationFiler.occupied);
//                     }, child: const Chip(label: Text("Occupied"))),
//                 InkWell(
//                     onTap: () {
//                       reservations = filterReservationOptions(
//                           tableInstance.reservations!, ReservationFiler.reserved);
//                     }, child: const Chip(label: Text("Reserved"))),
//               ]),
    return reservations.isEmpty
        ? Center(
            child: Text(
                "No Customer Reservation for ${tableInstance.tableType!.tableType} Type"))
        : Column(
            children: List.generate(
            reservations.length,
            (index) {
              return InkWell(
                onTap: () {
                  showBottomSheet(
                      context: context,
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      elevation: 20,
                      builder: (ctx) {
                        return ReservationDetails(
                            reservation: reservations[index],
                            tableInstance: tableInstance);
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey, spreadRadius: 2, blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          (tableInstance.tableType!.maxSeats! / 2).floor(),
                          (_) => Icon(Icons.chair_alt,
                              color: reservations[index].status == 2
                                  ? Colors.green
                                  : reservations[index].status == 1
                                      ? Colors.amber
                                      : Colors.red)),
                    ),
                    const Divider(indent: 4),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          boxShadow: [
                            BoxShadow(
                                blurStyle: BlurStyle.outer,
                                blurRadius: 2,
                                spreadRadius: 3)
                          ]),
                      height: 50,
                      width: tableWidth,
                      child: Center(
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 100,
                          children: [
                            Text(
                              reservations[index].status! == 2
                                  ? "Occupied"
                                  : reservations[index].status! == 0
                                      ? "Empty"
                                      : "At ${reservations[index].time!.hour}:${reservations[index].time!.minute}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                                "${tableInstance.tableType!.maxSeats!.toString()} Chairs",
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(indent: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          (tableInstance.tableType!.maxSeats! / 2).round(),
                          (_) => Icon(Icons.chair_alt,
                              color: reservations[index].status == 2
                                  ? Colors.green
                                  : reservations[index].status == 1
                                      ? Colors.amber
                                      : Colors.red)),
                    ),
                  ]),
                ),
              );
            },
          ));
  }

  List<TableReservation> filterReservationOptions(
      List<TableReservation> reservations, ReservationFiler filer) {
    switch (filer) {
      case ReservationFiler.all:
        return reservations;
      case ReservationFiler.reserved:
        return reservations
            .where((reservation) =>
                reservation.status == 1 || reservation.status == 2)
            .toList();
      case ReservationFiler.empty:
        return reservations
            .where((reservation) =>
                reservation.status == 0 &&
                reservation.customer!.status == "confirmed")
            .toList();
      case ReservationFiler.occupied:
        return reservations
            .where((reservation) => reservation.status == 2)
            .toList();
    }
  }
}
