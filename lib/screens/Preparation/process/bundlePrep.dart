// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../model_api/Preparation/getpreparationSchedule.dart';
// import '../../../model_api/Preparation/postPreparationDetail.dart';
// import '../../../model_api/crimping/bundleDetail.dart';
// import '../../../model_api/getuserId.dart';
// import '../../../models/bundle_scan.dart';
// import '../../widgets/P3scheduleDetaiLWIP.dart';
// import '../../widgets/time.dart';
// import '../../../service/apiService.dart';

// enum Status {
//   rejection,
//   scanBin,
//   scanBundle,
// }

// class ScanBundleP3 extends StatefulWidget {
//   String bundleId;
//   String machineId;
//   String userId;
//   BundleData bundleDetail;
//   // PreparationSchedule schedule;
//   ScanBundleP3({this.bundleId,this.bundleDetail, this.machineId, this.userId});
//   @override
//   _ScanBundleP3State createState() => _ScanBundleP3State();
// }

// class _ScanBundleP3State extends State<ScanBundleP3> {
//   bool next = false;
//   List<BundleScan> bundleScan = [];

//   String _output = '';

//   TextEditingController mainController = new TextEditingController();

//   TextEditingController _scanIdController = new TextEditingController();
//   Status status = Status.rejection;

//   TextEditingController bundleQtyController = new TextEditingController();

//   TextEditingController passedQtyController = new TextEditingController();

//   TextEditingController rejectedQtyController = new TextEditingController();
//   TextEditingController cableDamageController = new TextEditingController();
//   TextEditingController cablecrosscutController = new TextEditingController();
//   TextEditingController stripLengthController = new TextEditingController();
//   TextEditingController stripNickController = new TextEditingController();
//   TextEditingController unsheathingLengthController =
//       new TextEditingController();
//   TextEditingController drainWirecutController = new TextEditingController();
//   TextEditingController trimmingCableWrongController =
//       new TextEditingController();
//   TextEditingController trimmingLengthlessController =
//       new TextEditingController();
//   TextEditingController hstImproperShrinkingController =
//       new TextEditingController();
//   TextEditingController hstDamageController = new TextEditingController();
//   TextEditingController bootReverseController = new TextEditingController();
//   TextEditingController wrongBootInsertionController =
//       new TextEditingController();
//   TextEditingController bootDamageController = new TextEditingController();

   
//    List<Userid> usersList = [];
//    ApiService apiService;
//     getUser() {
//     apiService = new ApiService();
//     apiService.getUserList().then((value) {
//       setState(() {
//         usersList = value;
//       });
//     });
//   }

//   @override
//   void initState() {
//       apiService = new ApiService();
//       getUser();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     SystemChannels.textInput.invokeMethod(keyboardType);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(
//           color: Colors.red,
//         ),
//         title: const Text(
//           'Preparation',
//           style: TextStyle(color: Colors.red),
//         ),
//         elevation: 0,
//         actions: [
      
   

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
//                             widget.machineId ?? "",
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
//       body: Center(child: Column(
//         children: [
//           P3ScheduleDetailWIP(
//             schedule: PreparationSchedule(
//                 orderId: widget.bundleDetail.orderId,
//                 finishedGoodsNumber: widget.bundleDetail.finishedGoodsPart.toString(),
//                 scheduledId: widget.bundleDetail.scheduledId.toString(),
//                 cablePartNumber: widget.bundleDetail.cablePartNumber.toString(),
//                 process: widget.bundleDetail.updateFromProcess,
//                 color: widget.bundleDetail.color,
//                 scheduledQuantity: "null"
//             ),
//           ),
//           main(status),
//         ],
//       )),
//     );
//   }

//   Widget main(Status status) {
//     SystemChannels.textInput.invokeMethod(keyboardType);
//     switch (status) {
//       case Status.rejection:
//         return scanbundleidpop();
//         break;
//       case Status.scanBin:
//         return scanBin();
//         break;
//       case Status.scanBundle:
//         return scanBundle();
//         break;
//       default:
//         return Container();
//     }
//   }

