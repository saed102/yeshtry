import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';

class BrandSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;

  BrandSquareCard({Key key, this.id, this.image, this.name}) : super(key: key);

  @override
  _BrandSquareCardState createState() => _BrandSquareCardState();
}

class _BrandSquareCardState extends State<BrandSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BrandProducts(
            id: widget.id,
            brand_name: widget.name,
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16), bottom: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      width: double.infinity,
                      placeholder: 'assets/placeholder.png',
                      image:  widget.image==null ||widget.image==""  ?"https://yeshtry.com/public/assets/img/placeholder.jpg":widget.image,

                      fit: BoxFit.fill,
                    )),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
      ),
    );
  }
}
