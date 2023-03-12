import 'package:molex_tab/model_api/machinedetails_model.dart';
import 'package:molex_tab/screens/utils/api/api_requests.dart';

class MachineRepository {
  Future<List<MachineDetails>?> getmachineDetail({required String machineId}) async {
    GetMachineDetails? getMachineDetails = await ApiRequest<String, GetMachineDetails>()
        .get(url: "molex/machine/get-by-machine-number?machNo=$machineId", reponseFromJson: getMachineDetailsFromJson);

    List<MachineDetails> machineDetails = getMachineDetails?.data.machineDetailsList ?? [];
    return machineDetails.length != 0 ? machineDetails : null;
  }
}
