import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/common/widgets/our_button.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/user/controllers/home_controller.dart';
import 'package:e_fashion/user/controllers/product_controller.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/views/category_screen/item_details.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../models/category_model.dart';
import '../../models/filter_model.dart';

class ProductScreen extends StatefulWidget {
  final String? title;
  const ProductScreen({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var controller = Get.find<ProductController>();
  ScrollController _scrollController = ScrollController();
  var searchController = TextEditingController();
  var isFilter = false;
  var filters = [];
  var kw = null;
  var filter = null;
  // var displayProducts = [];
  var currentPage = 1;
  bool isLoading = false;
  dynamic productMethod;
  bool isSearch = false;
  var isChooseFilter = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProducts();
    getFilters();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Top of the scroll view
        print('Scrolled to the top');
        if (currentPage > 1) {
          currentPage = currentPage - 1;
        }
      } else {
        // Bottom of the scroll view
        print('Scrolled to the bottom');
        currentPage = currentPage + 1;
      }
      setState(() {currentPage = currentPage; isLoading = true;});
    }
  }

  getAllProducts() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching data starts
    });
    try {
      // Simulate fetching data with a delay
      await Future.delayed(const Duration(seconds: 2)); // Replace with actual data fetching logic
      setState(() {
        // Update products variable with fetched data
        productMethod = FirestoreServices.allProducts();
        isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (error) {
      setState(() {
        // Handle error state here
        isLoading = false; // Set loading state to false in case of error
      });
    }
    print("loading: ${isLoading}");
  }
  getProducts(data) {
    var products = data;
    if (products.isNotEmpty) {
      if (isSearch && kw != null) {
      products = products.where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(kw!.toLowerCase()),
                  )
                  .toList();
      }
      if (isFilter && filter != null) {
          products = products.where((element) => element['p_price'] > filter.min && element['p_price'] < filter.max).toList();
      }
      var len = products.length;
      if (len > (currentPage-1)*pageSize) {
        products = len > currentPage * pageSize ? 
        products.sublist(currentPage*pageSize-pageSize, currentPage*pageSize) :
        products.sublist(currentPage*pageSize-pageSize, len-1);
      } else {
        if (currentPage > 1) {
            currentPage = currentPage - 1;
            products = products.sublist(currentPage*pageSize-pageSize, len-1);
        }
      }
    }
    print("current page: ${currentPage}");
    print("is loading: ${isLoading}");
    Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    return products;
  }
  getPagingProduct(filter, lastProduct) {
    // productMethod = FirestoreServices.pagingProduct(filter, lastProduct);
  }
  search(keyword) {
    isSearch = true;
    kw = keyword;
  }
  handleFilterClick() {
    isFilter = !isFilter;
  }
  
  getFilters() async {
    var data = await rootBundle.loadString("filter_model.json");
    var decoded = filterModelFromJson(data);
    print("filter: ${decoded}");
    filters = decoded.filters.toList();
    isChooseFilter = List.generate(filters.length, (index) => false);
    print(isChooseFilter);
  }
  filterProducts(newFilter, index) {
    // productMethod = FirestoreServices.filterProduct(filter);
    if (isChooseFilter[index]) {
      isChooseFilter[index] = false;
    } else {
      for (int i = 0; i < filters.length; i++) {
        isChooseFilter[i] = false;
      }
      isChooseFilter[index] = true;
    }
    filter = newFilter;
  }
  switchCategory(title) {
    isSearch = false;
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: "Products".text.fontFamily(bold).white.make(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (searchController.text.isNotEmpty) {
                                  search(searchController.text);
                                  setState(() {});
                                } else {
                                  isSearch = false;
                                  setState(() {});
                                }
                              },
                              child: Icon(Icons.search),
                            ),
                            filled: true,
                            fillColor: whiteColor,
                            hintText: searchAnything,
                            hintStyle: TextStyle(color: textfieldGrey),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          handleFilterClick();
                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(icFilter, width: 30, height: 30, fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                ),
                5.heightBox,
                Visibility(
                  visible: isFilter,
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: 
                  Row(
                    children: List.generate(
                      filters.length,
                      (index) => ourButton(
                        color: isChooseFilter[index] ? whiteColor : lightGolden,
                        textColor: darkFontGrey,
                        title: filters[index].name,
                        onPress: () {
                          filterProducts(filters[index], index);
                          setState(() {});
                        }
                      )
                      // (index) => "${filters[index].name}"
                      //             .text
                      //             .size(12)
                      //             .fontFamily(semibold)
                      //             .color(darkFontGrey)
                      //             .makeCentered()
                      //             .box
                      //             .white
                      //             .rounded
                      //             .size(80, 40)
                      //             .margin(
                      //                 const EdgeInsets.symmetric(horizontal: 4))
                      //             .make()
                      //             .onTap(() {
                      //           filterProducts(filters[index]);
                      //           setState(() {});
                      //         })
                      ),
                    )
                  ),),
                // Search box               
                20.heightBox,
                StreamBuilder(
                    stream: productMethod,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      List<Map<String, dynamic>> data = snapshot.data!.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
                      var products = getProducts(data);
                      if (!snapshot.hasData) {
                        return Expanded(
                            child: Center(child: loadingIndicator()));
                      } else if (products.length <= 0) {
                        return Expanded(
                            child: "No products found!"
                                .text
                                .color(darkFontGrey)
                                .makeCentered());
                      } else {
                        List<Map<String, dynamic>> data = snapshot.data!.docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                        return isLoading ? const Center(
                child: CircularProgressIndicator(),
              ): Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: products.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 300,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.checkIfFav(data[index]);
                                  Get.to(() => ItemDetails(
                                    title: "${products[index]['p_name']}",
                                    data: products[index],
                                  ));
                                },
                                child: _buildGridItem(products[index]),
                              );
                            },
                          ),
                        );
                      }
                    }),
              ],
            )));
  }

  Widget _buildGridItem(Map<String, dynamic> itemData) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  itemData['p_imgs'][0],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              itemData['p_name'],
              style: const TextStyle(
                fontFamily: semibold,
                color: darkFontGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${itemData['p_price']}",
              style: const TextStyle(
                fontFamily: bold,
                color: redColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
