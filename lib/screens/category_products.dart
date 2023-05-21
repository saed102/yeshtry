import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({Key key, this.category_name, this.category_id})
      : super(key: key);
  final String category_name;
  final int category_id;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {


  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _categreyhomeList = {};
  bool _isbrandinit=false;
  bool _isshortinit=false;
  List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;
  int _lodingIndex=2;
  List _brand = [
    {
      "id": "",
      "name": "${!app_language_rtl.$ ?"All Brands":"كل العلامات التجارية"}",
    }
  ];

  String _sealcted_short = "";
  String _sealcted_brand = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    getBrands();
    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  int numberofpage;

  getnumberofpage()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL}/brands"+
        "?page=1");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    setState(() {
      numberofpage = jsonDecode(response.body)["meta"]["last_page"];
    });
  }

  Future getBrands({name = "", }) async {

    await  getnumberofpage();

    for(int _page_brand=1 ;_page_brand <=numberofpage; _page_brand++){
      if(_page_brand==1){
        setState(() {
          _isshortinit=true;
        });
      }
      Uri url = Uri.parse("${AppConfig.BASE_URL}/brands"+
          "?page=${_page_brand}&name=${name}");
      final response = await http.get(url, headers: {
        "App-Language": app_language.$,
      });
      _categreyhomeList = jsonDecode(response.body);
      _categreyhomeList["data"].forEach((element) {
        _brand.add(element);
      });
      _categreyhomeList.clear();

    }
    setState(() {
      _isbrandinit=true;
    });
  }

  fetchData() async {
    var productResponse = await ProductRepository().getFilteredProducts(
        categories: widget.category_id,
        page: _page,
        name: _searchKey,
        sort_key: _sealcted_short,
        brands: _sealcted_brand);
    _productList.addAll(productResponse.products);
    _isInitial = false;
    _totalData = productResponse.meta.total;
    _showLoadingContainer = false;
    if(_productList.length.isEven){
      _lodingIndex=2;
    }
    if(_productList.length.isOdd){
      _lodingIndex=3;
    }
    if(_productList.length==_totalData){
      _lodingIndex=0;
    }
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List _short = [
      {
        "title": AppLocalizations.of(context).filter_screen_default,
        "value": ""
      },
      {
        "title": AppLocalizations.of(context).filter_screen_price_high_to_low,
        "value": "price_high_to_low"
      },
      {
        "title": AppLocalizations.of(context).filter_screen_price_low_to_high,
        "value": "price_low_to_high"
      },
      {
        "title": AppLocalizations.of(context).filter_screen_top_rated,
        "value": "top_rated"
      },
      {
        "title": AppLocalizations.of(context).filter_screen_popularity,
        "value": "popularity"
      },
      {
        "title": AppLocalizations.of(context).filter_screen_price_new_arrival,
        "value": "new_arrival"
      },
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBrandFilter(),
                _isshortinit?
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Text(
                          AppLocalizations.of(context)
                              .filter_screen_sort_products_by,
                          style: TextStyle(fontSize: 16,),

                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 0, bottom: 12, right: 20, left: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyTheme.accent_color,
                            border: Border.all(
                              color: MyTheme.accent_color,
                              width: 2,
                            )),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        height: 36,
                        child: new DropdownButton<String>(
                          borderRadius: BorderRadius.circular(20),

                          elevation: 4,
                          dropdownColor: MyTheme.accent_color,
                          isExpanded: true,
                          icon: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.expand_more, color: Colors.white),
                          ),
                          isDense: true,
                          hint: Text(
                            AppLocalizations.of(context)
                                .filter_screen_sort_products_by,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          iconSize: 14,
                          underline: SizedBox(),
                          value: _sealcted_short,
                          items: _short
                              .map((e) => DropdownMenuItem<String>(
                            value: e["value"],
                            child: Text(
                              e["title"],
                              style: TextStyle(color: MyTheme.white),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _sealcted_short = value;
                              print(_sealcted_short);
                              fetchData();
                              reset();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ):Expanded(
                  child: Shimmer.fromColors(
                    baseColor: MyTheme.shimmer_base,
                    highlightColor: MyTheme.shimmer_highlighted,
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  buildProductList(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildLoadingContainer())
                ],
              ),
            ),
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer&&_totalData == _productList.length ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text( AppLocalizations.of(context).common_no_more_products),
      ),
    );
  }


  Widget buildBrandFilter(){
    if(_isbrandinit){
      return   Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 5),
              child: Text(
                AppLocalizations.of(context).filter_screen_brands,
                style: TextStyle(fontSize: 16,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 0, bottom: 12, right: 20, left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyTheme.accent_color,
                  border: Border.all(
                    color: MyTheme.accent_color,
                    width: 2,
                  )),
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 36,
              child: new DropdownButton<String>(
                elevation: 4,
                menuMaxHeight: 200,
                dropdownColor: MyTheme.accent_color,
                isExpanded: true,
                icon: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.expand_more, color: Colors.white),
                ),
                isDense: true,
                hint: Text(
                  AppLocalizations.of(context).filter_screen_brands,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                iconSize: 14,
                borderRadius: BorderRadius.circular(20),
                underline: SizedBox(),

                value: _sealcted_brand,
                items: _brand
                    .map((e) => DropdownMenuItem<String>(
                  value: e["id"].toString(),
                  child: Text(
                    e["name"],
                    style:
                    TextStyle(color: MyTheme.white),
                  ),
                ))
                    .toList()
                ,
                onChanged: (value) {
                  setState(() {
                    _sealcted_brand = value;
                    print(_sealcted_brand);
                    fetchData();
                    reset();
                  });
                },
              ),
            ),
          ],
        ),
      );
    }else{
      return Expanded(
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child:
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            height: 60,
            color: Colors.white,
          ),
        ),
      );
    }

  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      /*bottom: PreferredSize(
          child: Container(
            color: MyTheme.textfield_grey,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),*/
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
          width: 250,
          child: TextField(
            controller: _searchController,
            onTap: () {},
            onChanged: (txt) {
              /*_searchKey = txt;
              reset();
              fetchData();*/
            },
            onSubmitted: (txt) {
              _searchKey = txt;
              reset();
              fetchData();
            },
            autofocus: false,
            decoration: InputDecoration(
                hintText:
                "${AppLocalizations.of(context).category_products_screen_search_products_from} : " +
                    widget.category_name,
                hintStyle:
                TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.all(0.0)),
          )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              reset();
              fetchData();
            },
          ),
        ),
      ],
    );
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: GridView.builder(
            // 2
            //addAutomaticKeepAlives: true,
            itemCount: _productList.length+_lodingIndex,
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.618),
            padding: EdgeInsets.all(16),
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if(index<_productList.length){
                return ProductCard(
                    id: _productList[index].id,
                    image: _productList[index].thumbnail_image,
                    name: _productList[index].name,
                    main_price: _productList[index].main_price,
                    stroked_price: _productList[index].stroked_price,
                    has_discount: _productList[index].has_discount);
              }else{
                return Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child:
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).common_no_data_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