//   handleKey(RawKeyEventData key) {
//     SystemChannels.textInput.invokeMethod(keyboardType);
//   }

//   Widget scanbundleidpop() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.65,
//             height: MediaQuery.of(context).size.height * 0.55,
//             decoration: BoxDecoration(
//               borderRadius: new BorderRadius.circular(20.0),
//               color: Colors.grey.shade100,
//             ),
//             child: Container(
//                 width: MediaQuery.of(context).size.width * 0.65,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: feild(
//                               heading: "Bundle Id",
//                               value: "${widget.bundleId}",
//                               width: 0.12),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: feild1(
//                               heading: "Bundle Qty", value: "${widget.bundleDetail.bundleQuantity}", width: 0.2),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: feild1(
//                               heading: "Rejected Qty", value: "${widget.bundleDetail.bundleQuantity}", width: 0.2),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Column(children: [
//                                 quantity(
//                                     'Cable Damage', 10, cableDamageController),
//                                 quantity('Cable Cross Cut', 10,
//                                     cablecrosscutController),
//                                 quantity(' Strip Length less / More', 10,
//                                     stripLengthController),
//                                 quantity('Strip Nick mark / blade mark', 10,
//                                     stripNickController),
//                               ]),
//                               Column(children: [
//                                 quantity('Unsheathing Length less / More', 10,
//                                     unsheathingLengthController),
//                                 quantity('Drain Wire Cut', 10,
//                                     drainWirecutController),
//                                 quantity('Trimming cable Wrong', 10,
//                                     trimmingCableWrongController),
//                                 quantity('Trimming Length less / More', 10,
//                                     trimmingLengthlessController),
//                               ]),
//                               Column(children: [
//                                 quantity('HST Improper Shrinking', 10,
//                                     hstImproperShrinkingController),
//                                 quantity('HST Damage', 10, hstDamageController),
//                                 quantity(
//                                     'Boot Reverse', 10, bootReverseController),
//                                 quantity(
//                                     'Boot Damage', 10, bootDamageController),
//                               ]),
//                               Column(children: [
//                                 quantity('Wrong Boot Insertion', 10,
//                                     wrongBootInsertionController),
//                               ]),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           elevation: 4,
//                           primary: Colors.green, // background
//                           onPrimary: Colors.white,
//                         ),
//                         onPressed: () {
//                           PostPreparationDetail postPreparationDetail = new PostPreparationDetail(
//                             bundleIdentification: widget.bundleDetail.bundleIdentification,
//                             bundleQuantity: widget.bundleDetail.bundleQuantity,
//                             rejectedQuantity: 0,
//                             crimpInslation: 0,
//                             windowGap: 0,
//                             exposedStrands: 0,
//                             burrOrCutOff: 0,
//                             terminalBendOrClosedOrDamage: 0,
//                             nickMarkOrStrandsCut: 0,
//                             seamOpen: 0,
//                             missCrimp: 0,
//                             frontBellMouth: 0,
//                             backBellMouth: 0,
//                             extrusionOnBurr: 0,
//                             brushLength: 0,
//                             cableDamage: 0,
//                             terminalTwist: 0,
//                             orderId: int.parse(widget.bundleDetail.orderId),
//                             fgPart: widget.bundleDetail.finishedGoodsPart,
//                             scheduleId: widget.bundleDetail.scheduledId,
//                             binId: widget.bundleDetail.binId.toString(),
//                             processType: "Preparation",
//                             method: "a-b-c",
//                             status: "",
//                             machineIdentification: widget.machineId,
//                             cablePartNumber: widget.bundleDetail.cablePartNumber,
//                             cutLength: widget.bundleDetail.cutLengthSpecificationInmm,
//                             color: widget.bundleDetail.color,
//                             finishedGoods: widget.bundleDetail.finishedGoodsPart,
//                           );
                            
