import 'dart:developer';

import 'package:bluecold/utils/ApiUrls.dart';
import 'package:http/http.dart' as http;

class ApiRequest<ReqModel, ResModel> {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': '<Your token>'
  };
  Future<ResModel?> post({
    required String url,
    required ReqModel request,
    required Function(String) reponseFromJson,
    required Function(ReqModel) requestToJson,
  }) async {
    // try {
    var uri = Uri.parse(ApiUrls.baseUrl + url);
    log("ApiRequest POST : $uri");
    log("ApiRequest Body : ${requestToJson(request)}");
    var response = await http.post(
      uri,
      body: requestToJson(request),
      headers: requestHeaders,
    );
    log("ApiRequest Response ${response.statusCode} : ${response.body}");
    if (response.statusCode == 202) {
      ResModel responseModel = reponseFromJson(response.body);
      return responseModel;
    }
    return null;
    // } catch (e) {
    //   return null;
    // }
  }
}
