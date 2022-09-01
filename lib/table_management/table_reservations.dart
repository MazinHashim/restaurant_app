import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/account/account_info.dart';
import 'package:resturant_app/models/reservations_date_source.dart';
import 'package:resturant_app/models/table_instance.dart';
import 'package:resturant_app/models/table_reservations.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/table_management/reservation_filter.dart';
import 'package:resturant_app/widgets/reservation_details_sheet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TableReservations extends StatefulWidget {
  const TableReservations({Key? key}) : super(key: key);

  @override
  State<TableReservations> createState() => _TableReservationsState();
}

class _TableReservationsState extends State<TableReservations> {
  late List<TableInstance> tableInstances;
  late int totalReservations = 0;
  late int totalCustomers = 0;
  late bool isResAccepted;
  late bool doFilter;
  late List<TableReservation> reservations = [];
  late TableProvider provider;
  late int selectedId = 0;
  DateTime viewedDateTime = DateTime.now();
  DateTime today = DateTime.now();
  late DateTimeRange dateRange;

  List<Meeting> _getTableReservations() {
    final List<Meeting> meetings = <Meeting>[];
    for (var table in tableInstances) {
      for (var reservation in table.reservations!) {
        if (reservation.status != 1 || reservation.customer!.status != "late") {
          meetings.add(Meeting(
              reservation.id,
              reservation.customer!.name!,
              reservation.time!,
              reservation.time!.add(const Duration(hours: 3)),
              Colors.green,
              [table.id!],
              false));
        }
      }
    }
    return meetings;
  }

  List<CalendarResource> _getTableTypes() {
    final List<CalendarResource> calendarResources = <CalendarResource>[];
    for (var table in tableInstances) {
      calendarResources.add(CalendarResource(
          id: table.id!, displayName: "1 - ${table.tableType!.quantity}"));
    }
    return calendarResources;
  }

  @override
  void initState() {
    tableInstances = [];
    isResAccepted = false;
    doFilter = false;
    dateRange = DateTimeRange(
        start: today.subtract(const Duration(days: 7)),
        end: today.add(const Duration(days: 7)));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<TableProvider>(context);
    tableInstances = provider.tableInstance;
    getReservationByDate();
    super.didChangeDependencies();
  }

