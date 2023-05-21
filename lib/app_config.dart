import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text =
      "@ YESHTRY " + this_year; //this shows in the splash screen
  static String app_name = "YESHTRY"; //this shows in the splash screen
  static String purchase_code = "fe36ae13-3b55-445d-a172-d595badadb87"; //enter your purchase code for the app from codecanyon
  //static String purchase_code = ""; //enter your purchase code for the app from codecanyon
//https://yeshtry.com/api/v2/products/search?page=1&name=&sort_key=&brands=&categories=Dresses&min=&max="
  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS = true;

  //configure this
  // static const DOMAIN_PATH = "192.168.1.112/ecommerce"; //localhost
  static const DOMAIN_PATH = "yeshtry.com"; //inside a folder
  //static const DOMAIN_PATH = "mydomain.com"; // directly inside the public folder
  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
}
