

class AttributeModel {
  String title;
  String link;
  String tvgID;
  String tvglogo;
  String grouptitle;
  String type;
 int dbId;
  AttributeModel({this.title, this.link,this.tvgID, this.tvglogo,this.grouptitle, this.type, this.dbId});
  factory   AttributeModel.fromJson(Map<String, dynamic> json){
    var attrr =  AttributeModel(
      title: json['title'] as String,
      link: json['link'] as String,
      tvgID:json['tv_id'] as String,
     tvglogo: json['logo'] as String,
     grouptitle: json['group_title'] as String,
     type: json['type'] as String,


    );
    return attrr;
  }
}