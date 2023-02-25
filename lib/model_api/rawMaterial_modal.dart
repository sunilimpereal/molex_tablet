
// To parse this JSON data, do
//
//     final getRawMaterial = getRawMaterialFromJson(jsonString);

import 'dart:convert';

GetRawMaterial getRawMaterialFromJson(String str) => GetRawMaterial.fromJson(json.decode(str));

String getRawMaterialToJson(GetRawMaterial data) => json.encode(data.toJson());

class GetRawMaterial {
    GetRawMaterial({
       required this.status,
       required this.statusMsg,
       required this.errorCode,
       required this.data,
    });

    String status;
    String statusMsg;
    dynamic errorCode;
    Data data;

    factory GetRawMaterial.fromJson(Map<String, dynamic> json) => GetRawMaterial(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.rawMaterialDetails,
    });

    List<RawMaterial> rawMaterialDetails;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        rawMaterialDetails: List<RawMaterial>.from(json["Raw Material Details "].map((x) => RawMaterial.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Raw Material Details ": List<dynamic>.from(rawMaterialDetails.map((x) => x.toJson())),
    };
}

class RawMaterial {
    RawMaterial({
        this.partNunber,
        this.uom,
        this.requireQuantity,
        this.toatalScheduleQuantity,
        this.description,
    });

    String? partNunber;
    String? uom;
    String? requireQuantity;
    String? toatalScheduleQuantity;
    String? description;

    factory RawMaterial.fromJson(Map<String, dynamic> json) => RawMaterial(
        partNunber: json["partNunber"],
        uom: json["uom"],
        requireQuantity: json["requireQuantity"],
        toatalScheduleQuantity: json["toatalScheduleQuantity"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "partNunber": partNunber,
        "uom": uom,
        "requireQuantity": requireQuantity,
        "toatalScheduleQuantity": toatalScheduleQuantity,
        "description": description,
    };
}
