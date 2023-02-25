import 'package:molex_tab/model_api/rawMaterial_modal.dart';

import '../../../model_api/schedular_model.dart';
import '../../utils/api/api_requests.dart';

class OperatorRepository {
  Future<List<Schedule>> getSchedularData({required String machId, required String type, required String sameMachine}) async {
    // get schedule list for auto cut and crimp
    Schedular? schedularResponse = await ApiRequest<String, Schedular>().get(
        url: "molex/scheduler/get-scheduler-same-machine-data?schdTyp=$type&mchNo=$machId&sameMachine=$sameMachine",
        reponseFromJson: schedularFromJson);
    List<Schedule> scheduleList = schedularResponse?.data.employeeList ?? [];
    return scheduleList;
  }

  Future<List<RawMaterial>> getRawmaterial(
      {required String machineId,
      required String partNo,
      required String fgNo,
      required String scheduleId,
      required String process,
      required String type}) async {
    //to get raw material for auto cut and crimp
    GetRawMaterial? getRawMaterialTo = await ApiRequest<String, GetRawMaterial>().get(
        url: "molex/scheduler/get-req-material-detail-to?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId", reponseFromJson: getRawMaterialFromJson);
    GetRawMaterial? getRawMaterialFrom = await ApiRequest<String, GetRawMaterial>().get(
        url: "molex/scheduler/get-req-material-detail-from?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId", reponseFromJson: getRawMaterialFromJson);
    GetRawMaterial? getRawMaterialCable = await ApiRequest<String, GetRawMaterial>()
        .get(url: "molex/scheduler/get-req-material-detail?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId", reponseFromJson: getRawMaterialFromJson);
    List<RawMaterial> rawmaterialListcable = getRawMaterialCable?.data.rawMaterialDetails ?? [];
    List<RawMaterial> rawmaterialListto = getRawMaterialTo?.data.rawMaterialDetails ?? [];
    List<RawMaterial> rawmaterialListfrom = getRawMaterialFrom?.data.rawMaterialDetails ?? [];

    List<RawMaterial> rawMateriallist = [];
    rawMateriallist = rawmaterialListcable + rawmaterialListto + rawmaterialListfrom;
    rawMateriallist = rawMateriallist.where((element) => element.partNunber != "0").toList();
    rawMateriallist = sortRawmaterial(rawMateriallist);
    return rawMateriallist;
  }
}

List<RawMaterial> sortRawmaterial(List<RawMaterial> rawmaterial) {
  //to sort the raw matrial with duplicate quantity
  rawmaterial.sort((a, b) => int.parse(a.partNunber ?? '0').compareTo(int.parse(b.partNunber ?? '0')));
  // log("mesin : " + rawmaterial.toString());
  RawMaterial temp = new RawMaterial();
  List<RawMaterial> newList = [];
  for (RawMaterial rawmat in rawmaterial) {
    if (temp.partNunber == rawmat.partNunber) {
      temp.requireQuantity = (double.parse(temp.requireQuantity ?? "") + double.parse(rawmat.requireQuantity ?? '')).toString();
      temp.toatalScheduleQuantity = (double.parse(temp.toatalScheduleQuantity ?? '') + double.parse(rawmat.toatalScheduleQuantity ?? '')).toString();
      newList.removeLast();
      newList.add(temp);
    } else {
      newList.add(rawmat);
      temp = rawmat;
      // s
    }
  }
  return newList;
}
