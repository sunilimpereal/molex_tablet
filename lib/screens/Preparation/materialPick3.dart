// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import '../../model_api/Preparation/getpreparationSchedule.dart';
// import '../../model_api/machinedetails_model.dart';
// import '../../model_api/rawMaterial_modal.dart';
// import '../../model_api/schedular_model.dart';
// import '../../models/materialItem.dart';
// import '../widgets/time.dart';
// import '../../service/apiService.dart';

// class MaterialPickOp3 extends StatefulWidget {
//   PreparationSchedule schedule;
//   String userId;
//   MachineDetails machine;
//   MaterialPickOp3({required this.userId, required this.machine, required this.schedule});
//   @override
//   _MaterialPickOp3State createState() => _MaterialPickOp3State();
// }

// class _MaterialPickOp3State extends State<MaterialPickOp3> {
//   TextEditingController _partNumberController = new TextEditingController();
//   TextEditingController _trackingNumberController = new TextEditingController();
//   TextEditingController _qtyController = new TextEditingController();
//   FocusNode _textNode = new FocusNode();
//   FocusNode _trackingNumber = new FocusNode();
//   FocusNode _qty = new FocusNode();
//   late String partNumber;
//   late String trackingNumber;
//   late String qty;
//   List<ItemPart> items = [];
//   List<ItemPart> selectditems = [];
//   bool isCollapsedRawMaterial = false;
//   bool isCollapsedScannedMaterial = false;
//   DateTime selectedDate = DateTime.now();
//    List<RawMaterial> rawMaterial = [];
//    late ApiService apiService;
//   @override
//   void initState() {
//      apiService = new ApiService();
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     _textNode.requestFocus();
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     Future.delayed(
//       const Duration(milliseconds: 100),
//       () {
//         SystemChannels.textInput.invokeMethod(keyboardType);
//       },
//     );
//     items.add(ItemPart(
//       description: "1X20AWG DISC PVC OR 1.8MM UL 1569 HOOKUP",
//       partNo: "884538504",
//       uom: "M",
//       oty: "2.5",
//       schQty: "1.7",
//     ));
  
//     super.initState();
//   }

//   triggerCollapseRawMaterial() {
//     setState(() {
//       isCollapsedRawMaterial = !isCollapsedRawMaterial;
//     });
//   }

//   triggerCollapseScannedMaterial() {
//     setState(() {
//       isCollapsedScannedMaterial = !isCollapsedScannedMaterial;
//     });
//   }

//   onSelectedRow(bool selected, ItemPart document) async {
//     setState(() {
//       if (selected) {
//         selectditems.add(document);
//       } else {
//         selectditems.remove(document);
//       }
//     });
//   }

//   void checkPartNumber(String pn) {
//     setState(() {
//       if (pn?.length == 9) {}
//     });
//   }

//   void checkTrackNumber(String trackNumber) {
//     setState(() {
     
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final node = FocusScope.of(context);
//     // if (!_qty.hasFocus && partNumber != null) {
//     //   checkPartNumber(partNumber);
//     //   checkTrackNumber(trackingNumber);
//     // }
//     if(!_qty.hasFocus){
//          SystemChannels.textInput.invokeMethod(keyboardType);
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(
//           color: Colors.red,
//         ),
//         title: const Text(
//           'Material',
//           style: TextStyle(color: Colors.red),
//         ),
//         elevation: 0,
//       actions: [
    
//           //machineID
//           Container(
//             padding: EdgeInsets.all(1),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.all(Radius.circular(100)),
//                       ),
//                       child: Center(
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Icon(
//                               Icons.person,
//                               size: 18,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                           Text(
//                             widget.userId,
//                             style: TextStyle(fontSize: 13, color: Colors.black),
//                           ),
//                         ],
//                       )),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.all(Radius.circular(100)),
//                       ),
//                       child: Center(
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Icon(
//                               Icons.settings,
//                               size: 18,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                           Text(
//                             widget.machine.machineNumber ?? "",
//                             style: TextStyle(fontSize: 13, color: Colors.black),
//                           ),
//                         ],
//                       )),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),

//           TimeDisplay(),
       
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             //Shift and machineId
//             Divider(
//               color: Colors.redAccent,
//               thickness: 2,
//             ),
//             tableHeading(),
//             buildDataRow(schedule: widget.schedule),

//             //Raw material
//             buildDataRawMaterial(),
//             Divider(
//               color: Colors.red.shade100,
//               thickness: 2,
//             ),

//             //Selected material
//             showSelectedRawMaterial(),

//             //Proceed to Process Button
//             Container(
//               height: 100,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget scannerInput() {
//     final node = FocusScope.of(context);
//     double width = MediaQuery.of(context).size.width * 0.8;
//     return Row(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//           height: 50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               //Part Number
//               RawKeyboardListener(
//                 focusNode: FocusNode(),
//                 onKey: (event) => handleKey(event.data),
//                 child: Container(
//                     height: 40,
//                     width: width * 0.25,
//                     child: TextField(
//                       textInputAction: TextInputAction.newline,
//                       controller: _partNumberController,
//                       autofocus: true,
//                       focusNode: _textNode,
//                       onSubmitted: (value) {
//                         for (ItemPart ip in items) {
//                           if (ip.partNo == value) {
//                             if (!selectditems.contains(ip)) {
//                               _trackingNumber.requestFocus();
//                               Future.delayed(
//                                 const Duration(milliseconds: 100),
//                                 () {
//                                   SystemChannels.textInput
//                                       .invokeMethod(keyboardType);
//                                 },
//                               );
//                             }
//                           }
//                         }
//                       },
//                       onChanged: (value) {
//                         setState(() {
//                           partNumber = value;
//                         });
//                       },
//                       onTap: () {
//                         SystemChannels.textInput.invokeMethod(keyboardType);
//                       },
//                       decoration: new InputDecoration(
//                         labelText: "Part No.",
//                         fillColor: Colors.white,
//                         border: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(5.0),
//                           borderSide: new BorderSide(),
//                         ),
//                         //fillColor: Colors.green
//                       ),
//                     )),
//               ),
//               // Tracking Number
//               RawKeyboardListener(
//                 focusNode: FocusNode(),
//                 onKey: (event) => handleKey(event.data),
//                 child: Container(
//                     height: 40,
//                     width: width * 0.25,
//                     child: TextField(
//                       controller: _trackingNumberController,
//                       onSubmitted: (value) async {
//                         trackingNumber = value;
//                         final DateTime picked = await showDatePicker(
//                           context: context,
//                           initialDate: selectedDate, // Refer step 1
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2025),
//                         );
//                         if (picked != null && picked != selectedDate)
//                           setState(() {
//                             selectedDate = picked;
//                             Future.delayed(
//                               const Duration(milliseconds: 100),
//                               () {
//                                 SystemChannels.textInput
//                                     .invokeMethod(keyboardType);
//                               },
//                             );
//                           });
//                         _qty.requestFocus();
//                       },
//                       onChanged: (value) {
//                         trackingNumber = value;
//                       },
//                       focusNode: _trackingNumber,
//                       decoration: new InputDecoration(
//                         labelText: "Tracebility Number",
//                         fillColor: Colors.white,
//                         border: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(5.0),
//                           borderSide: new BorderSide(),
//                         ),
//                         //fillColor: Colors.green
//                       ),
//                     )),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   final DateTime picked = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate, // Refer step 1
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2025),
//                   );
//                   if (picked != null && picked != selectedDate)
//                     setState(() {
//                       selectedDate = picked;
//                       Future.delayed(
//                         const Duration(milliseconds: 100),
//                         () {
//                           SystemChannels.textInput
//                               .invokeMethod(keyboardType);
//                         },
//                       );
//                     });
//                 },
//                 child: Container(
//                   height: 50,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.event,
//                         color: Colors.grey,
//                         size: 25,
//                       ),
//                       Text(
//                         "${selectedDate.toLocal()}".split(' ')[0],
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               RawKeyboardListener(
//                 focusNode: FocusNode(),
//                 onKey: (event) => {},
//                 child: Container(
//                   height: 40,
//                   width: width * 0.15,
//                   child: TextField(
//                     controller: _qtyController,
//                     onTap: () {
//                       SystemChannels.textInput.invokeMethod('TextInput.show');
//                     },
//                     focusNode: _qty,
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       qty = value;
//                     },
//                     decoration: new InputDecoration(
//                       labelText: "Qty",
//                       fillColor: Colors.white,
//                       border: new OutlineInputBorder(
//                         borderRadius: new BorderRadius.circular(5.0),
//                         borderSide: new BorderSide(),
//                       ),
//                       //fillColor: Colors.green
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 40,
//                 width: width * 0.18,
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                         (Set<MaterialState> states) {
//                           if (states.contains(MaterialState.pressed))
//                             return Colors.green.shade200;
//                           return Colors
//                               .blue.shade500; // Use the component's default.
//                         },
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         for (ItemPart ip in items) {
//                           if (ip.partNo == partNumber) {
//                             if (!selectditems.contains(ip)) {
//                               ip.date =
//                                   "${selectedDate.toLocal()}".split(' ')[0];
//                               selectditems.add(ip);
//                               _partNumberController.clear();
//                               _trackingNumberController.clear();
//                               _qtyController.clear();
//                               partNumber = null;
//                               trackingNumber = null;
//                               qty = null;
//                               _textNode.requestFocus();
//                               Future.delayed(
//                                 const Duration(milliseconds: 100),
//                                 () {
//                                   SystemChannels.textInput
//                                       .invokeMethod(keyboardType);
//                                 },
//                               );
//                             }
//                           }
//                         }
//                       });
//                     },
//                     child: Text('Add')),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           height: 40,
//           width: 180,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 4,
//               primary: Colors.green, // background
//               onPrimary: Colors.white,
//             ),
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //       builder: (context) => Processpage3(
//               //             schedule: widget.schedule,
//               //             userId: widget.userId,
//               //             machine: widget.machine,
//               //           )),
//               // );
//             },
//             child: Text(
//               'Strat Process',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   handleKey(RawKeyEventData key) {
//     setState(() {
//       SystemChannels.textInput.invokeMethod(keyboardType);
//     });
//   }

//   // to Show the raw material required
//   Widget buildDataRawMaterial() {

//         return FutureBuilder(
//         future: apiService.rawMaterial(
//             machineId: widget.machine.machineNumber,
//             fgNo: widget.schedule.finishedGoodsNumber,
//             scheduleId: widget.schedule.scheduledId, partNo: '', type: ''),
//         // 'EMU-M/C-038B', '367760913', '367870011', '1223445'),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<RawMaterial> rawmaterial = snapshot.data;
           

//             rawMaterial = snapshot.data;
//     return Container(
//       child: Column(
//         children: [
//           // heading
//           SizedBox(height: 0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(width: 20),
//               GestureDetector(
//                 onTap: () {
//                   triggerCollapseRawMaterial();
//                 },
//                 child: Text(
//                   'Raw material Scan',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                       icon: isCollapsedRawMaterial
//                           ? Icon(Icons.keyboard_arrow_down)
//                           : Icon(Icons.keyboard_arrow_up),
//                       onPressed: () {
//                         triggerCollapseRawMaterial();
//                       })
//                 ],
//               )
//             ],
//           ),
//           // scrollView
//           (() {
//             if (!isCollapsedRawMaterial) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.all(2),
//                 child: DataTable(
//                     columns: const <DataColumn>[
//                       DataColumn(
//                         label: Text(
//                           'Part No.',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Description',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'UOM',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'REQ Qty/PC',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Total SCh Qty',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                     rows: rawmaterial
//                         .map((e) => DataRow(cells: <DataCell>[
//                               DataCell(Text(
//                                 e.partNunber,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.description,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.uom,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.uom,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.toatalScheduleQuantity,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                             ]))
//                         .toList()),
//               );
//             } else {
//               return Container();
//             }
//           }()),
//         ],
//       ),
//     );
//           }
//         }
//         );

//   }

//   // To Show the scanned products with quantity
//   Widget showSelectedRawMaterial() {
//     return Container(
//       child: Column(
//         children: [
//           scannerInput(),
//           //Heading
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(width: 20),
//               GestureDetector(
//                 onTap: () {
//                   triggerCollapseScannedMaterial();
//                 },
//                 child: Text(
//                   'Scanned Materials',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                       icon: isCollapsedScannedMaterial
//                           ? Icon(Icons.keyboard_arrow_down)
//                           : Icon(Icons.keyboard_arrow_up),
//                       onPressed: () {
//                         triggerCollapseScannedMaterial();
//                       })
//                 ],
//               )
//             ],
//           ),

//           // Table
//           (() {
//             if (!isCollapsedScannedMaterial) {
//               return Container(
//                 color: Colors.transparent,
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.all(4),
//                 child: DataTable(
//                     columnSpacing: 20,
//                     columns: const <DataColumn>[
//                       DataColumn(
//                         label: Text(
//                           'PART NO.',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'DESCRIPTION',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'TRACEBILITY',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'DATE',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'UOM',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'EXIST QTY	',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'SCANNED QTY',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Delete',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                     rows: selectditems
//                         .map((e) => DataRow(cells: <DataCell>[
//                               DataCell(Text(
//                                 e.partNo,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.description,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.partNo,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(
//                                 e.date,
//                                 style: TextStyle(fontSize: 12),
//                               )),
//                               DataCell(Text(e.uom)),
//                               DataCell(Text("25.5")),
//                               DataCell(Text("30")),
//                               DataCell(IconButton(
//                                 icon: Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                                 onPressed: () {
//                                   selectditems.remove(e);
//                                 },
//                               )),
//                             ]))
//                         .toList()),
//               );
//             } else {
//               return Container();
//             }
//           }())
//         ],
//       ),
//     );
//   }

//   Widget tableHeading() {
//     double width = MediaQuery.of(context).size.width;
//     Widget cell(String name, double d) {
//       return Container(
//         width: width * d,
//         height: 15,
//         child: Center(
//           child: Text(
//             name,
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//           ),
//         ),
//       );
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 15,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               cell("Order Id", 0.1),
//               cell("FG Part", 0.1),
//               cell("Schedule ID", 0.1),
//               cell("Cable Part No.", 0.1),
//               cell("Process", 0.1),
//               cell("Cut Length(mm)", 0.1),
//               cell("Color", 0.1),
//               cell("Scheduled Qty", 0.1),
//               cell("Schedule", 0.1)
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDataRow({PreparationSchedule schedule, int c}) {
//     double width = MediaQuery.of(context).size.width;

//     Widget cell(String name, double d) {
//       return Container(
//         width: width * d,
//         child: Center(
//           child: Text(
//             name,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       );
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 20,
//       color: Colors.grey.shade100,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//               left: BorderSide(
//             color: schedule.scheduledStatus == "Complete"
//                 ? Colors.green
//                 : schedule.scheduledStatus == "Pending"
//                     ? Colors.red
//                     : Colors.green.shade100,
//             width: 5,
//           )),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // orderId
//             cell(schedule.orderId, 0.1),
//             //Fg Part
//             cell(schedule.finishedGoodsNumber, 0.1),
//             //Schudule ID
//             cell(schedule.scheduledId, 0.1),

//             //Cable Part
//             cell(schedule.cablePartNumber, 0.1),
//             //Process
//             cell(schedule.process, 0.1),
//             // Cut length
//             cell(schedule.length, 0.1),
//             //Color
//             cell(schedule.color, 0.1),
//             //Scheduled Qty
//             cell(schedule.scheduledQuantity, 0.1),
//             //Schudule
//             Container(
//               width: width * 0.1,
//               child: Center(
//                 child: Text(
//                   "11:00 - 12:00",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
