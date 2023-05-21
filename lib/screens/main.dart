import 'dart:io';

import 'package:active_ecommerce_flutter/custom/CommonFunctoins.dart';
import 'package:active_ecommerce_flutter/data_model/flash_deal_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    FlashDealList(),
    Cart(has_bottomnav: true),
    Profile()
  ];
  void onTapped(int i) {
      setState(() {
        _currentIndex = i;
      });
  }
  void initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink)async{
          final Uri deeplink = dynamicLink.link;
          print('mohamed saed $deeplink');
          if(deeplink != null){
            if(deeplink=="https://yeshtry.com/"){
              handleMyLink(deeplink);
            }
          }
        },
        onError: (OnLinkErrorException e)async{
          print("We got error $e");
        }

    );
  final  PendingDynamicLinkData data=await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri inintlink=data.link;
    if(inintlink!=null){
      if(inintlink=="https://yeshtry.page.link/yeshtry"){
        handleMyLink(inintlink);
      }    }
  }
  void handleMyLink(Uri url){
    List<String> sepeatedLink = [];
    sepeatedLink.addAll(url.path.split('/'));
    print("The Token that i'm interesed in is ${sepeatedLink[1]}");
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: Duration(milliseconds:400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation=CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
        return ScaleTransition(
            alignment: Alignment.bottomCenter,
            child: child,
            scale: animation);
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return ProductDetails(
          id:int.parse(sepeatedLink[1]) ,
        );
      },));
  }


  void initState() {
    // TODO: implement initState
    initDynamicLinks();

    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("_currentIndex");
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: MyTheme.accent_color,
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            onTap: onTapped,
            buttonBackgroundColor: Colors.transparent,
            index: _currentIndex,
            letIndexChange: (value) {
              if(!is_logged_in.$ && (value == 4 || value == 3)){
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 301),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    animation=CurvedAnimation(parent: animation, curve: Curves.linear);
                    return ScaleTransition(
                      alignment: Alignment.center,
                        child: child,
                        scale: animation);
                  },
                  pageBuilder: (context, animation, secondaryAnimation) {
                  return Login();
                },));
              }

              return !is_logged_in.$ && (value == 4 || value == 3)? false:true;
            },
            backgroundColor: Colors.transparent,
            height: 53,
            animationDuration: Duration(milliseconds: 400),
            color: Colors.white.withOpacity(0.8),
            items: [
              _currentIndex == 0?
                  Icon(Icons.home,color:Theme.of(context).accentColor ,size: 30,):
              Image.asset(
                "assets/home.png",
                color: _currentIndex == 0
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(153, 153, 153, 1),
                height: 20,
              ),

              Image.asset(
                "assets/categories.png",
                color: _currentIndex == 1
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(153, 153, 153, 1),
                height: 20,
              ),

              Image.asset(
                "assets/clearance.png",
                color: _currentIndex == 2
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(153, 153, 153, 1),
                height: 20,
              ),
              _currentIndex == 3?
              Icon(Icons.shopping_cart,color:Theme.of(context).accentColor ,):
              Image.asset(
                "assets/cart.png",
                color: _currentIndex == 3
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(153, 153, 153, 1),
                height: 20,
              ),
              _currentIndex == 4?
              Icon(Icons.person,color:Theme.of(context).accentColor ,):
              Image.asset(
                "assets/profile.png",
                color: _currentIndex == 4
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(153, 153, 153, 1),
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
