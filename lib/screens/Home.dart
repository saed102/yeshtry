import 'package:active_ecommerce_flutter/custom/CommonFunctoins.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/FeatureProducts.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false, go_back = true})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  bool show_back_button;
  bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _carouselImageList = [];
  Map<String, dynamic> _categreyhomeList = {};
  var _bannerImageList = [];
  var _banner3ImageList = [];
  var _banner2ImageList = [];
  var _getBastProductList = [];
  var _getNewProductList = [];
  var _featuredCategoryList = [];
  var _featuredProductList = [];
  bool _isProductInitial = true;
  bool _isCategreyHomeInitial = true;
  bool _isBastProductInitial = true;
  bool _isNewProductInitial = true;
  bool _isCategoryInitial = true;
  bool _isCarouselInitial = true;
  bool _isbannerlInitial = true;
  bool _isbanner3lInitial = true;
  bool _isbanner2lInitial = true;
  int _totalProductData = 0;
  int _totalBastProductData = 0;
  int _totalNewProductData = 0;
  int _productPage = 1;

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  fetchAll() {
    getcategeryhome();
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchbannerImages();
    fetchFeaturedProducts();
    fetchbastsellingProducts();
    fetchNewProducts();
    fetchbanner3Images();
    fetchbanner2Images();
  }

  Future getcategeryhome() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/categories/home");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    _categreyhomeList = jsonDecode(response.body);
    _isCategreyHomeInitial = false;
    setState(() {});
  }

  fetchCarouselImages() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/sliders");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    _carouselImageList = jsonDecode(response.body)["data"];
    _isCarouselInitial = false;
    setState(() {});
  }

  fetchbannerImages() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/banners");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    _bannerImageList = jsonDecode(response.body)["data"];
    _isbannerlInitial = false;
    setState(() {});
  }

  fetchbanner3Images() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/banners/home3");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    _banner3ImageList = jsonDecode(response.body)["data"];
    _isbanner3lInitial = false;
    setState(() {});
  }

  fetchbanner2Images() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/banners/home2");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    _banner2ImageList = jsonDecode(response.body)["data"];
    _isbanner2lInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _productPage,
    );

    _featuredProductList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    setState(() {});
  }

  fetchbastsellingProducts() async {
    var productResponse = await ProductRepository().getBestSellingProducts();
    _getBastProductList.addAll(productResponse.products);
    _isBastProductInitial = false;
    setState(() {});
  }

  fetchNewProducts() async {
    var productResponse = await ProductRepository().getNewProducts();
    _getNewProductList.addAll(productResponse.products);
    _isNewProductInitial = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _bannerImageList.clear();
    _banner3ImageList.clear();
    _banner2ImageList.clear();
    _featuredCategoryList.clear();
    _isCarouselInitial = true;
    _isbannerlInitial = true;
    _isbanner3lInitial = true;
    _isbanner2lInitial = true;
    _isCategoryInitial = true;
    setState(() {});
    resetProductList();
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetProductList() {
    _featuredProductList.clear();
    _getBastProductList.clear();
    _getNewProductList.clear();
    _isBastProductInitial = true;
    _isNewProductInitial = true;
    _isProductInitial = true;
    _totalProductData = 0;
    _totalBastProductData = 0;
    _productPage = 1;
    setState(() {});
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    //print(MediaQuery.of(context).viewPadding.top);

    return WillPopScope(
      onWillPop: () async {
        CommonFunctions(context).appExitDialog();
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
        app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: buildAppBar(statusBarHeight, context),
            drawer: MainDrawer(),
            body: RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8.0,
                          16.0,
                          8.0,
                          0.0,
                        ),
                        child: buildHomeCarouselSlider(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8.0,
                          16.0,
                          8.0,
                          0.0,
                        ),
                        child: buildHomeMenuRow(context),
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations
                                  .of(context)
                                  .home_screen_featured_categories,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: SizedBox(
                        height: 154,
                        child: buildHomeFeaturedCategories(context),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Text(
                          !app_language_rtl.$
                              ? "New Products"
                              : "المنتجات الجديده",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: SizedBox(
                        height: 320,
                        child: buildHomeNewProducts(context),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: buildHomeBanner(context),
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations
                                      .of(context)
                                      .home_screen_featured_products,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            MyTheme.accent_color)),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return FeatureProducts();
                                      }));
                                    },
                                    child: Text(
                                      !app_language_rtl.$ ? "View more" : "عرض المزيد",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: SizedBox(
                        height: 320,
                        child: buildHomeFeaturedProducts(context),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(
                              bottom: 6, right: 16, left: 16),
                            child: buildHomeBanner2(context),),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              0.0,
                            ),
                            child: Text(
                              !app_language_rtl.$
                                  ? "Best Selling"
                                  : "أفضل مبيعات",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: SizedBox(
                        height: 320,
                        child: buildHomeBastProducts(context),
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 0, right: 8, left: 8, top: 8),
                              child: buildHomeBanner3(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                0.0,
                                16.0,
                                0.0,
                                0.0,
                              ),
                              child: buildcategaryhome(),
                            ),

                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  buildHomeFeaturedProducts(context) {
    if (_isProductInitial && _featuredProductList.length == 0) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),

          ],
        ),
      );
    } else if (_featuredProductList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
        physics: BouncingScrollPhysics(),

        scrollDirection: Axis.horizontal,

        itemCount: _featuredProductList.length,
        itemExtent: 150,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: _featuredProductList[index].id,
              image: _featuredProductList[index].thumbnail_image,
              name: _featuredProductList[index].name,
              main_price: _featuredProductList[index].main_price,
              stroked_price: _featuredProductList[index].stroked_price,
              has_discount: _featuredProductList[index].has_discount);
        },
      );
    } else if (_totalProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations
                  .of(context)
                  .common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeBastProducts(context) {
    if (_isBastProductInitial && _getBastProductList.length == 0) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),

          ],
        ),
      );
    } else if (_getBastProductList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
        physics: BouncingScrollPhysics(),

        scrollDirection: Axis.horizontal,
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _getBastProductList.length,
        itemExtent: 150,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: _getBastProductList[index].id,
              image: _getBastProductList[index].thumbnail_image,
              name: _getBastProductList[index].name,
              main_price: _getBastProductList[index].main_price,
              stroked_price: _getBastProductList[index].stroked_price,
              has_discount: _getBastProductList[index].has_discount);
        },
      );
    } else if (_totalBastProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations
                  .of(context)
                  .common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeNewProducts(context) {
    if (_isNewProductInitial && _getNewProductList.length == 0) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                child: ShimmerHelper().buildBasicShimmer(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width - 32) / 3)),

          ],
        ),
      );
    } else if (_getNewProductList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
        physics: BouncingScrollPhysics(),

        scrollDirection: Axis.horizontal,
        itemCount: _getNewProductList.length,
        itemExtent: 150,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: _getNewProductList[index].id,
              image: _getNewProductList[index].thumbnail_image,
              name: _getNewProductList[index].name,
              main_price: _getNewProductList[index].main_price,
              stroked_price: _getNewProductList[index].stroked_price,
              has_discount: _getNewProductList[index].has_discount);
        },
      );
    } else if (_totalNewProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations
                  .of(context)
                  .common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeFeaturedCategories(context) {
    if (_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 32) / 3)),
        ],
      );
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: _featuredCategoryList.length,
          itemExtent: 120,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CategoryProducts(
                      category_id: _featuredCategoryList[index].id,
                      category_name: _featuredCategoryList[index].name,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.zero),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: _featuredCategoryList[index].banner,
                                fit: BoxFit.cover,
                              ))),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                        child: Container(
                          height: 32,
                          child: Text(
                            _featuredCategoryList[index].name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 11, color: MyTheme.font_grey,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .home_screen_no_category_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoryList(
                  is_top_category: true,
                );
              }));
            },
            child: Container(
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: MyTheme.light_grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset("assets/top_categories.png"),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      AppLocalizations
                          .of(context)
                          .home_screen_top_categories,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  selected_filter: "brands",
                );
              }));
            },
            child: Container(
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: MyTheme.light_grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          "assets/64.png", color: MyTheme.accent_color,),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 0),
                      child: Text(
                          AppLocalizations
                              .of(context)
                              .home_screen_brands,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(132, 132, 132, 1),
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FeatureProducts();
              }));
            },
            child: Container(
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: MyTheme.light_grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset("assets/top_sellers.png"),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                          AppLocalizations
                              .of(context)
                              .home_screen_featured_products,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(132, 132, 132, 1),
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TodaysDealProducts();
              }));
            },
            child: Container(
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: MyTheme.light_grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset("assets/todays_deal.png"),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                          AppLocalizations
                              .of(context)
                              .home_screen_todays_deal,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(132, 132, 132, 1),
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FlashDealList();
              }));
            },
            child: Container(
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 57,
                      width: 57,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: MyTheme.light_grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset("assets/flash_deal.png"),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                          AppLocalizations
                              .of(context)
                              .home_screen_flash_deal,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(132, 132, 132, 1),
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInCubic,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  if (i["go_to_flash_deal"] == true) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlashDealList();
                        }));
                  }else if (i["category"] != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            category_id: i["category"]["id"],
                            category_name: i["category"]["name"],
                          );
                        }));
                  }else if(i["flash_deal"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return FlashDealProducts(
                            flash_deal_id: i["flash_deal"]["id"],
                            flash_deal_name: i["flash_deal"]["title"],
                          );
                        }));
                  }else if(i["brand"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BrandProducts(
                            id: i["brand"]["id"],
                            brand_name: i["brand"]["name"],
                          );
                        }));
                  }else{
                    print("null");
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_rectangle.png',
                          image: i["photo"],
                          fit: BoxFit.fill,
                        ))),
              );
            },
          );
        }).toList(),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeBanner(context) {
    if (_isbannerlInitial && _bannerImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_bannerImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1.8,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInCubic,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _bannerImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  if (i["go_to_flash_deal"] == true) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlashDealList();
                        }));
                  }else if (i["category"] != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            category_id: i["category"]["id"],
                            category_name: i["category"]["name"],
                          );
                        }));
                  }else if(i["flash_deal"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return FlashDealProducts(
                            flash_deal_id: i["flash_deal"]["id"],
                            flash_deal_name: i["flash_deal"]["title"],
                          );
                        }));
                  }else if(i["brand"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BrandProducts(
                            id: i["brand"]["id"],
                            brand_name: i["brand"]["name"],
                          );
                        }));
                  }else{
                    print("null");
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_rectangle.png',
                          image: i["photo"],
                          fit: BoxFit.fill,
                        ))),
              );
            },
          );
        }).toList(),
      );
    } else if (!_isbannerlInitial && _bannerImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeBanner3(context) {
    if (_isbanner3lInitial && _banner3ImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_banner3ImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1.8,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInCubic,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _banner3ImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  if (i["go_to_flash_deal"] == true) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlashDealList();
                        }));
                  }else if (i["category"] != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            category_id: i["category"]["id"],
                            category_name: i["category"]["name"],
                          );
                        }));
                  }else if(i["flash_deal"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return FlashDealProducts(
                            flash_deal_id: i["flash_deal"]["id"],
                            flash_deal_name: i["flash_deal"]["title"],
                          );
                        }));
                  }else if(i["brand"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BrandProducts(
                            id: i["brand"]["id"],
                            brand_name: i["brand"]["name"],
                          );
                        }));
                  }else{
                    print("null");
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_rectangle.png',
                          image: i["photo"],
                          fit: BoxFit.fill,
                        ))),
              );
            },
          );
        }).toList(),
      );
    } else if (!_isbanner3lInitial && _banner3ImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeBanner2(context) {
    if (_isbanner2lInitial && _banner2ImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_banner2ImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1.8,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInCubic,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _banner2ImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  if (i["go_to_flash_deal"] == true) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FlashDealList();
                        }));
                  }else if (i["category"] != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            category_id: i["category"]["id"],
                            category_name: i["category"]["name"],
                          );
                        }));
                  }else if(i["flash_deal"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return FlashDealProducts(
                            flash_deal_id: i["flash_deal"]["id"],
                            flash_deal_name: i["flash_deal"]["title"],
                          );
                        }));
                  }else if(i["brand"] != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BrandProducts(
                            id: i["brand"]["id"],
                            brand_name: i["brand"]["name"],
                          );
                        }));
                  }else{
                    print("null");
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_rectangle.png',
                          image: i["photo"],
                          fit: BoxFit.fill,
                        ))),
              );
            },
          );
        }).toList(),
      );
    } else if (!_isbanner2lInitial && _banner2ImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
          builder: (context) =>
              IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () {
                    if (!widget.go_back) {
                      return;
                    }
                    return Navigator.of(context).pop();
                  }),
        )
            : Builder(
          builder: (context) =>
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 0.0),
                child: Container(
                  child: Image.asset(
                    'assets/hamburger.png',
                    height: 16,
                    //color: MyTheme.dark_grey,
                    color: MyTheme.dark_grey,
                  ),
                ),
              ),
        ),
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery
                .of(context)
                .viewPadding
                .top > 40 ? 16.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
          child: Padding(
              padding: app_language_rtl.$
                  ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
                  : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
              // when notification bell will be shown , the right padding will cease to exist.
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Filter();
                        }));
                  },
                  child: buildHomeSearchBox(context))),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        InkWell(
          onTap: () {
            ToastComponent.showDialog(
                AppLocalizations
                    .of(context)
                    .common_coming_soon, context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Visibility(
            visible: false,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
              child: Image.asset(
                'assets/bell.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return TextField(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Filter();
        }));
      },
      autofocus: false,
      decoration: InputDecoration(
          hintText: AppLocalizations
              .of(context)
              .home_screen_search,
          hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: MyTheme.textfield_grey,
              size: 20,
            ),
          ),
          contentPadding: EdgeInsets.all(0.0)),
    );
  }

  Widget buildcategaryhome() {
    if (_categreyhomeList.length == 0 && _isCategreyHomeInitial) {
      return
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, top: 8, bottom: 8),
                      child: ShimmerHelper().buildBasicShimmer(
                          height: 320,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 32) / 3),

                    ),

                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        );
    } else {
      return ListView.builder(
        itemCount: _categreyhomeList["data"].length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if( _categreyhomeList["data"][index]["products"].length != 0)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    16.0,
                    16.0,
                    0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _categreyhomeList["data"][index]["name"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  MyTheme.accent_color)),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return CategoryProducts(
                                    category_id: _categreyhomeList["data"][index]
                                    ["id"],
                                    category_name: _categreyhomeList["data"][index]
                                    ["name"],
                                  );
                                }));
                          },
                          child: Text(
                            !app_language_rtl.$ ? "View more" : "عرض المزيد",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              if( _categreyhomeList["data"][index]["products"].length != 0)
                Padding(
                  padding: !app_language_rtl.$
                      ? EdgeInsets.fromLTRB(16, 0, 5, 0)
                      : EdgeInsets.fromLTRB(5, 0, 16, 0),
                  child: Container(
                    height:
                    _categreyhomeList["data"][index]["products"].length == 0
                        ? 0
                        : 320,
                    child: ListView.builder(
                      itemCount:
                      _categreyhomeList["data"][index]["products"].length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index2) =>
                          SizedBox(
                            width: 150,
                            child: _categreyhomeList["data"][index]["products"]
                                .length == 0 ? Container() : ProductCard(
                                id: _categreyhomeList["data"][index]["products"]
                                [index2]["id"],
                                image: _categreyhomeList["data"][index]["products"]
                                [index2]["thumbnail_image"],
                                name: _categreyhomeList["data"][index]["products"]
                                [index2]["name"],
                                main_price: _categreyhomeList["data"][index]
                                ["products"][index2]["main_price"],
                                stroked_price: _categreyhomeList["data"][index]
                                ["products"][index2]["stroked_price"],
                                has_discount: _categreyhomeList["data"][index]
                                ["products"][index2]["has_discount"]),
                          ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }
  }
}
