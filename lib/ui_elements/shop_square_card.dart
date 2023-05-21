import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';

class ShopSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;

  ShopSquareCard({Key key, this.id, this.image, this.name}) : super(key: key);

  @override
  _ShopSquareCardState createState() => _ShopSquareCardState();
}

class _ShopSquareCardState extends State<ShopSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SellerDetails(
            id: widget.id,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          width: double.infinity,
                          placeholder: 'assets/placeholder.png',
                          image:  widget.image==null ||widget.image==""  ?"https://yeshtry.com/public/assets/img/placeholder.jpg":widget.image,

                          fit: BoxFit.cover,
                        ))),
              ),

              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Text(
                      widget.name ,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
