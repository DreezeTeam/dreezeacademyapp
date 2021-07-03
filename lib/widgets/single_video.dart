import 'package:flutter/material.dart';
import 'package:kindergaten/Model/playModel.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:provider/provider.dart';
class SingleVideo extends StatefulWidget {
  final int index;
  final int  playingIndex;
  final bool isplaying;
  var position;
  var duration;
  Function(int) function;
  SingleVideo(this.index, this.playingIndex, this.isplaying, this.position, this.duration, this.function);
  @override
  _SingleVideoState createState() => _SingleVideoState();
}

class _SingleVideoState extends State<SingleVideo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //  color: Colors.grey
                ),
                height: 60,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 36,
                          padding:
                          const EdgeInsets.only(top: 5),
                          child: Image.asset(
                              'images/biology.png')),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${Provider.of<VideosModelProvider>(context, listen: true).videoName}",
                            style: appThemeDark.textTheme.title,
                          ),
                          ///text
                          Container(
                            height: 3,
                            width: 213.59,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    224, 240, 255, 1),
                                borderRadius:
                                BorderRadius.circular(
                                    45)),
                            child: FractionallySizedBox(
                              heightFactor: 1,
                              widthFactor:
                              widget.index ==widget.playingIndex && widget.isplaying?  (widget.position /
                                  widget.duration
                              ):0.01,

                              alignment:
                              FractionalOffset.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: appThemeDark
                                        .buttonColor,
                                    borderRadius:
                                    BorderRadius.circular(
                                        45)),
                              ),
                            ),
                          ),

                         widget.index ==widget.playingIndex
                              ?  Text(
                             widget.isplaying?
                              "${((widget.position /
                                  widget.duration) * 100).toStringAsFixed(2)}%":"00%"):Text("${Provider.of<VideosModelProvider>(context, listen: true).percentage.toStringAsFixed(2)}%"),


                        ],
                      ),
                      // if(index == _playing)   Icon(
                      //        Icons.music_note)

                      //end
                      // Text("$error"),
                    ])

              //   if (index == _playing)
            )
        ),

        onTap: () {
         widget.function(widget.index);
        }



    );
  }
}