//                      setState(() {
//                        status =Status.scanBin;
//                      });
//                         },
//                         child:
//                             Text('Save', style: TextStyle(color: Colors.white)),
//                       )),
//                     ),
//                   ],
//                 ),
//                 ),
//           ),
//         ),
//         Container(
//             height: 300,
//             padding: EdgeInsets.all(20),
//             child: Center(child: keypad(mainController))),
//       ],
//     );
//   }

//   Widget scanBin() {
//     return Padding(
//       padding: const EdgeInsets.all(100.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.75,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//                 height: 100,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 200,
//                       child: RawKeyboardListener(
//                         focusNode: FocusNode(),
//                         onKey: (event) => handleKey(event.data),
//                         child: TextField(
//                           onTap: () {
//                             SystemChannels.textInput
//                                 .invokeMethod(keyboardType);
//                           },
//                           controller: _scanIdController,
//                           autofocus: true,
//                           textAlign: TextAlign.center,
//                           textAlignVertical: TextAlignVertical.center,
//                           style: TextStyle(fontSize: 14),
//                           decoration: new InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(horizontal: 3),
//                             labelText: "Scan Bin",
//                             fillColor: Colors.white,
//                             border: new OutlineInputBorder(
//                               borderRadius: new BorderRadius.circular(5.0),
//                               borderSide: new BorderSide(),
//                             ),
//                             //fillColor: Colors.green
//                           ),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             height: 40,
//                             width: 100,
//                             child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.resolveWith(
//                                       (states) => Colors.redAccent),
//                                 ),
//                                 onPressed: () {
//                                  Navigator.pop(context);
//                                 },
//                                 child: Text('Scan Bin  ')),
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                       ],
//                     ),
//                   ],
//                 )),
//             // scanedTable(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget scanBundle() {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.75,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//               height: 100,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 200,
//                     child: RawKeyboardListener(
//                       focusNode: FocusNode(),
//                       onKey: (event) => handleKey(event.data),
//                       child: TextField(
//                         onTap: () {
//                           SystemChannels.textInput
//                               .invokeMethod(keyboardType);
//                         },
//                         controller: _scanIdController,
//                         autofocus: true,
//                         textAlign: TextAlign.center,
//                         textAlignVertical: TextAlignVertical.center,
//                         style: TextStyle(fontSize: 14),
//                         decoration: new InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 3),
//                           labelText: "Scan Bin",
//                           fillColor: Colors.white,
//                           border: new OutlineInputBorder(
//                             borderRadius: new BorderRadius.circular(5.0),
//                             borderSide: new BorderSide(),
//                           ),
//                           //fillColor: Colors.green
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith(
//                                 (states) => Colors.redAccent),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               status = Status.rejection;
//                             });
//                           },
//                           child: Text('Scan Bundle  ')),
//                       SizedBox(width: 5),
//                       ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith(
//                                 (states) => Colors.green),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               // showTable = !showTable;
//                               status = Status.scanBundle;
//                             });
//                           },
//                           child: Text("${bundleScan.length}")),
//                     ],
//                   ),
//                 ],
//               )),
//           // scanedTable(),
//         ],
//       ),
//     );
//   }

//   // To Show the bundle Id and  Bundle Qty and rejected Quantity
//   Widget feild({String heading, String value, double width}) {
//     width = MediaQuery.of(context).size.width * width;
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//         // color: Colors.red.shade100,
//         width: width,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   heading,
//                   style: GoogleFonts.poppins(
//                       textStyle: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey.shade500,
//                     fontWeight: FontWeight.normal,
//                   )),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 1.0),
//               child: Row(
//                 children: [
//                   Text(
//                     value ?? '',
//                     style: GoogleFonts.poppins(
//                       textStyle:
//                           TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// Widget feild1({String heading, String value, double width}) {
//     width = MediaQuery.of(context).size.width * width;
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//         // color: Colors.red.shade100,
//         width: width,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   heading,
//                   style: GoogleFonts.poppins(
//                       textStyle: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade500,
//                     fontWeight: FontWeight.normal,
//                   )),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: .0),
//               child: Row(
//                 children: [
//                   Container(
//                       width: 160,
//                       height: 40,
//                       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                         color: Colors.grey.shade200,
//                       ),
//                       child: Center(
//                         child: TextFormField(
//                           initialValue: value,
//                           style: TextStyle(
//                             fontSize: 14
//                           ),

//                           decoration: new InputDecoration(
//                             hintText: value,
                            
//                             hintStyle: GoogleFonts.openSans(
//                               textStyle: TextStyle(
//                                   fontSize: 8, fontWeight: FontWeight.w500),
//                             ),
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                             contentPadding: EdgeInsets.only(bottom: 12),
//                             fillColor: Colors.white,
//                           ),
//                         ),
//                       ))
//                   // Text(
//                   //   value ?? '',
//                   //   style: GoogleFonts.poppins(
//                   //     textStyle:
//                   //         TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget keypad(TextEditingController controller) {
//     buttonPressed(String buttonText) {
//       if (buttonText == 'X') {
//         _output = '';
//       } else {
//         _output = _output + buttonText;
//       }

//       print(_output);
//       setState(() {
//         controller.text = _output;
//         // output = int.parse(_output).toStringAsFixed(2);
//       });
//     }

//     Widget buildbutton(String buttonText) {
//       return new Expanded(
//           child: Container(
//         decoration: new BoxDecoration(),
//         width: 27,
//         height: 50,
//         child: new ElevatedButton(
//           style: ButtonStyle(
//             elevation: MaterialStateProperty.all(0),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0.0),
//                     side: BorderSide(color: Colors.grey.shade50))),
//             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//               (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.pressed))
//                   return Colors.grey.shade100;

//                 return Colors.white; // Use the component's default.
//               },
//             ),
//           ),
//           child: buttonText == "X"
//               ? Container(
//                   width: 50,
//                   height: 50,
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.backspace,
//                       color: Colors.red.shade400,
//                     ),
//                     onPressed: () => {buttonPressed(buttonText)},
//                   ))
//               : new Text(
//                   buttonText,
//                   style: GoogleFonts.openSans(
//                     textStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ),
//           onPressed: () => {buttonPressed(buttonText)},
//         ),
//       ));
//     }

//     return Material(
//       elevation: 2,
//       shadowColor: Colors.grey.shade200,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.24,
//         decoration: new BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.red.withOpacity(0.1),
//           //     spreadRadius: 2,
//           //     blurRadius: 2,
//           //     offset: Offset(0, 0), // changes position of shadow
//           //   ),
//           // ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 buildbutton("7"),
//                 buildbutton('8'),
//                 buildbutton('9'),
//               ],
//             ),
//             Row(
//               children: [
//                 buildbutton('4'),
//                 buildbutton('5'),
//                 buildbutton('6'),
//               ],
//             ),
//             Row(
//               children: [
//                 buildbutton('1'),
//                 buildbutton('2'),
//                 buildbutton('3'),
//               ],
//             ),
//             Row(
//               children: [
//                 buildbutton('00'),
//                 buildbutton('0'),
//                 buildbutton('X'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget quantity(
//       String title, int quantity, TextEditingController textEditingController) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.15,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               height: 35,
//               width: 140,
//               child: TextField(
//                 controller: textEditingController,
//                 style: TextStyle(fontSize: 13),
//                 onTap: () {
//                   setState(() {
//                     _output = '';
//                     mainController = textEditingController;
//                   });
//                 },
//                 keyboardType: TextInputType.number,
//                 decoration: new InputDecoration(
//                   labelText: title,
//                   fillColor: Colors.white,
//                   labelStyle: TextStyle(fontSize: 13),
//                   border: new OutlineInputBorder(
//                     borderRadius: new BorderRadius.circular(5.0),
//                     borderSide: new BorderSide(),
//                   ),
//                   //fillColor: Colors.green
//                 ),
//                 //fillColor: Colors.green
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
