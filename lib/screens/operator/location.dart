import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex_tab/model_api/process1/getBundleListGl.dart';
import '../../model_api/Transfer/binToLocation_model.dart';
import '../../model_api/Transfer/getBinDetail.dart';
import '../../model_api/login_model.dart';
import '../../model_api/machinedetails_model.dart';
import '../../utils/config.dart';
import '../Preparation/preparationDash.dart';
import '../operator%202/Home_0p2.dart';
import 'Homepage.dart';
import 'ReBinMap.dart';
import '../visual%20Inspector/Home_visual_inspector.dart';
import '../widgets/showBundles.dart';
import '../widgets/time.dart';
import '../../service/apiService.dart';

enum LocationType { finaTtransfer, partialTransfer, kittingTransfer }

class Location extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  String type;
  LocationType locationType;
  Location({required this.employee, required this.machine, required this.type, required this.locationType});
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _binController = new TextEditingController();
  FocusNode _binFocus = new FocusNode();
  FocusNode _locationFocus = new FocusNode();
  List<TransferBinToLocation> transferList = [];

  String? locationId;
  String? binId;
  bool hasLocation = false;
  ApiService apiService = new ApiService();

  TabController? _controller;
  @override
  void initState() {
    apiService = new ApiService();
    _controller = new TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    _locationFocus.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod(keyboardType);
      },
    );
    super.initState();
  }

  bool completeLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod(keyboardType);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey1,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          title: Text('Transfer', style: TextStyle(color: Colors.red)),
          elevation: 2,
          actions: [
            //machineID
            Container(
              padding: EdgeInsets.all(1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(
                              widget.employee.empId,
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        )),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.settings,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(widget.machine.machineNumber ?? "", style: TextStyle(fontSize: 13, color: Colors.black)),
                          ],
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),

            TimeDisplay(),
          ],
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.red,
            tabs: [
              Tab(
                child: Text("Bin Map", style: TextStyle(color: Colors.red)),
              ),
              Tab(
                child: Text("Location Map", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: completeTransfer(),
        body: TabBarView(
          controller: _controller,
          children: [
            ReMapBin(
              userId: widget.employee.empId,
              machine: widget.machine,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    location(),
                    bin(),
                    confirmTransfer(),
                    // completeTransfer(),
                  ]),
                ),
                Container(child: SingleChildScrollView(child: dataTable())),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod(keyboardType);
    });
  }

  Widget location() {
    SystemChannels.textInput.invokeMethod(keyboardType);

    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) => handleKey(event.data),
                    child: TextField(
                        focusNode: _locationFocus,
                        autofocus: true,
                        controller: _locationController,
                        onTap: () {
                          SystemChannels.textInput.invokeMethod(keyboardType);
                        },
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          setState(() {
                            locationId = value;
                          });
                        },
                        decoration: new InputDecoration(
                            suffix: _locationController.text.length > 1
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _locationController.clear();
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
                            labelText: 'Scan Location',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget confirmTransfer() {
    SystemChannels.textInput.invokeMethod(keyboardType);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.23,
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.green),
                ),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                  return Colors.green; // Use the component's default.
                },
              ),
            ),
            onPressed: () {
              ApiService apiService = new ApiService();
              if (transferList.map((e) => e.binIdentification).toList().contains(binId)) {
                Fluttertoast.showToast(
                  msg: "Bin is already added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                apiService.getBundlesinBin(binId ?? "").then((value) {
                  if (value != null) {
                    List<BundlesRetrieved> bundleist = value;
                    if (bundleist.length > 0) {
                      for (BundlesRetrieved bundle in value) {
                        if (!transferList.map((e) => e.bundleId).toList().contains(bundle.bundleIdentification)) {
                          setState(() {
                            transferList.add(TransferBinToLocation(
                                userId: widget.employee.empId,
                                binIdentification: binId ?? '',
                                bundleId: "${bundle.bundleIdentification}",
                                locationId: locationId ?? ''));
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "Bundle already Present",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }
                      setState(() {
                        _binController.clear();
                        binId = null;
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "No bundles Found in BIN",
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
                      msg: "Invalid Bin Id",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                });
              }

              // setState(() {
              //   _binController.clear();
              //   binId = null;
              // });
            },
            child: Text(
              'Transfer',
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  Widget completeTransfer() {
    SystemChannels.textInput.invokeMethod(keyboardType);

    return transferList.length > 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.20,
              child: completeLoading
                  ? ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                            return Colors.green.shade500; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        _controller!.index == 0 ? _controller!.animateTo(1) : postCompleteTransfer();
                        // postCompleteTransfer();
                        // _showConfirmationDialog();
                      },
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                            return Colors.green.shade500; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        _controller!.index == 0 ? _controller!.animateTo(1) : postCompleteTransfer();
                        // _showConfirmationDialog();
                      },
                      child: Text('Complete Transfer')),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.23,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) return Colors.red.shade200;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    _controller!.index == 0 ? _controller!.animateTo(1) : postCompleteTransfer();
                    // _showConfirmationDialog();
                  },
                  child: Text(
                    'Complete Transfer',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          );
  }

  Widget bin() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                          focusNode: _binFocus,
                          controller: _binController,
                          onTap: () {
                            SystemChannels.textInput.invokeMethod(keyboardType);
                            setState(() {
                              _binController.clear();
                              binId = null;
                            });
                          },
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            setState(() {
                              binId = value;
                            });
                          },
                          decoration: new InputDecoration(
                              suffix: _binController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _binController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear, size: 18, color: Colors.red))
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
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
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget dataTable() {
    int a = 1;

    return CustomTable(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.6,
        colums: [
          CustomCell(width: 100, child: Text('No.', style: TextStyle(fontWeight: FontWeight.w600))),
          CustomCell(width: 120, child: Text('Location Id', style: TextStyle(fontWeight: FontWeight.w600))),
          CustomCell(width: 100, child: Text('Bin Id', style: TextStyle(fontWeight: FontWeight.w600))),
          CustomCell(width: 100, child: Text('Bundles', style: TextStyle(fontWeight: FontWeight.w600))),
          CustomCell(width: 100, child: Text('Remove', style: TextStyle(fontWeight: FontWeight.w600))),
        ],
        rows: transferList
            .map(
              (e) => CustomRow(cells: [
                CustomCell(width: 100, child: Text("${a++}", style: TextStyle())),
                CustomCell(width: 120, child: Text(e.locationId ?? '', style: TextStyle())),
                CustomCell(width: 100, child: Text(e.binIdentification ?? '', style: TextStyle())),
                CustomCell(width: 100, child: Text(e.bundleId ?? '', style: TextStyle())),
                CustomCell(
                  width: 100,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        transferList.remove(e);
                      });
                    },
                  ),
                ),
              ]),
            )
            .toList());

    // return Container(
    //     height: MediaQuery.of(context).size.height,
    //     child: SingleChildScrollView(
    //       child: DataTable(
    //           columnSpacing: 40,
    //           columns: <DataColumn>[
    //             DataColumn(
    //               label: Text('No.',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Location Id',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bin Id',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bundles',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Remove',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //           ],
    //           rows: transferList
    //               .map(
    //                 (e) => DataRow(cells: <DataCell>[
    //                   DataCell(Text("${a++}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.locationId ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.binIdentification ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.bundleId ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(
    //                     IconButton(
    //                       icon: Icon(
    //                         Icons.delete,
    //                         color: Colors.red,
    //                       ),
    //                       onPressed: () {
    //                         setState(() {
    //                           transferList.remove(e);
    //                         });
    //                       },
    //                     ),
    //                   ),
    //                 ]),
    //               )
    //               .toList()),
    //     ));
  }

  postCompleteTransfer() {
    if (widget.locationType == LocationType.kittingTransfer) {
      Navigator.pop(context);
    }
    ApiService apiService = new ApiService();
    setState(() {
      completeLoading = true;
    });
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod(keyboardType);
      },
    );
    apiService.postTransferBinToLocation(transferList).then((value) {
      print("inside: ${widget.type}");
      if (value != null) {
        if (widget.locationType == LocationType.partialTransfer) {
          Navigator.pop(context);
          return 0;
        }
        setState(() {
          completeLoading = false;
        });

        if (widget.type == "preparation") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PreprationDash(
                      employee: widget.employee,
                      machineId: 'preparation',
                    )),
          );
          return 0;
        }
        if (widget.type == 'process') {
          apiService.getmachinedetails(widget.machine.machineNumber ?? '').then((value) {
            // Navigator.pop(context);
            MachineDetails machineDetails = value![0];
            Fluttertoast.showToast(
                msg: widget.machine.machineNumber ?? '',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            print("machineID:${widget.machine.machineNumber}");
            switch (machineDetails.category) {
              case "Manual Crimping":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePageOp2(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Manual Cutting":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Automatic Cut & Crimp":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Semi Automatic Strip and Crimp machine":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePageOp2(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Automatic Cutting":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              default:
                Fluttertoast.showToast(
                    msg: "Machine not Found",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
            }
          });
        }
        if (widget.type == 'visualInspection') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeVisualInspector(
                      employee: widget.employee,
                    )),
          );
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: "Transfer Failed",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
    });
  }

  skipTransfer() {
    if (widget.locationType == LocationType.kittingTransfer) {
      Navigator.pop(context);
    }
    if (widget.locationType == LocationType.partialTransfer) {
      Navigator.pop(context);
      return 0;
    }

    if (widget.type == "preparation") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PreprationDash(
                  employee: widget.employee,
                  machineId: 'preparation',
                )),
      );
      return 0;
    }
    if (widget.type == 'process') {
      apiService.getmachinedetails(widget.machine.machineNumber ?? "").then((value) {
        // Navigator.pop(context);
        MachineDetails machineDetails = value![0];
        Fluttertoast.showToast(
            msg: widget.machine.machineNumber ?? "",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        print("machineID:${widget.machine.machineNumber}");
        switch (machineDetails.category) {
          case "Manual Crimping":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageOp2(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Manual Cutting":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Automatic Cut & Crimp":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Semi Automatic Strip and Crimp machine":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageOp2(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Automatic Cutting":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          default:
            Fluttertoast.showToast(
                msg: "Machine not Found",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
        }
      });
    }
    if (widget.type == 'visualInspection') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeVisualInspector(
                  employee: widget.employee,
                )),
      );
    }
  }
}
