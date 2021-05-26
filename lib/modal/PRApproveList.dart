// To parse this JSON data, do
//
//     final prApproveList = prApproveListFromJson(jsonString);

import 'dart:convert';

List<PrApproveList> prApproveListFromJson(String str) =>
    List<PrApproveList>.from(
        json.decode(str).map((x) => PrApproveList.fromJson(x)));

String prApproveListToJson(List<PrApproveList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrApproveList {
  PrApproveList({
    this.rowId,
    this.prNumber,
    this.vender,
    this.types,
    this.addvancePayment,
    this.department,
    this.requestBy,
    this.requestDate,
    this.requireDate,
    this.forProject,
    this.status,
    this.detail,
    this.discount,
    this.amountDiscount,
    this.total,
    this.subTotal,
    this.uploadquotation,
    this.uploadfile,
    this.uploadApprovedfile,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.subSection,
    this.statusLog,
    this.levelsLog,
    this.actionLog,
    this.dateLog,
    this.details,
  });

  int rowId;
  String prNumber;
  String vender;
  String types;
  String addvancePayment;
  String department;
  String requestBy;
  DateTime requestDate;
  DateTime requireDate;
  String forProject;
  String status;
  String detail;
  double discount;
  double amountDiscount;
  double total;
  double subTotal;
  String uploadquotation;
  String uploadfile;
  String uploadApprovedfile;
  String createBy;
  DateTime createDate;
  String updateBy;
  String updateDate;
  String subSection;
  String statusLog;
  String levelsLog;
  String actionLog;
  String dateLog;
  List<Detail> details;

  factory PrApproveList.fromJson(Map<String, dynamic> json) => PrApproveList(
        rowId: json["rowId"] == null ? null : json["rowId"],
        prNumber: json["PRNumber"] == null ? null : json["PRNumber"],
        vender: json["vender"] == null ? null : json["vender"],
        types: json["types"] == null ? null : json["types"],
        addvancePayment:
            json["addvancePayment"] == null ? null : json["addvancePayment"],
        department: json["department"] == null ? null : json["department"],
        requestBy: json["requestBy"] == null ? null : json["requestBy"],
        requestDate: json["requestDate"] == null
            ? null
            : DateTime.parse(json["requestDate"]),
        requireDate: json["requireDate"] == null
            ? null
            : DateTime.parse(json["requireDate"]),
        forProject: json["forProject"] == null ? null : json["forProject"],
        status: json["status"] == null ? null : json["status"],
        detail: json["detail"] == null ? null : json["detail"],
        discount: json["discount"] == null ? null : json["discount"],
        amountDiscount: json["amountDiscount"] == null
            ? null
            : json["amountDiscount"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        subTotal: json["subTotal"] == null ? null : json["subTotal"].toDouble(),
        uploadquotation:
            json["uploadquotation"] == null ? null : json["uploadquotation"],
        uploadfile: json["uploadfile"] == null ? null : json["uploadfile"],
        uploadApprovedfile: json["uploadApprovedfile"] == null
            ? null
            : json["uploadApprovedfile"],
        createBy: json["createBy"] == null ? null : json["createBy"],
        createDate: json["createDate"] == null
            ? null
            : DateTime.parse(json["createDate"]),
        updateBy: json["updateBy"] == null ? null : json["updateBy"],
        updateDate: json["updateDate"] == null ? null : json["updateDate"],
        subSection: json["sub_section"] == null ? null : json["sub_section"],
        statusLog: json["statusLog"] == null ? null : json["statusLog"],
        levelsLog: json["levelsLog"] == null ? null : json["levelsLog"],
        actionLog: json["actionLog"] == null ? null : json["actionLog"],
        dateLog: json["dateLog"] == null ? null : json["dateLog"],
        details: json["Details"] == null
            ? null
            : List<Detail>.from(json["Details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rowId": rowId == null ? null : rowId,
        "PRNumber": prNumber == null ? null : prNumber,
        "vender": vender == null ? null : vender,
        "types": types == null ? null : types,
        "addvancePayment": addvancePayment == null ? null : addvancePayment,
        "department": department == null ? null : department,
        "requestBy": requestBy == null ? null : requestBy,
        "requestDate": requestDate == null
            ? null
            : "${requestDate.year.toString().padLeft(4, '0')}-${requestDate.month.toString().padLeft(2, '0')}-${requestDate.day.toString().padLeft(2, '0')}",
        "requireDate": requireDate == null
            ? null
            : "${requireDate.year.toString().padLeft(4, '0')}-${requireDate.month.toString().padLeft(2, '0')}-${requireDate.day.toString().padLeft(2, '0')}",
        "forProject": forProject == null ? null : forProject,
        "status": status == null ? null : status,
        "detail": detail == null ? null : detail,
        "discount": discount == null ? null : discount,
        "amountDiscount": amountDiscount == null ? null : amountDiscount,
        "total": total == null ? null : total,
        "subTotal": subTotal == null ? null : subTotal,
        "uploadquotation": uploadquotation == null ? null : uploadquotation,
        "uploadfile": uploadfile == null ? null : uploadfile,
        "uploadApprovedfile":
            uploadApprovedfile == null ? null : uploadApprovedfile,
        "createBy": createBy == null ? null : createBy,
        "createDate": createDate == null
            ? null
            : "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
        "updateBy": updateBy == null ? null : updateBy,
        "updateDate": updateDate == null ? null : updateDate,
        "sub_section": subSection == null ? null : subSection,
        "statusLog": statusLog == null ? null : statusLog,
        "levelsLog": levelsLog == null ? null : levelsLog,
        "actionLog": actionLog == null ? null : actionLog,
        "dateLog": dateLog == null ? null : dateLog,
        "Details": details == null
            ? null
            : List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.rowId,
    this.prNumber,
    this.productCode,
    this.productName,
    this.itemColor,
    this.glNo,
    this.glDesc,
    this.qty,
    this.uom,
    this.unitPrice,
    this.discount,
    this.amountDiscount,
    this.amount,
    this.currency,
    this.remark,
    this.uploadPicture,
    this.types,
    this.textFree,
  });

  int rowId;
  String prNumber;
  String productCode;
  String productName;
  String itemColor;
  String glNo;
  String glDesc;
  double qty;
  String uom;
  double unitPrice;
  double discount;
  double amountDiscount;
  double amount;
  String currency;
  String remark;
  String uploadPicture;
  String types;
  String textFree;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        rowId: json["rowId"] == null ? null : json["rowId"],
        prNumber: json["PRNumber"] == null ? null : json["PRNumber"],
        productCode: json["productCode"] == null ? null : json["productCode"],
        productName: json["productName"] == null ? null : json["productName"],
        itemColor: json["itemColor"] == null ? null : json["itemColor"],
        glNo: json["GLNo"] == null ? null : json["GLNo"],
        glDesc: json["GLDesc"] == null ? null : json["GLDesc"],
        qty: json["qty"] == null ? null : json["qty"],
        uom: json["uom"] == null ? null : json["uom"],
        unitPrice:
            json["unitPrice"] == null ? null : json["unitPrice"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"],
        amountDiscount: json["amountDiscount"] == null
            ? null
            : json["amountDiscount"].toDouble(),
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        currency: json["currency"] == null ? null : json["currency"],
        remark: json["remark"] == null ? null : json["remark"],
        uploadPicture:
            json["uploadPicture"] == null ? null : json["uploadPicture"],
        types: json["types"] == null ? null : json["types"],
        textFree: json["textFree"] == null ? null : json["textFree"],
      );

  Map<String, dynamic> toJson() => {
        "rowId": rowId == null ? null : rowId,
        "PRNumber": prNumber == null ? null : prNumber,
        "productCode": productCode == null ? null : productCode,
        "productName": productName == null ? null : productName,
        "itemColor": itemColor == null ? null : itemColor,
        "GLNo": glNo == null ? null : glNo,
        "GLDesc": glDesc == null ? null : glDesc,
        "qty": qty == null ? null : qty,
        "uom": uom == null ? null : uom,
        "unitPrice": unitPrice == null ? null : unitPrice,
        "discount": discount == null ? null : discount,
        "amountDiscount": amountDiscount == null ? null : amountDiscount,
        "amount": amount == null ? null : amount,
        "currency": currency == null ? null : currency,
        "remark": remark == null ? null : remark,
        "uploadPicture": uploadPicture == null ? null : uploadPicture,
        "types": types == null ? null : types,
        "textFree": textFree == null ? null : textFree,
      };
}
