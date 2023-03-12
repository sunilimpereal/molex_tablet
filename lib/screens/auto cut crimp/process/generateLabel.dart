import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex_tab/model_api/cableDetails_model.dart';
import 'package:molex_tab/screens/kitting_plan/kitting_plan_dash.dart';
import 'package:molex_tab/screens/auto%20cut%20crimp/widgets/show_bundle_list.dart';
import '../../../authentication/data/models/login_model.dart';
import '../../../main.dart';
import '../../../model_api/Transfer/bundleToBin_model.dart';
import '../../../model_api/Transfer/postgetBundleMaster.dart';
import '../../../model_api/cableTerminalA_model.dart';
import '../../../model_api/cableTerminalB_model.dart';
import '../../../model_api/generateLabel_model.dart';
import '../../../model_api/machinedetails_model.dart';
import '../../../model_api/materialTrackingCableDetails_model.dart';
import '../../../model_api/process1/getBundleListGl.dart';
import '../../../model_api/schedular_model.dart';
import '../../../model_api/transferBundle_model.dart';
import '../../../utils/config.dart';
import '../location.dart';
import 'materialTableWIP.dart';
import '../../widgets/keypad.dart';
import '../../widgets/showBundles.dart';
import '../../widgets/timer.dart';
import '../../../service/apiService.dart';

enum Status {
  generateLabel,
  scanBundle,
  scanBin,
}
// 100% complete - actual quantity
// partial complete confirmaton
// load material process -
// tracebiltity numner
// bundle qty
// no data in material show msg
// -- move to rejection
// --save and print
// label id
// printer status
// partail compltion reason

// partail compltion reason
// printer status
// -- move to rejection
// bundle qty --error
//partial complete button

class GenerateLabel extends StatefulWidget {
  Schedule schedule;
  MachineDetails machine;
  Employee employee;
  String method;
  Function reload;
  Function sendData;
  Function fullcomplete;
  Function partialComplete;
  bool processStarted;
  Function startprocess;
  MatTrkPostDetail matTrkPostDetail;
  int toalQuantity;
  Function updateQty;
  Function transfer;
  String processType;
  //variables for schedule data
  String type;
  String sameMachine;
  Key? key;
  GenerateLabel(
      {this.key,
      required this.machine,
      required this.schedule,
      required this.sendData,
      required this.employee,
      required this.method,
      required this.matTrkPostDetail,
      required this.partialComplete,
      required this.fullcomplete,
      required this.processStarted,
      required this.startprocess,
      required this.toalQuantity,
      required this.updateQty,
      required this.processType,
      required this.transfer,
      required this.reload,
      required this.sameMachine,
      required this.type});
  @override
  _GenerateLabelState createState() => _GenerateLabelState();
}

class _GenerateLabelState extends State<GenerateLabel> {
  // Text Editing Controller for all rejection cases
  TextEditingController maincontroller = new TextEditingController();
  TextEditingController _bundleScanController = new TextEditingController();
  TextEditingController _binController = new TextEditingController();
  TextEditingController bundleQty = new TextEditingController();

  // All Quantity Contolle
  TextEditingController endWireController = new TextEditingController();
  TextEditingController endTerminalControllerFrom = new TextEditingController();
  TextEditingController endTerminalControllerTo = new TextEditingController();
  TextEditingController setupRejectionsControllerCable = new TextEditingController();
  TextEditingController setupRejectionsControllerFrom = new TextEditingController();
  TextEditingController setupRejectionsControllerTo = new TextEditingController();
  TextEditingController cvmRejectionsControllerCable = new TextEditingController();
  TextEditingController cvmRejectionsControllerTo = new TextEditingController();
  TextEditingController cvmRejectionsControllerFrom = new TextEditingController();
  TextEditingController cfmRejectionsControllerCable = new TextEditingController();
  TextEditingController cfmRejectionsControllerTo = new TextEditingController();
  TextEditingController cfmRejectionsControllerFrom = new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController lengthvariationController = new TextEditingController();
  TextEditingController rollerMarkController = new TextEditingController();
  TextEditingController stripLengthVariationController = new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();

  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController = new TextEditingController();
  TextEditingController bellMoutherrorController = new TextEditingController();
  TextEditingController cutoffBarController = new TextEditingController();
  TextEditingController exposureStrandsController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessorMoreController = new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();
  TextEditingController wrongcableController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController wrongCutLengthController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();

  /// Main Content
  FocusNode keyboardFocus = new FocusNode();

  bool labelGenerated = false;
  String _output = '';
  String? binState;
  String? binId;
  String? bundleId;
  bool hasBin = false;
  Status status = Status.generateLabel;
  TransferBundle transferBundle = new TransferBundle();
  PostGenerateLabel postGenerateLabel = new PostGenerateLabel();
  static const platform = const MethodChannel('com.impereal.dev/tsc');
  String _printerStatus = 'Waiting';
  List<GeneratedBundle> generatedBundleList = [];
  bool showtable = false;
  bool loading = false;

  FocusNode _bundleFocus = new FocusNode();

  Future<bool> _print({
    required String ipaddress,
    required String bq,
    required String qr,
    required String routenumber1,
    required String date,
    required String orderId,
    required String fgPartNumber,
    required String cutlength,
    required String cablepart,
    required String wireGauge,
    required String terminalfrom,
    required String terminalto,
    required String userid,
    required String shift,
    required String machine,
  }) async {
    String printerStatus;

    try {
      final String result = await platform.invokeMethod('Print', {
        "ipaddress": ipaddress,
        "bundleQty": bq,
        "qr": qr,
        "routenumber1": routenumber1,
        "date": date,
        "orderId": orderId,
        "fgPartNumber": fgPartNumber,
        "cutlength": cutlength,
        "cutpart": cablepart,
        "wireGauge": wireGauge,
        "terminalfrom": terminalfrom,
        "terminalto": terminalto,
        "userid": userid,
        "shift": shift,
        "machine": machine,
      });
      printerStatus = 'Printer status : $result % .';
      Fluttertoast.showToast(
          msg: "$printerStatus",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return true;
    } on PlatformException catch (e) {
      printerStatus = "Failed to get printer: '${e.message}'.";
      Fluttertoast.showToast(
          msg: "$printerStatus",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        _printerStatus = printerStatus;
      });
      return false;
    }
  }

