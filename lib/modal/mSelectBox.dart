import 'dart:convert';

List<MSelectBox> mSelectBoxFromJson(String str) => List<MSelectBox>.from(json.decode(str).map((x) => MSelectBox.fromJson(x)));

String mSelectBoxToJson(List<MSelectBox> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MSelectBox {
    MSelectBox({
        this.text,
        this.value,
    });

    String text;
    String value;

    factory MSelectBox.fromJson(Map<String, dynamic> json) => MSelectBox(
        text: json["Text"] == null ? null : json["Text"],
        value: json["Value"] == null ? null : json["Value"],
    );

    Map<String, dynamic> toJson() => {
        "Text": text == null ? null : text,
        "Value": value == null ? null : value,
    };
}
