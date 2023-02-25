import 'package:flutter/material.dart';

import '../../model_api/Preparation/getpreparationSchedule.dart';
import '../../model_api/fgDetail_model.dart';
import '../../service/apiService.dart';

class P3ScheduleDetailWIP extends StatefulWidget {
  PreparationSchedule schedule;

  P3ScheduleDetailWIP({required this.schedule});
  @override
  _P3ScheduleDetailWIPState createState() => _P3ScheduleDetailWIPState();
}

class _P3ScheduleDetailWIPState extends State<P3ScheduleDetailWIP> {
  late ApiService apiService;
  @override
  void initState() {
    apiService = ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        clipBehavior: Clip.antiAlias, // Add This
        shadowColor: Colors.white70,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 95,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                scheduleDetail(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 0,
                ),
                Container(child: fGTable()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget feild({required String heading, required String value, required double width}) {
    width = MediaQuery.of(context).size.width * width;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        // color: Colors.red.shade100,
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                Text(heading,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                  children: [
                    Container(
                      width: width,
                      child: Text(
                        "${value}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget scheduleDetail() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        feild(heading: "Order Id", value: widget.schedule.orderId.toString(), width: 0.1),
        feild(
            heading: "FG Part", value: widget.schedule.finishedGoodsNumber.toString(), width: 0.1),
        feild(heading: "Schedule ID", value: widget.schedule.scheduledId.toString(), width: 0.1),
        feild(
            heading: "Cable Part No.",
            value: widget.schedule.cablePartNumber.toString(),
            width: 0.10),
        feild(heading: "Process", value: widget.schedule.process.toString(), width: 0.18),
        feild(heading: "Cut Length", value: "${widget.schedule.length}".toString(), width: 0.07),
        feild(heading: "Color", value: "${widget.schedule.color.toString()}", width: 0.06),
        // feild(
        //     heading: "Scheduled Qty",
        //     value: "${widget.schedule.scheduledQuantity.toString()??''}",
        //     width: 0.1),
        // feild(heading: "Schedule", value: "null", width: 0.1)
      ],
    ));
  }

  Widget fGTable() {
    Widget boxes(
      String str1,
      String str2,
    ) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          // color: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              str1,
              style: TextStyle(fontSize: 10),
            ),
            Text(str2,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.black)),
          ]),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder(
            future: apiService.getFgDetails(widget.schedule.finishedGoodsNumber ?? ''),
            builder: (context, snapshot) {
              print('fg number ${widget.schedule.finishedGoodsNumber}');
              FgDetails? fgDetail = snapshot.data as FgDetails?;
              if (snapshot.hasData) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    // color: Colors.grey.shade200,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      feild(
                          heading: "FG Description",
                          value: "${fgDetail!.fgDescription}",
                          width: 0.33),
                      feild(
                          heading: "FG Scheduled Date",
                          value: "${fgDetail.fgScheduleDate ?? ''}",
                          width: 0.12),
                      feild(heading: "Customer", value: "${fgDetail.customer}", width: 0.15),
                      feild(heading: "Drg Rev", value: "${fgDetail.drgRev}", width: 0.05),
                      feild(
                          heading: "Cable Serial No",
                          value: "${fgDetail.cableSerialNo.toString()}",
                          width: 0.09),
                      feild(heading: 'Tolerance ', value: '${fgDetail.tolrance}', width: 0.1),
                    ]));
              } else {
                return Container();
              }
            }));
  }
}