  ApiService? apiService;
  CableTerminalA? terminalA;
  CableTerminalB? terminalB;
  CableDetails? cableDetails;
  String uom = "";
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: widget.schedule.finishedGoodsNumber,
            cablepartno: widget.schedule.cablePartNumber,
            isCrimping: false,
            length: widget.schedule.length,
            color: widget.schedule.color,
            terminalPartNumberFrom: widget.schedule.terminalPartNumberFrom,
            terminalPartNumberTo: widget.schedule.terminalPartNumberTo,
            awg: widget.schedule.awg)
        .then((termiA) {
      apiService
          .getCableTerminalB(
              isCrimping: false,
              fgpartNo: widget.schedule.finishedGoodsNumber,
              cablepartno: widget.schedule.cablePartNumber,
              length: widget.schedule.length,
              terminalPartNumberFrom: widget.schedule.terminalPartNumberFrom,
              terminalPartNumberTo: widget.schedule.terminalPartNumberTo,
              color: widget.schedule.color,
              awg: widget.schedule.awg)
          .then((termiB) {
        apiService
            .getCableDetails(
                isCrimping: false,
                fgpartNo: widget.schedule.finishedGoodsNumber,
                cablepartno: widget.schedule.cablePartNumber,
                length: widget.schedule.length,
                terminalPartNumberFrom: widget.schedule.terminalPartNumberFrom,
                terminalPartNumberTo: widget.schedule.terminalPartNumberTo,
                color: widget.schedule.color,
                awg: widget.schedule.awg)
            .then((cableDet) {
          setState(() {
            terminalA = termiA;
            terminalB = termiB;
            cableDetails = cableDet;
            getBundles();
            getMaterial();
            log("init");
          });
        });
      });
    });
  }

  Future<List<GeneratedBundle>> getBundles() async {
    List<GeneratedBundle> bundleList = [];
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      scheduleId: int.parse(widget.schedule.scheduledId),
      binId: 0,
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: 0,
      cablePartNumber: 0,
      orderId: "",
    );
    apiService.getBundlesInSchedule(postgetBundleMaster: postgetBundleMaste, scheduleID: widget.schedule.scheduledId).then((value) {
      List<BundlesRetrieved> bundles = value!;
      log("bun1 ${bundles}");
      for (BundlesRetrieved bundle in bundles) {
        bundleList.add(GeneratedBundle(
            bundleDetail: bundle,
            bundleQty: bundle.bundleQuantity.toString(),
            transferBundleToBin:
                TransferBundleToBin(binIdentification: bundle.binId.toString(), locationId: bundle.locationId.toString(), bundleId: '', userId: ''),
            label: GeneratedLabel(
              finishedGoods: bundle.finishedGoodsPart,
              cablePartNumber: bundle.cablePartNumber,
              cutLength: bundle.cutLengthSpecificationInmm,
              wireGauge: bundle.awg,
              bundleId: bundle.bundleIdentification,
              routeNo: "${widget.schedule.route}",
              status: 0,
              bundleQuantity: bundle.bundleQuantity,
              terminalFrom: terminalA?.terminalPart ?? 0,
              terminalTo: terminalB?.terminalPart ?? 0,
              //  terminalFrom: bundle.t
              //todo terminal from,terminal to
              //todo route no
              //
            ),
            rejectedQty: ''));
      }
      setState(() {
        generatedBundleList = bundleList;
        widget.sendData(generatedBundleList.length);
      });
    });
    return generatedBundleList;
  }

  getActualQty() {
    ApiService apiService = new ApiService();
    apiService.getScheduelarData(machId: widget.machine.machineNumber ?? '', type: widget.type, sameMachine: widget.sameMachine).then((value) {
      List<Schedule> scheduleList = value!;
      Schedule schedule = scheduleList.firstWhere((element) {
        return (element.scheduledId == widget.schedule.scheduledId);
      });
      setState(() {
        log("total Qty : ${schedule.actualQuantity}");
        widget.toalQuantity = schedule.actualQuantity;
      });
    });
  }

  GeneratedLabel? label;
  bool printerStatus = false;
  List<MaterialDetail> materailList = [];
  getMaterial() {
    ApiService().getMaterialTrackingCableDetail(widget.matTrkPostDetail).then((value) {
      List<MaterialDetail> materailListFil = [];
      materailList = (value as List<MaterialDetail>?)!;
      if (widget.method.contains('a')) {
        materailListFil.addAll(materailList.where((element) => int.parse(element.cablePartNo ?? "0") == terminalA?.terminalPart).toList());
      }
      if (widget.method.contains('c')) {
        materailListFil.addAll(materailList.where((element) => int.parse(element.cablePartNo ?? "0") == cableDetails?.cablePartNumber).toList());
      }
      if (widget.method.contains('b')) {
        materailListFil.addAll(materailList.where((element) => int.parse(element.cablePartNo ?? "0") == terminalB?.terminalPart).toList());
      }
      setState(() {
        materailList = materailListFil;
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        if (widget.schedule.cablePartNumber != ' ') {
          for (MaterialDetail matDet in materailList ?? []) {
            if (widget.schedule.cablePartNumber == matDet.cablePartNo) {
              if (uom.isEmpty) {
                setState(() {
                  uom = matDet.uom ?? "";
                });
              }
              log(matDet.uom ?? "");
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    getMaterial();
    apiService = new ApiService();
    getTerminal();
    checkMapping();

    transferBundle = new TransferBundle();
    label = new GeneratedLabel();
    transferBundle.cablePartDescription = widget.schedule.cablePartNumber;
    transferBundle.scheduledQuantity = int.parse(widget.schedule.scheduledQuantity);
    transferBundle.orderIdentification = int.parse(widget.schedule.orderId);
    transferBundle.machineIdentification = widget.machine.machineNumber;
    transferBundle.scheduledId = widget.schedule.scheduledId == '' ? 0 : int.parse(widget.schedule.scheduledId);
    binState = "Scan Bin";
    super.initState();
  }

  void clear() {
    endWireController.clear();
    cableDamageController.clear();
    lengthvariationController.clear();
    rollerMarkController.clear();
    stripLengthVariationController.clear();
    nickMarkController.clear();
    endTerminalControllerFrom.clear();
    endTerminalControllerTo.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMoutherrorController..clear();
    cutoffBarController.clear();
    exposureStrandsController.clear();
    strandsCutController.clear();
    brushLengthLessorMoreController.clear();
    halfCurlingController.clear();
    setupRejectionsControllerCable.clear();
    setupRejectionsControllerTo.clear();
    setupRejectionsControllerFrom.clear();
    cvmRejectionsControllerCable.clear();
    cvmRejectionsControllerTo.clear();
    cvmRejectionsControllerFrom.clear();
    cfmRejectionsControllerCable.clear();
    cfmRejectionsControllerTo.clear();
    cfmRejectionsControllerFrom.clear();
    wrongTerminalController.clear();
    wrongcableController.clear();
    seamOpenController.clear();
    wrongCutLengthController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              quantity(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Material(
                    elevation: 2,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        main(status),
                        widget.processStarted
                            ? KeyPad(
                                controller: maincontroller,
                                buttonPressed: (buttonText) {
                                  if (buttonText == 'X') {
                                    _output = '';
                                  } else {
                                    _output = _output + buttonText;
                                  }

                                  print(_output);
                                  setState(() {
                                    maincontroller.text = _output;
                                    // output = int.parse(_output).toStringAsFixed(2);
                                  });
                                })
                            // ? keypad(maincontroller)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        printerStatus
            ? Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                            ),
                            Text("Printing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget main(Status status) {
    // Future.delayed(
    //   const Duration(milliseconds: 50),
    //   () {
    //     SystemChannels.textInput.invokeMethod(keyboardType);
    //   },
    // );
    // SystemChannels.textInput.invokeMethod(keyboardType);
    switch (status) {
      case Status.generateLabel:
        return widget.processStarted
            ? Container(
                child: widget.machine.category == "Automatic Cut & Crimp" ? generateLabelAutoCut() : generateLabelMannualCut(),
              )
            : Container(
                width: (MediaQuery.of(context).size.width * 0.75) - 5,
                height: 244,
              );

        break;
      case Status.scanBin:
        return binScan();
        break;
      case Status.scanBundle:
        return bundleScan();
      default:
        return Container();
    }
  }

  Widget quantity() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          MaterialtableWIP(
            cablePartNumber: cableDetails?.cablePartNumber.toString(),
            matTrkPostDetail: widget.matTrkPostDetail,
            materailList: materailList,
            getUom: (um) {},
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Material(
              elevation: 2,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.transparent)),
              child: Container(
                  padding: EdgeInsets.all(4),
                  width: 616,
                  height: 98,
                  child: widget.processStarted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //Quantity Feild
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        width: 180,
                                        height: 40,
                                        child: TextField(
                                          readOnly: true,
                                          textAlign: TextAlign.center,
                                          controller: bundleQty,
                                          onEditingComplete: () {
                                            setState(() {
                                              SystemChannels.textInput.invokeMethod(keyboardType);

                                              labelGenerated = !labelGenerated;
                                              status = Status.generateLabel;
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              _output = '';
                                              maincontroller = bundleQty;
                                              SystemChannels.textInput.invokeMethod(keyboardType);
                                            });
                                          },
                                          showCursor: false,
                                          keyboardType: TextInputType.number,
                                          textAlignVertical: TextAlignVertical.center,
                                          style: TextStyle(fontSize: 15),
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 3),
                                            labelText: "  Bundle Qty (SPQ)",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                            height: 35,
                                            // width: MediaQuery.of(context).size.width * 0.13,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                    side: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(MaterialState.pressed)) return Colors.red.shade200;
                                                    return Colors.red.shade500; // Use the component's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                showBundles();

                                                setState(() {
                                                  showtable = !showtable;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Bundles"),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    // padding: EdgeInsets.all(6),
                                                    // width: 25,
                                                    height: 25,
                                                    decoration:
                                                        BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.all(Radius.circular(100))),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(
                                                          '${generatedBundleList.length > 0 ? generatedBundleList.length : "0"}',
                                                          // bundlePrint.length.toString(),
                                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            quantityDisp(),
                            ProcessTimer(startTime: DateTime.now(), endTime: widget.schedule.shiftEnd),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                height: 85,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        widget.toalQuantity == int.parse(widget.schedule.scheduledQuantity)
                                            ? Container(
                                                height: 34,
                                                width: 160,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                      (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                                        return Colors.green.shade500; // Use the component's default.
                                                      },
                                                    ),
                                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                                      (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.pressed)) return Colors.green;
                                                        return Colors.green.shade500; // Use the component's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    getBundles();
                                                    checkMapping().then((value) {
                                                      if (value) {
                                                        widget.toalQuantity > (int.parse(widget.schedule.scheduledQuantity) * (0.98))
                                                            ? widget.fullcomplete()
                                                            : fullycompleteDialog();
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "100% Complete",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: fonts.openSans,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ))
                                            : Container(),
                                        //partially complete
                                        generatedBundleList.length > 0 && widget.toalQuantity != int.parse(widget.schedule.scheduledQuantity)
                                            ? Container(
                                                height: 34,
                                                width: 160,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.green))),
                                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                      (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.pressed)) return Colors.white;
                                                        return Colors.white; // Use the component's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    getBundles();
                                                    checkMapping().then((value) {
                                                      if (value) {
                                                        widget.partialComplete();
                                                      }
                                                    });

                                                    // setState(() {
                                                    //   rightside = "partial";
                                                    // });
                                                  },
                                                  child: Text(
                                                    "Partially  Complete",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontFamily: fonts.openSans,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 34,
                                                width: 160,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                        return Colors.green.shade500; // Use the component's default.
                                      },
                                    ),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.green;
                                        return Colors.green.shade500; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    if (widget.method == '') {
                                      Fluttertoast.showToast(
                                        msg: "Select Process Type To Start",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      widget.startprocess();
                                    }
                                  },
                                  child: Text("Start Process"))),
                        )),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkMapping() async {
    for (GeneratedBundle bundle in generatedBundleList) {
      log("bundleloc ${bundle.bundleDetail.locationId.toString()}");
      if (bundle.bundleDetail.locationId.toString() == "null" || bundle.bundleDetail.binId.toString() == "null") {
        showMappingAlert(generatedBundleList);
        return false;
      }
    }
    return true;
  }

  Future<void> showMappingAlert(List<GeneratedBundle> bundles) {
    getBundles();
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(0),
            // titlePadding: EdgeInsets.all(0),
            title: Text(
              "Incomplete Bundle Mapping",
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Map all bundles to Bin and Location to Complete Schedule"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                  return Colors.green.shade500; // Use the component's default.
                                },
                              ),
                              overlayColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.green;
                                  return Colors.green.shade500; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context2);
                              widget.reload();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Location(
                                            locationType: LocationType.partialTransfer,
                                            type: "process",
                                            employee: widget.employee,
                                            machine: widget.machine,
                                          ))).then((value) {
                                setState(() {
                                  log("came Back");
                                  getBundles();
                                });
                              });
                            },
                            child: Text("Map Bin & Location")),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget generateLabelAutoCut() {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.75) - 5,
      height: MediaQuery.of(context).size.height * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('     WireCutting & Crimping Rejection Cases',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, fontFamily: fonts.openSans)),
                  // Text(' Rejecttion Quantity: ${total()}',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 12,
                  //     ))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            doubleQuantityCell(
                              name: "End Terminal ",
                              textEditingControllerFrom: endTerminalControllerFrom,
                              textEditingControllerTo: endTerminalControllerTo,
                            ),
                            tripleQuantityCell(
                              name: "CFM  Rejections ",
                              textEditingControllerFrom: cfmRejectionsControllerFrom,
                              textEditingControllerCable: cfmRejectionsControllerCable,
                              textEditingControllerTo: cfmRejectionsControllerTo,
                            ),
                            tripleQuantityCell(
                              name: "CVM  Rejections ",
                              textEditingControllerFrom: cvmRejectionsControllerFrom,
                              textEditingControllerCable: cvmRejectionsControllerCable,
                              textEditingControllerTo: cvmRejectionsControllerTo,
                            ),
                            tripleQuantityCell(
                              name: "Setup  Rejection ",
                              textEditingControllerFrom: setupRejectionsControllerFrom,
                              textEditingControllerCable: setupRejectionsControllerCable,
                              textEditingControllerTo: setupRejectionsControllerTo,
                            ),

                            // quantitycell(
                            //   name: "Blade Mark	",
                            //   quantity: 10,
                            //   textEditingController: bladeMarkController,
                            // ),
                            // quantitycell(
                            //   name: "Cable Damage",
                            //   quantity: 10,
                            //   textEditingController: cableDamageController,
                            // ),
                            // quantitycell(
                            //   name: "Length Variation",
                            //   quantity: 10,
                            //   textEditingController: lengthvariationController,
                            // ),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(
                              name: "End Wire",
                              quantity: 10,
                              textEditingController: endWireController,
                            ),
                            quantitycell(
                              name: "Cable Damage",
                              quantity: 10,
                              textEditingController: cableDamageController,
                            ),
                            quantitycell(
                              name: "Length Variation",
                              quantity: 10,
                              textEditingController: lengthvariationController,
                            ),
                            quantitycell(
                              name: "Roller Mark",
                              quantity: 10,
                              textEditingController: rollerMarkController,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(
                              name: "Strip Length Variation",
                              quantity: 10,
                              textEditingController: stripLengthVariationController,
                            ),
                            quantitycell(
                              name: "Nick Mark",
                              quantity: 10,
                              textEditingController: nickMarkController,
                            ),
                            quantitycell(
                              name: "Terminal Damage",
                              quantity: 10,
                              textEditingController: terminalDamageController,
                            ),
                            quantitycell(
                              name: "Teminal Bend	",
                              quantity: 10,
                              textEditingController: terminalBendController,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(name: "Terminal Twist", quantity: 10, textEditingController: terminalTwistController),
                            quantitycell(
                              name: "Window Gap",
                              quantity: 10,
                              textEditingController: windowGapController,
                            ),
                            quantitycell(
                              name: "Crimp On Insulation",
                              quantity: 10,
                              textEditingController: crimpOnInsulationController,
                            ),
                            quantitycell(name: "Bellmouth Error", quantity: 10, textEditingController: bellMoutherrorController),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(
                              name: "Cut Off Bar",
                              quantity: 10,
                              textEditingController: cutoffBarController,
                            ),
                            quantitycell(
                              name: "Exposure Strands",
                              quantity: 10,
                              textEditingController: exposureStrandsController,
                            ),
                            quantitycell(
                              name: "Strands Cut",
                              quantity: 10,
                              textEditingController: strandsCutController,
                            ),
                            quantitycell(
                              name: "Brush Length Less/More",
                              quantity: 10,
                              textEditingController: brushLengthLessorMoreController,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(
                              name: "Half Curling",
                              quantity: 10,
                              textEditingController: halfCurlingController,
                            ),
                            quantitycell(
                              name: "Wrong terminal",
                              quantity: 10,
                              textEditingController: wrongTerminalController,
                            ),
                            quantitycell(
                              name: "Wrong Cable",
                              quantity: 10,
                              textEditingController: wrongcableController,
                            ),
                            quantitycell(
                              name: "Seam Open",
                              quantity: 10,
                              textEditingController: seamOpenController,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            quantitycell(
                              name: "Extrusion Burr",
                              quantity: 10,
                              textEditingController: extrusionBurrController,
                            ),
                            quantitycell(
                              name: "Wrong Cut-length",
                              quantity: 10,
                              textEditingController: wrongCutLengthController,
                            ),
                            quantitycell(
                              name: "Miss Crimp",
                              quantity: 10,
                              textEditingController: missCrimpController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                child: Center(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text("Bundle Qty :  "),
                                    Text(
                                      "${bundleQty.text}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Rejected Qty :  "),
                                    Text(
                                      "${total()}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Other Rejections :  "),
                                    Text(
                                      "${otherTotal()}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              loading
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                            return Colors.green.shade500; // Use the component's default.
                                          },
                                        ),
                                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                            return Colors.green.shade500; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CircularProgressIndicator(
                                          // color: Colors.white
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ))
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                            return Colors.green.shade500; // Use the component's default.
                                          },
                                        ),
                                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                            return Colors.green.shade500; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Save & Print",
                                          style: TextStyle(fontFamily: fonts.openSans, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (bundleQty.text.length > 0 && int.parse(bundleQty.text) != 0) {
                                          if (widget.toalQuantity + int.parse(bundleQty.text) <= int.parse(widget.schedule.scheduledQuantity)) {
                                            setState(() {
                                              loading = true;
                                            });
                                            // if (int.parse(total()) <
                                            //     int.parse(bundleQty.text)) {
                                            log(postGenerateLabelToJson(getPostGeneratelabel()));
                                            apiService!.postGeneratelabel(getPostGeneratelabel(), bundleQty.text, uom).then((value) {
                                              if (value != null) {
                                                DateTime now = DateTime.now();
                                                GeneratedLabel label1 = value;
                                                getActualQty();
                                                setState(() {
                                                  printerStatus = true;
                                                });
                                                _print(
                                                  ipaddress: "${widget.machine.printerIp}",
                                                  // ipaddress: "172.25.16.53",
                                                  bq: "${label1.bundleQuantity}",
                                                  qr: "${label1.bundleId}",
                                                  routenumber1: "${label1.routeNo}",
                                                  date: now.day.toString() + "-" + now.month.toString() + "-" + now.year.toString(),
                                                  orderId: "${widget.schedule.orderId}",
                                                  fgPartNumber: "${widget.schedule.finishedGoodsNumber}",
                                                  cutlength: "${widget.schedule.length}",
                                                  cablepart: "${widget.schedule.cablePartNumber}",
                                                  wireGauge: "${label1.wireGauge}",
                                                  terminalfrom: '${terminalA?.terminalPart ?? '0'}',
                                                  terminalto: "${terminalB?.terminalPart ?? '0'}",
                                                  userid: "${widget.employee.empId}",
                                                  shift: "${getShift()}",
                                                  // shift:
                                                  //     "${widget.schedule.shiftNumber}",
                                                  machine: "${widget.machine.machineNumber}",
                                                ).then((value) {
                                                  Future.delayed(
                                                    const Duration(milliseconds: 1000),
                                                    () {
                                                      setState(() {
                                                        printerStatus = false;
                                                      });
                                                    },
                                                  );
                                                });
                                                setState(() {
                                                  loading = false;
                                                });

                                                setState(() {
                                                  widget.reload();
                                                  widget.sendData(generatedBundleList.length);
                                                  SystemChannels.textInput.invokeMethod(keyboardType);
                                                  widget.updateQty(widget.toalQuantity + int.parse(bundleQty.text));
                                                  labelGenerated = !labelGenerated;
                                                  status = Status.scanBin;
                                                  label = value;
                                                });
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });
                                              }
                                              getMaterial();
                                            });
                                          } else {
                                            setState(() {
                                              loading = false;
                                            });

                                            Fluttertoast.showToast(
                                              msg: "Actual Quantity is Greater than Schedule Quantity",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Enter Bundle Qty",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget generateLabelMannualCut() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('     Cutting Rejection Cases', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, fontFamily: fonts.openSans)),
                // Text(' Rejecttion Quantity: ${total()}',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 12,
                //     ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          quantitycell(
                            name: "End Wire",
                            quantity: 10,
                            textEditingController: endWireController,
                          ),
                          quantitycell(
                            name: "Cable Damage",
                            quantity: 10,
                            textEditingController: cableDamageController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Length variation",
                            quantity: 10,
                            textEditingController: lengthvariationController,
                          ),
                          quantitycell(
                            name: "Roller Mark",
                            quantity: 10,
                            textEditingController: rollerMarkController,
                          ),
                          quantitycell(
                            name: "Strip Length Variation",
                            quantity: 10,
                            textEditingController: stripLengthVariationController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Nick Mark",
                            quantity: 10,
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "Wrong Cable",
                            quantity: 10,
                            textEditingController: wrongcableController,
                          ),
                          quantitycell(
                            name: "Wrong Cut Length",
                            quantity: 10,
                            textEditingController: wrongCutLengthController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Strands Cut",
                            quantity: 10,
                            textEditingController: strandsCutController,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              child: Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text("Bundle Qty :  "),
                                  Text(
                                    "${bundleQty.text}",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Rejected Qty :  "),
                                  Text(
                                    "${total()}",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          // ElevatedButton(
                          //     style: ButtonStyle(
                          //       shape: MaterialStateProperty.all<
                          //               RoundedRectangleBorder>(
                          //           RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(20.0),
                          //               side: BorderSide(color: Colors.green))),
                          //       backgroundColor:
                          //           MaterialStateProperty.resolveWith<Color>(
                          //         (Set<MaterialState> states) {
                          //           if (states.contains(MaterialState.pressed))
                          //             return Colors.white;
                          //           return Colors
                          //               .white; // Use the component's default.
                          //         },
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       setState(() {
                          //         SystemChannels.textInput
                          //             .invokeMethod(keyboardType);
                          //         status = Status.generateLabel;
                          //       });
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.keyboard_arrow_left,
                          //             color: Colors.green),
                          //         Text(
                          //           "Back",
                          //           style: TextStyle(color: Colors.green),
                          //         ),
                          //       ],
                          //     )),
                          SizedBox(width: 10),
                          loading
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                        return Colors.green.shade500; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    log("printing");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  ))
                              : ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.transparent))),
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                        return Colors.green.shade500; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  child: Text("Save & Print"),
                                  onPressed: () {
                                    if (bundleQty.text.length > 0 && bundleQty.text != "0") {
                                      setState(() {
                                        loading = true;
                                      });
                                      log(postGenerateLabelToJson(getPostGeneratelabel()));
                                      if (widget.toalQuantity + int.parse(bundleQty.text) <= int.parse(widget.schedule.scheduledQuantity)) {
                                        apiService!.postGeneratelabel(getPostGeneratelabel(), bundleQty.text, uom).then((value) {
                                          if (value != null) {
                                            DateTime now = DateTime.now();
                                            GeneratedLabel label1 = value;
                                            _print(
                                              ipaddress: "${widget.machine.printerIp}",
                                              // ipaddress: "172.25.16.53",
                                              bq: "${label1.bundleQuantity}",
                                              qr: "${label1.bundleId}",
                                              routenumber1: "${label1.routeNo}",
                                              date: now.day.toString() + "-" + now.month.toString() + "-" + now.year.toString(),
                                              orderId: "${widget.schedule.orderId}",
                                              fgPartNumber: "${widget.schedule.finishedGoodsNumber}",
                                              cutlength: "${widget.schedule.length}",
                                              cablepart: "${widget.schedule.cablePartNumber}",
                                              wireGauge: "${label1.wireGauge}",
                                              terminalfrom: '${terminalA?.terminalPart ?? '0'}',
                                              terminalto: "${terminalB?.terminalPart ?? '0'}",
                                              userid: "${widget.employee.empId}",
                                              shift: "${getShift()}",
                                              // shift:
                                              //     "${widget.schedule.shiftNumber}",
                                              machine: "${widget.machine.machineNumber}",
                                            );
                                            setState(() {
                                              loading = false;
                                            });
                                            getMaterial();
                                            setState(() {
                                              widget.reload();
                                              labelGenerated = !labelGenerated;
                                              status = Status.scanBin;
                                              label = value;
                                              widget.updateQty(widget.toalQuantity + int.parse(bundleQty.text));
                                              SystemChannels.textInput.invokeMethod(keyboardType);
                                            });
                                          } else {
                                            getMaterial();
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        });
                                      } else {
                                        getMaterial();
                                        setState(() {
                                          loading = false;
                                        });
                                        Fluttertoast.showToast(
                                          msg: "Actual Quantity is Greater than Schedule Quantity",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    } else {
                                      getMaterial();
                                      setState(() {
                                        loading = false;
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Invalid Bundle Quantity",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                    getMaterial();
                                  }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // emu-m/c-004w

  PostGenerateLabel getPostGeneratelabel() {
    String getprocesstype() {
      String process = "";
      if (widget.method.contains("a")) {
        process = process + "crimp from,";
      }
      if (widget.method.contains("c")) {
        process = process + "cutlength";
      }
      if (widget.method.contains("b")) {
        process = process + ",Crimp to";
      }
      return process;
    }

    return PostGenerateLabel(
      //Schedule Detail
      cablePartNumber: int.parse(widget.schedule.cablePartNumber ?? '0'),
      purchaseorder: int.parse(widget.schedule.orderId ?? '0'),
      orderIdentification: int.parse(widget.schedule.orderId ?? '0'),
      finishedGoods: int.parse(widget.schedule.finishedGoodsNumber ?? '0'),
      color: widget.schedule.color,
      cutLength: int.parse(widget.schedule.length ?? '0'),
      scheduleIdentification: int.parse(widget.schedule.scheduledId ?? '0'),
      scheduledQuantity: int.parse(widget.schedule.scheduledQuantity ?? '0'),
      machineIdentification: widget.machine.machineNumber,
      operatorIdentification: widget.employee.empId,
      bundleIdentification: _bundleScanController.text,
      crimpFromSchId: widget.method.contains("a") ? "${widget.schedule.scheduledId}" : "",
      crimpToSchId: widget.method.contains("b") ? "${widget.schedule.scheduledId}" : "",
      preparationCompleteFlag: "0",
      viCompleted: "0",
      processType: getprocesstype(),
      rejectedQuantity: int.parse(total()),

      // Rejected Quantity
      endWire: int.parse(endWireController.text == '' ? "0" : endWireController.text),
      rejectionsTerminalFrom: int.parse(endTerminalControllerFrom.text == '' ? "0" : endTerminalControllerFrom.text),
      rejectionsTerminalTo: int.parse(endTerminalControllerTo.text == '' ? "0" : endTerminalControllerTo.text),
      setupRejectionCable: int.parse(setupRejectionsControllerCable.text == '' ? "0" : setupRejectionsControllerCable.text),
      setUpRejections: int.parse(setupRejectionsControllerCable.text == '' ? "0" : setupRejectionsControllerCable.text),
      setUpRejectionTerminalFrom: int.parse(setupRejectionsControllerFrom.text == '' ? "0" : setupRejectionsControllerFrom.text),
      setUpRejectionTerminalTo: int.parse(setupRejectionsControllerTo.text == '' ? "0" : setupRejectionsControllerTo.text),
      cvmRejectionsCable: int.parse(cvmRejectionsControllerCable.text == '' ? "0" : cvmRejectionsControllerCable.text),
      cvmRejectionsCableTerminalFrom: int.parse(cvmRejectionsControllerFrom.text == '' ? "0" : cvmRejectionsControllerFrom.text),
      cvmRejectionsCableTerminalTo: int.parse(cvmRejectionsControllerTo.text == '' ? "0" : cvmRejectionsControllerTo.text),
      cfmRejectionsCable: int.parse(cfmRejectionsControllerCable.text == '' ? "0" : cfmRejectionsControllerCable.text),
      cfmRejectionsCableTerminalFrom: int.parse(cfmRejectionsControllerFrom.text == '' ? "0" : cfmRejectionsControllerFrom.text),
      cfmRejectionsCableTerminalTo: int.parse(cfmRejectionsControllerTo.text == '' ? "0" : cfmRejectionsControllerTo.text),

      cableDamage: int.parse(cableDamageController.text == '' ? "0" : cableDamageController.text),
      lengthVariation: int.parse(lengthvariationController.text == '' ? "0" : lengthvariationController.text),
      rollerMark: int.parse(rollerMarkController.text == '' ? "0" : rollerMarkController.text),
      stringLengthVariation: int.parse(stripLengthVariationController.text == '' ? "0" : stripLengthVariationController.text),
      nickMark: int.parse(nickMarkController.text == '' ? "0" : nickMarkController.text),
      terminalDamage: int.parse(terminalDamageController.text == '' ? "0" : terminalDamageController.text),

      terminalBend: int.parse(terminalBendController.text == '' ? "0" : terminalBendController.text),
      terminalTwist: int.parse(terminalTwistController.text == '' ? "0" : terminalTwistController.text),
      windowGap: int.parse(windowGapController.text == '' ? "0" : windowGapController.text),
      crimpOnInsulationC: int.parse(crimpOnInsulationController.text == '' ? "0" : crimpOnInsulationController.text),
      bellMouthError: int.parse(bellMoutherrorController.text == '' ? "0" : bellMoutherrorController.text),
      cutOffBurr: int.parse(cutoffBarController.text == '' ? "0" : cutoffBarController.text),
      exposureStrands: int.parse(exposureStrandsController.text == '' ? "0" : exposureStrandsController.text),
// 5IYKJXTD6RRNHI6N
      strandsCut: int.parse(strandsCutController.text == '' ? "0" : strandsCutController.text),

      brushLengthLessorMore: int.parse(brushLengthLessorMoreController.text == '' ? "0" : brushLengthLessorMoreController.text),

      halfCurlingA: int.parse(halfCurlingController.text == '' ? "0" : halfCurlingController.text),
      wrongTerminal: int.parse(wrongTerminalController.text == '' ? "0" : wrongTerminalController.text),
      wrongCable: int.parse(wrongcableController.text == '' ? "0" : wrongcableController.text),
      seamOpen: int.parse(seamOpenController.text == '' ? "0" : seamOpenController.text),
      wrongCutLength: int.parse(wrongCutLengthController.text == '' ? "0" : wrongCutLengthController.text),
      missCrimp: int.parse(missCrimpController.text == '' ? "0" : missCrimpController.text),
      extrusionBurr: int.parse(extrusionBurrController.text == '' ? "0" : extrusionBurrController.text),

      //TODO

      method: widget.method,
      terminalFrom: int.parse('${terminalA?.terminalPart ?? '0'}'),
      terminalTo: int.parse('${terminalB?.terminalPart ?? '0'}'),
      awg: "${widget.schedule.awg}",
    );
  }
  // 8765607  500 900 RD 369100004 84671404

  PostGenerateLabel calculateTotal(PostGenerateLabel label) {
    int total = label.terminalDamage! +
        label.exposureStrands! +
        label.terminalBend! +
        label.cableDamage! +
        label.exposureStrands! +
        label.rollerMark! +
        label.terminalTwist! +
        label.halfCurlingA! +
        label.strandsCut! +
        label.windowGap! +
        label.endWire! +
        label.cutOffBurr! +
        label.cfmRejectionsCable! +
        label.cvmRejectionsCable! +
        label.cvmRejectionsCableTerminalFrom! +
        label.cvmRejectionsCableTerminalTo! +
        label.cfmRejectionsCableTerminalFrom! +
        label.cfmRejectionsCableTerminalTo! +
        label.setUpRejectionTerminalFrom! +
        label.setUpRejectionTerminalTo! +
        label.setUpRejections!;
    label.rejectedQuantity = total;
    return label;
  }

  Future<void> fullycompleteDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(contentPadding: EdgeInsets.all(0), title: Text('Not Enough Quantity to Complete Process'), actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Future.delayed(
                    const Duration(milliseconds: 50),
                    () {
                      SystemChannels.textInput.invokeMethod(keyboardType);
                    },
                  );
                },
                child: Text('     Ok    ')),
          ]);
        });
  }

  Future<void> partiallyCompleteDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              title: Text('Not Enough Quantity to Complete Process'),
              actions: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput.invokeMethod(keyboardType);
                        },
                      );
                    },
                    child: Text('     Ok    ')),
              ]);
        });
  }

  Future<void> showBundles() {
    getBundles();
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      binId: 0,
      scheduleId: int.parse(widget.schedule.scheduledId),
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: int.parse(widget.schedule.finishedGoodsNumber),
      cablePartNumber: int.parse(widget.schedule.cablePartNumber),
      orderId: widget.schedule.orderId.toString(),
    );

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return ShowBundleListWIP(
            terminalA: terminalA,
            terminalB: terminalB,
            postgetBundleMaste: postgetBundleMaste,
            machine: widget.machine,
            employee: widget.employee,
            schedule: widget.schedule,
          );
        });
  }

  Widget tripleQuantityCell({
    required String name,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerCable,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 70,
              child: Text(
                "$name",
                style: TextStyle(fontFamily: fonts.openSans, fontSize: 12),
              ),
            ),
            Container(
              width: !widget.method.contains('a')
                  ? !widget.method.contains("b")
                      ? 100 //c
                      : 180 //c-b
                  : !widget.method.contains("b")
                      ? 180 //a-c
                      : 266, //a-b-c
              child: Row(
                mainAxisAlignment: textEditingControllerCable != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                children: [
                  widget.method.contains("a")
                      ? Container(
                          height: 35,
                          width: 95,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerFrom,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerFrom;
                              });
                            },
                            style: TextStyle(fontSize: 11),
                            decoration: new InputDecoration(
                              labelText: "From Terminal",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                  textEditingControllerCable != null
                      ? Container(
                          height: 35,
                          width: 70,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerCable,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerCable;
                              });
                            },
                            style: TextStyle(fontSize: 12),
                            decoration: new InputDecoration(
                              labelText: "Cable",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                  widget.method.contains("b")
                      ? Container(
                          height: 35,
                          width: 95,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerTo,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerTo;
                              });
                            },
                            style: TextStyle(fontSize: 12),
                            decoration: new InputDecoration(
                              labelText: "To Terminal",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doubleQuantityCell({
    required String name,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 70,
              child: Text(
                "",
                style: TextStyle(fontFamily: fonts.openSans, fontSize: 12),
              ),
            ),
            Container(
              width: !widget.method.contains('a')
                  ? !widget.method.contains("b")
                      ? 100 //c
                      : 150 //c-b
                  : !widget.method.contains("b")
                      ? 150 //a-c
                      : 266, //a-b-c
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.method.contains("a")
                      ? Container(
                          height: 35,
                          width: 130,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerFrom,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerFrom;
                              });
                            },
                            style: TextStyle(fontSize: 11),
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                              labelText: " $name From ",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                  widget.method.contains("b")
                      ? Container(
                          height: 35,
                          width: 130,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerTo,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerTo;
                              });
                            },
                            style: TextStyle(fontSize: 12),
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                              labelText: "$name To",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell({
    required String name,
    required int quantity,
    required TextEditingController textEditingController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 35,
                width: 130,
                child: TextFormField(
                  readOnly: true,
                  showCursor: false,
                  controller: textEditingController,
                  onTap: () {
                    setState(() {
                      _output = '';
                      maincontroller = textEditingController;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  keyboardType: TextInputType.multiline,
                  decoration: new InputDecoration(
                    labelText: name,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityDisp() {
    double percent = widget.toalQuantity / int.parse(widget.schedule.scheduledQuantity);
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Quantity",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ))
          ],
        ),
        Stack(
          children: [
            Container(
              height: 60,
              width: 60,
              child: Center(
                  child: Text(
                "${(percent * 100).round()}%",
                style: TextStyle(color: percent >= 0.9 ? Colors.green : Colors.red),
              )),
            ),
            Container(
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  value: percent,
                  valueColor: AlwaysStoppedAnimation<Color>(percent >= 0.9 ? Colors.greenAccent : Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
        Text("${widget.toalQuantity}/${widget.schedule.scheduledQuantity}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            )),
      ],
    ));
  }

  Widget binScan() {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod(keyboardType);
      },
    );
    SystemChannels.textInput.invokeMethod(keyboardType);
    return Container(
      width: MediaQuery.of(context).size.width * 0.75 - 4,
      height: 250,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: RawKeyboardListener(
                focusNode: keyboardFocus,
                onKey: (event) => handleKey(event.data),
                child: TextField(
                    autofocus: true,
                    controller: _binController,
                    onSubmitted: (value) {
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput.invokeMethod(keyboardType);
                        },
                      );
                      if (_binController.text.length > 0) {
                        setState(() {
                          status = Status.scanBundle;
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: "Bin not Scanned",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    onTap: () {
                      _binController.clear();
                      setState(() {
                        SystemChannels.textInput.invokeMethod(keyboardType);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        SystemChannels.textInput.invokeMethod(keyboardType);
                        binId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _binController.text.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    SystemChannels.textInput.invokeMethod(keyboardType);
                                    _binController.clear();
                                  });
                                },
                                child: Icon(Icons.clear, size: 18, color: Colors.red))
                            : Container(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        labelText: 'Scan bin',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          //Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.red))),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) return Colors.white;
                              return Colors.white; // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '  Skip  ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            getBundles();
                            widget.sendData(generatedBundleList.length + 1);
                            status = Status.generateLabel;
                            clear();
                            if (widget.toalQuantity == int.parse(widget.schedule.scheduledQuantity)) {
                              // widget.fullcomplete();
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.transparent))),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                              return Colors.red.shade400; // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '  Scan Bin  ',
                          ),
                        ),
                        onPressed: () {
                          Future.delayed(
                            const Duration(milliseconds: 50),
                            () {
                              SystemChannels.textInput.invokeMethod(keyboardType);
                            },
                          );
                          if (_binController.text.length > 0) {
                            setState(() {
                              status = Status.scanBundle;
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: "Bin not Scanned",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget bundleScan() {
    SystemChannels.textInput.invokeMethod(keyboardType);
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bundle ID: ${getpostBundletoBin().bundleId}"),
            )),
        Container(
          width: MediaQuery.of(context).size.width * 0.75 - 4,
          height: 243,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 270,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: RawKeyboardListener(
                    focusNode: keyboardFocus,
                    onKey: (event) => handleKey(event.data),
                    child: TextField(
                        autofocus: true,
                        focusNode: _bundleFocus,
                        controller: _bundleScanController,
                        onSubmitted: (value) {
                          if (_bundleScanController.text.length > 0) {
                            if (_bundleScanController.text == getpostBundletoBin().bundleId) {
                              apiService!.postTransferBundletoBin(transferBundleToBin: [getpostBundletoBin()]).then((value) {
                                if (value != null) {
                                  BundleTransferToBin bundleTransferToBinTracking = value[0];
                                  Fluttertoast.showToast(
                                      msg:
                                          "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  setState(() {
                                    getBundles();
                                    widget.sendData(generatedBundleList.length + 1);
                                    clear();
                                    _bundleScanController.clear();
                                    _binController.clear();
                                    label = new GeneratedLabel();
                                    status = Status.generateLabel;
                                    if (widget.toalQuantity == int.parse(widget.schedule.scheduledQuantity)) {
                                      // widget.fullcomplete();
                                    }
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Unable to transfer Bundle to Bin",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: "Wrong Bundle Id",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Bundle Not Scanned",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        onTap: () {
                          setState(() {});
                        },
                        onChanged: (value) {
                          SystemChannels.textInput.invokeMethod(keyboardType);
                          setState(() {
                            bundleId = value;
                          });
                        },
                        decoration: new InputDecoration(
                            suffix: _bundleScanController.text.length > 1
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _bundleScanController.clear();
                                      });
                                    },
                                    child: Icon(Icons.clear, size: 18, color: Colors.red))
                                : Container(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                            ),
                            labelText: 'Scan Bundle',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.red))),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                return Colors.white; // Use the component's default.
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              status = Status.scanBin;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.transparent))),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                return Colors.red; // Use the component's default.
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save & Scan Next',
                            ),
                          ),
                          onPressed: () {
                            if (_bundleScanController.text.length > 0) {
                              if (_bundleScanController.text == getpostBundletoBin().bundleId) {
                                apiService!.postTransferBundletoBin(transferBundleToBin: [getpostBundletoBin()]).then((value) {
                                  if (value != null) {
                                    BundleTransferToBin bundleTransferToBinTracking = value[0];
                                    Fluttertoast.showToast(
                                        msg:
                                            "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    setState(() {
                                      getBundles();
                                      widget.sendData(generatedBundleList.length + 1);
                                      clear();
                                      _bundleScanController.clear();
                                      _binController.clear();
                                      label = new GeneratedLabel();
                                      status = Status.generateLabel;
                                      if (widget.toalQuantity == int.parse(widget.schedule.scheduledQuantity)) {
                                        // widget.fullcomplete();
                                      }
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Unable to transfer Bundle to Bin",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Wrong Bundle Id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Bundle Not Scanned",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.red))),
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) return Colors.red.shade200;
                                  return Colors.white; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                printerStatus = true;
                              });
                              DateTime now = DateTime.now();
                              _print(
                                ipaddress: "${widget.machine.printerIp}",
                                // ipaddress: "172.26.59.14",
                                bq: label!.bundleQuantity.toString(),
                                qr: "${label!.bundleId}",
                                routenumber1: "${label!.routeNo}",
                                date: now.day.toString() + "-" + now.month.toString() + "-" + now.year.toString(),
                                orderId: "${widget.schedule.orderId}",
                                fgPartNumber: "${widget.schedule.finishedGoodsNumber}",
                                cutlength: "${widget.schedule.length}",
                                cablepart: "${widget.schedule.cablePartNumber}",
                                wireGauge: "${label!.wireGauge}",
                                terminalfrom: "${label!.terminalFrom}",
                                terminalto: "${label!.terminalTo}",
                                userid: "${widget.employee.empId}",
                                shift: getShift(),
                                // shift       : "${widget.schedule.shiftNumber}",
                                machine: "${widget.machine.machineNumber}",
                              ).then((value) {
                                setState(() {
                                  printerStatus = false;
                                });
                              });
                            },
                            child: Icon(
                              Icons.print,
                              color: Colors.red,
                            ))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getShift() {
    DateTime time = DateTime.now();
    log(DateTime.now().toString());
    if (time.hour >= 6 && time.hour < 14) {
      return "1";
    } else if (time.hour >= 14 && time.hour < 22) {
      return "2";
    } else {
      return "3";
    }
  }

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod(keyboardType);
    });
  }

  TransferBundleToBin getpostBundletoBin() {
    TransferBundleToBin bundleToBin =
        TransferBundleToBin(userId: widget.employee.empId, binIdentification: _binController.text, bundleId: label!.bundleId!, locationId: '');
    return bundleToBin;
  }

  String otherTotal() {
    int getTotalint(List<TextEditingController> textList) {
      int total = 0;
      for (int i = 0; i < textList.length; i++) {
        total = total + int.parse(textList[i].text.length > 0 ? textList[i].text : '0');
      }
      return total;
    }

    return getTotalint([
      endWireController,
      endTerminalControllerFrom,
      endTerminalControllerTo,
      cfmRejectionsControllerCable,
      cfmRejectionsControllerFrom,
      cfmRejectionsControllerTo,
      cvmRejectionsControllerCable,
      cvmRejectionsControllerTo,
      cvmRejectionsControllerFrom,
      setupRejectionsControllerCable,
      setupRejectionsControllerFrom,
      setupRejectionsControllerTo
    ]).toString();
  }

  String total() {
    int total = int.parse(cableDamageController.text.length > 0 ? cableDamageController.text : '0') +
        int.parse(lengthvariationController.text.length > 0 ? lengthvariationController.text : '0') +
        int.parse(rollerMarkController.text.length > 0 ? rollerMarkController.text : '0') +
        int.parse(stripLengthVariationController.text.length > 0 ? stripLengthVariationController.text : '0') +
        int.parse(nickMarkController.text.length > 0 ? nickMarkController.text : '0') +
        int.parse(terminalDamageController.text.length > 0 ? terminalDamageController.text : '0') +
        int.parse(terminalBendController.text.length > 0 ? terminalBendController.text : '0') +
        int.parse(terminalTwistController.text.length > 0 ? terminalTwistController.text : '0') +
        int.parse(windowGapController.text.length > 0 ? windowGapController.text : '0') +
        int.parse(crimpOnInsulationController.text.length > 0 ? crimpOnInsulationController.text : '0') +
        int.parse(bellMoutherrorController.text.length > 0 ? bellMoutherrorController.text : '0') +
        int.parse(cutoffBarController.text.length > 0 ? cutoffBarController.text : '0') +
        int.parse(exposureStrandsController.text.length > 0 ? exposureStrandsController.text : '0') +
        int.parse(strandsCutController.text.length > 0 ? strandsCutController.text : '0') +
        int.parse(brushLengthLessorMoreController.text.length > 0 ? brushLengthLessorMoreController.text : '0') +
        int.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int.parse(wrongTerminalController.text.length > 0 ? wrongTerminalController.text : '0') +
        int.parse(wrongcableController.text.length > 0 ? wrongcableController.text : '0') +
        int.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int.parse(wrongCutLengthController.text.length > 0 ? wrongCutLengthController.text : '0') +
        int.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    return total == null ? '0' : total.toString();
  }

  Future<void> showBundleDetail(GeneratedBundle generatedBundle) async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context1) {
        return Center(
          child: AlertDialog(
            title: Container(
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context1);
                          },
                          icon: Icon(Icons.close),
                          color: Colors.red)),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Bundle Detail"),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  field(title: "Bundle ID", data: generatedBundle.label.bundleId ?? ''),
                                  field(title: "Bundle Qty", data: generatedBundle.bundleQty.toString()),
                                  field(title: "Bundle Status", data: "${generatedBundle.label.status}"),
                                  field(title: "Cut Length", data: "${generatedBundle.label.cutLength}"),
                                  field(title: "Color", data: "${generatedBundle.bundleDetail.color}"),
                                ],
                              ),
                              Column(
                                children: [
                                  field(title: "Cable Part Number", data: generatedBundle.bundleDetail.cablePartNumber.toString()),
                                  field(
                                    title: "Cable part Description",
                                    data: generatedBundle.bundleDetail.cablePartDescription,
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle.bundleDetail.finishedGoodsPart.toString(),
                                  ),
                                  field(
                                    title: "Order Id",
                                    data: generatedBundle.bundleDetail.orderId,
                                  ),
                                  field(
                                    title: "Update From",
                                    data: generatedBundle.bundleDetail.updateFromProcess,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                    title: "Machine Id",
                                    data: generatedBundle.bundleDetail.machineIdentification,
                                  ),
                                  field(
                                    title: "Schedule ID",
                                    data: generatedBundle.bundleDetail.scheduledId.toString(),
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle.bundleDetail.finishedGoodsPart.toString(),
                                  ),
                                  field(
                                    title: "Bin Id",
                                    data: generatedBundle.bundleDetail.binId.toString(),
                                  ),
                                  field(
                                    title: "Location Id",
                                    data: generatedBundle.bundleDetail.locationId,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget field({required String title, required String data}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$title",
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$data",
                  style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GeneratedBundle {
  String bundleQty;
  TransferBundleToBin transferBundleToBin;
  GeneratedLabel label;
  String rejectedQty;
  BundlesRetrieved bundleDetail;
  GeneratedBundle(
      {required this.rejectedQty, required this.bundleQty, required this.label, required this.transferBundleToBin, required this.bundleDetail});
}
