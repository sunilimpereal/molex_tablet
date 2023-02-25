import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex_tab/model_api/process1/getBundleListGl.dart';

import '../../model_api/crimping/bundleDetail.dart';
import '../../service/apiService.dart';
import '../../utils/config.dart';

Future<void> showBundleDetail(BuildContext context) async {
  Future.delayed(
    const Duration(milliseconds: 50),
    () {
      SystemChannels.textInput.invokeMethod(keyboardType);
    },
  );
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Center(child: ShowBundleDetail());
    },
  );
}

enum STATE {
  scanBundle,
  detail,
}

class ShowBundleDetail extends StatefulWidget {
  const ShowBundleDetail({Key? key}) : super(key: key);

  @override
  _ShowBundleDetailState createState() => _ShowBundleDetailState();
}

class _ShowBundleDetailState extends State<ShowBundleDetail> {
  STATE state = STATE.scanBundle;
  FocusNode keyboardFocus = new FocusNode();
  TextEditingController _bundleController = new TextEditingController();
  late String bundleId;
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod(keyboardType);
      },
    );
    SystemChannels.textInput.invokeMethod(keyboardType);

    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        title: Stack(
          children: [
            state == STATE.scanBundle ? scanBundle() : showDetail(),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))
          ],
        ));
  }

  Widget scanBundle() {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod(keyboardType);
      },
    );
    return Container(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.all(10.0),
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
                        controller: _bundleController,
                        onSubmitted: (value) {
                          Future.delayed(
                            const Duration(milliseconds: 50),
                            () {
                              SystemChannels.textInput.invokeMethod(keyboardType);
                            },
                          );
                        },
                        onTap: () {
                          _bundleController.clear();
                          setState(() {
                            SystemChannels.textInput.invokeMethod(keyboardType);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            SystemChannels.textInput.invokeMethod(keyboardType);
                            bundleId = value;
                          });
                        },
                        decoration: new InputDecoration(
                            suffix: _bundleController.text.length > 1
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        SystemChannels.textInput.invokeMethod(keyboardType);
                                        _bundleController.clear();
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
              //Scan Bin Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
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
                              '  Scan Bundle  ',
                            ),
                          ),
                          onPressed: () {
                            Future.delayed(
                              const Duration(milliseconds: 50),
                              () {
                                SystemChannels.textInput.invokeMethod(keyboardType);
                              },
                            );
                            if (_bundleController.text.length > 0) {
                              setState(() {
                                state = STATE.detail;
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: "Bundle not Scanned",
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
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleKey(
    RawKeyEventData key,
  ) {
    setState(() {
      SystemChannels.textInput.invokeMethod(keyboardType);
    });
  }

  Widget showDetail() {
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
                ),
              ],
            )
          ],
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
          future: apiService.getBundleDetail(bundleId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              BundlesRetrieved? bundleData = snapshot.data as BundlesRetrieved?;
              return Column(
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
                          field(title: "Bundle ID", data: bundleData!.bundleIdentification ?? ''),
                          field(title: "Bundle Qty", data: bundleData.bundleQuantity.toString()),
                          field(title: "Bundle Status", data: bundleData.bundleStatus ?? ''),
                          field(title: "Cut Length", data: bundleData.cutLengthSpecificationInmm.toString()),
                          field(title: "Color", data: bundleData.color ?? ""),
                        ],
                      ),
                      Column(
                        children: [
                          field(title: "Cable Part Number", data: bundleData.cablePartNumber.toString()),
                          field(
                            title: "Cable part Description",
                            data: bundleData.cablePartDescription ?? '',
                          ),
                          field(
                            title: "Finished Goods",
                            data: bundleData.finishedGoodsPart.toString(),
                          ),
                          field(
                            title: "Order Id",
                            data: bundleData.orderId ?? "",
                          ),
                          field(
                            title: "Update From",
                            data: bundleData.updateFromProcess ?? "",
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          field(
                            title: "Machine Id",
                            data: bundleData.machineIdentification ?? '',
                          ),
                          field(
                            title: "Schedule ID",
                            data: bundleData.scheduledId.toString(),
                          ),
                          field(
                            title: "Finished Goods",
                            data: bundleData.finishedGoodsPart.toString(),
                          ),
                          field(
                            title: "Bin Id",
                            data: bundleData.binId.toString(),
                          ),
                          field(
                            title: "Location Id",
                            data: bundleData.locationId ?? '',
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Column(
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
                  snapshot.connectionState == ConnectionState.done
                      ? Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Bundle Not Found"),
                              ),
                              Container(
                                width: 150,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.transparent))),
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) return Colors.green.shade200;
                                        return Colors.red.shade400; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Scan Again  ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.replay_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      state = STATE.scanBundle;
                                      bundleId = "";
                                      _bundleController.clear();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              );
            }
          }),
    );
  }
}
