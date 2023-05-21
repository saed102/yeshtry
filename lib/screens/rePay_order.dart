import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';


class rePayorder extends StatefulWidget {
 int oeder_ID;

  rePayorder(
      {Key key,
       @required this.oeder_ID})
      : super(key: key);

  @override
  _rePayorderState createState() => _rePayorderState();
}

class _rePayorderState extends State<rePayorder> {

  String _initial_url = "";
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSetInitialUrl();
  }


  getSetInitialUrl() async {
    var paypalUrlResponse = await PaymentRepository().rePayorder(
        widget.oeder_ID);
    if (paypalUrlResponse.result == false) {
      ToastComponent.showDialog(paypalUrlResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = paypalUrlResponse.url;
    _initial_url_fetched = true;


    setState(() {});

    print(_initial_url);
    print(_initial_url_fetched);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  void getData() {
    print("calll....");
    _webViewController.currentUrl().then((value) {
      if (Uri.parse(value).queryParameters["success"] == "false") {
        Toast.show("Payment cancelled or failed  ", context,backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderList(from_checkout: true);
        }));
      } else if (Uri.parse(value).queryParameters["success"]== "true") {
        Toast.show("Payment Confirmed Chick your Order Now", context,backgroundColor: Colors.green,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderList(from_checkout: true);
        }));
      }
    });
  }

  buildBody() {
    if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text("fetching url"),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(_initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {

              _webViewController.currentUrl().then((value) =>
                  print(Uri.parse(value).queryParameters["success"])
              );
              print("mmmoo ${page.toString()}");
              if (page.contains("yeshtry")) {
                getData();
              }
            },
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Pay with your credit / debit card",
        style: TextStyle(fontSize: 18, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