  void getReservationByDate() {
    reservations.clear();
    totalReservations = 0;
    totalCustomers = 0;

    for (var table in tableInstances) {
      reservations.addAll(table.reservations!);
    }
    reservations =
        filterReservationOptions(reservations, ReservationFiler.reserved);
    reservations = reservations.where((res) {
      return res.time!.day == viewedDateTime.day;
    }).toList();
    for (var reservation in reservations) {
      if (reservation.status == 1 && reservation.customer!.status == "late") {
        totalReservations++;
        totalCustomers += reservation.customer!.noOfPeoples!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateLabel = viewedDateTime.day == today.day
        ? "Today"
        : "${viewedDateTime.year}-${viewedDateTime.month}-${viewedDateTime.day}";
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text("Total Reservations of $dateLabel",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  Text("$totalReservations Reservations",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  Text("$totalCustomers Customers",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  const Divider(color: Colors.white, endIndent: 10, indent: 10),
                  const Text(
                    "Upcoming Reservations",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Expanded(
                    child: reservations.isEmpty
                        ? Text(
                            "No Reservation At $dateLabel",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          )
                        : ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (ctx, index) {
                              TableReservation res = reservations[index];
                              TableInstance table = tableInstances.firstWhere(
                                (tab) => tab.reservations!.contains(res),
                              );
                              return reservationsInfoWidget(res, table);
                            }),
                  )
                ],
              ),
            )),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 350,
                      child: ReservationToggler(
                          isResAccepted: isResAccepted,
                          onChange: (value) {
                            setState(() {
                              isResAccepted = value;
                            });
                          }),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                          iconSize: 30,
                          splashColor: Theme.of(context).primaryColor,
                          color: Colors.white,
                          onPressed: () {
                            print(dateRange.start);
                            showDateRangePicker(
                                    context: context,
                                    useRootNavigator: false,
                                    currentDate: today,
                                    initialEntryMode: DatePickerEntryMode.input,
                                    builder: (ctx, wid) {
                                      return SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: wid,
                                      );
                                    },
                                    initialDateRange: dateRange,
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime(2060))
                                .then((dateTimeRange) {
                              setState(() {
                                dateRange = dateTimeRange!;
                              });
                            });
                          },
                          icon: const Icon(Icons.date_range)),
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 200,
                //       child: TextField(
                //         decoration: const InputDecoration(hintText: "Search"),
                //         onChanged: (cname) {
                //           setState(() {
                //             reservations = reservations.where((res) {
                //               return res.time!.day == viewedDateTime.day &&
                //                   res.customer!.name == cname;
                //             }).toList();
                //           });
                //         },
                //       ),
                //     )
                //   ],
                // ),
                Expanded(
                  child: SfCalendar(
                      // allowDragAndDrop: true,
                      showNavigationArrow: true,
                      showDatePickerButton: true,
                      viewNavigationMode: ViewNavigationMode.snap,
                      // allowAppointmentResize: true,
                      appointmentBuilder:
                          (ctx, CalendarAppointmentDetails details) {
                        Meeting meet = details.appointments.first as Meeting;
                        TableInstance table = provider.findTableById(
                            int.parse(meet.resourceIds!.first.toString()));
                        TableReservation res =
                            table.reservations!.firstWhere((res) {
                          return res.id == meet.id;
                        });
                        Color color = (res.status == 0 &&
                                res.customer!.status == "confirmed")
                            ? Colors.green
                            : Theme.of(context).primaryColor;
                        return Container(
                          color: color,
                          child: ListTile(
                            minLeadingWidth: 10,
                            textColor: Colors.white,
                            leading: res.customer!.status == "canceled"
                                ? const Icon(
                                    Icons.cancel,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                            subtitle: Wrap(
                              children: [
                                Text(
                                  res.customer!.name!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "${res.customer!.phone}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "  (${res.customer!.noOfPeoples} Peoples)",
                                  style: const TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      maxDate: dateRange.end,
                      minDate: dateRange.start,
                      viewHeaderStyle: ViewHeaderStyle(
                        backgroundColor: Colors.grey[100],
                      ),
                      onViewChanged: (ViewChangedDetails details) {
                        DateTime date = viewedDateTime;
                        if (details.visibleDates.first.day != date.day) {
                          viewedDateTime = details.visibleDates.first;
                          getReservationByDate();
                          setState(() {});
                          print(viewedDateTime);
                        }
                      },
                      onDragStart: (AppointmentDragStartDetails details) {
                        Meeting meet = details.appointment as Meeting;
                        // TableInstance table = provider.findTableById(
                        //     int.parse(meet.resourceIds!.first.toString()));
                        // TableReservation reservation =
                        //     table.reservations!.firstWhere((res) {
                        //   return res.id == meet.id;
                        // });
                        print(meet.id);
                        // provider.editReservationTime(
                        //     table.id, reservation.id, details.droppingTime!);
                      },
                      onDragEnd: (AppointmentDragEndDetails details) {
                        Meeting meet = details.appointment as Meeting;
                        print(meet.id);
                      },
                      onTap: (CalendarTapDetails details) {
                        if (details.targetElement.name ==
                            CalendarElement.appointment.name) {
                          Meeting meet = details.appointments!.first as Meeting;
                          TableInstance table = provider.findTableById(
                              int.parse(meet.resourceIds!.first.toString()));
                          TableReservation reservation =
                              table.reservations!.firstWhere((res) {
                            return res.id == meet.id;
                          });
                          print("Mazin ${reservation.id}");

                          showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              useRootNavigator: true,
                              builder: (ctx) {
                                return ReservationDetails(
                                    reservation: reservation,
                                    tableInstance: table);
                              });
                        }
                      },
                      resourceViewHeaderBuilder:
                          (ctx, ResourceViewHeaderDetails viewer) {
                        return DecoratedBox(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.table_bar),
                                  Text(viewer.resource.id.toString()),
                                ],
                              ),
                              Text(viewer.resource.displayName),
                            ],
                          ),
                        );
                      },
                      dataSource: MeetingDataSource(
                          _getTableReservations(), _getTableTypes()),
                      view: CalendarView.timelineDay,
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ListTile reservationsInfoWidget(TableReservation res, TableInstance table) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text("${res.time!.hour}:${res.time!.minute}"),
      ),
      textColor: Colors.white,
      selectedColor: Colors.red,
      onTap: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (ctx) {
              return ReservationDetails(reservation: res, tableInstance: table);
            });
      },
      onLongPress: () {
        setState(() {
          selectedId = res.id!;
        });
        TableInstance table = tableInstances.firstWhere((table) {
          return table.reservations!.contains(res);
        });
        provider.confirmReservation(table.id!, selectedId);
      },
      title: Text(res.customer!.name!),
      subtitle: Wrap(
        children: [
          Text("${res.customer!.phone}"),
          Text("${res.customer!.noOfPeoples} Guest / Main Room")
        ],
      ),
      selected: res.id == selectedId ? true : false,
      isThreeLine: true,
    );
  }

  List<TableReservation> filterReservationOptions(
      List<TableReservation> reservations, ReservationFiler filer) {
    switch (filer) {
      case ReservationFiler.all:
        return reservations;
      case ReservationFiler.reserved:
        return reservations
            .where((reservation) => reservation.status == 1)
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
