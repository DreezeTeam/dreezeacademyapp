

class PriceModel {
  String month;
  String package;
  String original;
  String main;
  String discount;
  String description;
  PriceModel({this.month, this.package,this.original, this.main,this.discount, this.description});
  factory   PriceModel.fromJson(Map<String, dynamic> json){
    var attrr =  PriceModel(
      month: json['0'] as String,
      package: json['1'] as String,
      original:json['2'] as String,
      main: json['3'] as String,
      discount: json['4'] as String,
      description: json['5'] as String,


    );
    return attrr;
  }
}