import 'package:flutter/material.dart';
import 'package:kindergaten/Model/attributeModel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/provider/homenotifier.dart';
import 'package:kindergaten/screen/playScreen.dart';
import 'package:provider/provider.dart';
class ExploreItems extends StatefulWidget {
  final List<AttributeModel> searchcontents;
    ExploreItems(this.searchcontents);
  @override
  _ExploreItemsState createState() => _ExploreItemsState();
}

class _ExploreItemsState extends State<ExploreItems> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      // height: Config.yMargin(context, 90),
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount:  widget.searchcontents.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio:9/17,

          crossAxisCount: 3,
        ),
        itemBuilder: (ctx, index){
          return InkWell(
            child: Container(
              height: Config.yMargin(context, 28),
              width:  Config.xMargin(context, 25),
              // padding: EdgeInsets.all(8.0),
              color: appThemeDark.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.searchcontents[index].tvglogo.isNotEmpty
                      ?  Container(
                    height: Config.yMargin(context, 20),

                    decoration: BoxDecoration(
                        color: appThemeDark.primaryColorLight,
                        image: DecorationImage(
                            fit: BoxFit.cover,

                            image: NetworkImage(widget.searchcontents[index].tvglogo)
                        )

                    ),
                    // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                    // fit: BoxFit.fill,),

                  ):
                  Container(
                      height: Config.yMargin(context, 28),
                      decoration: BoxDecoration(
                      )),
                  SizedBox(height: 5,),
                  Flexible(
                    child: Text(widget.searchcontents[index].title,style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),),
                  ),

                ],
              ),
            ),
            onTap: (){
              Provider.of<HomeNotifier>(context, listen: false).changeview(2);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx){
                    // return vlcPlayer(moviescontents,movies[index],2);
                    return PlayScreen();
                    //     return TestingScreen(indexL,contents,page1index);
                  }
              ));
            },
          );


        },
      ),
    );
  }
}
