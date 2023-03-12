import 'package:molex_tab/screens/utils/api/api_requests.dart';

import 'models/login_model.dart';

class AuthRepository {
  Future<Employee?> empIdlogin(String empId) async {
    Login? login = await ApiRequest<String, Login>().get(url: "molex/employee/get-employee-list/empid=$empId", reponseFromJson: loginFromJson);

    Employee empolyee = login!.data.employeeList;
    return empolyee;
  }
}
