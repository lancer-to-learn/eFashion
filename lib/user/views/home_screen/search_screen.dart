import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/views/category_screen/item_details.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: title!.text.color(darkFontGrey).make(),
        ),
        body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: loadingIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return "No items found".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filterd = data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(title!.toLowerCase()),
                  )
                  .toList();

              print("Search result: " + data[0]['p_name'].toString());

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  children: filterd
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(filterd[index]['p_imgs'][0],
                                  width: 200, height: 200, fit: BoxFit.cover),
                              const Spacer(),
                              "${filterd[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filterd[index]['p_price']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(16)
                                  .make(),
                              10.heightBox,
                            ],
                          )
                              .box
                              .white
                              .outerShadowMd
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(() => ItemDetails(
                                  title: "${filterd[index]['p_name']}",
                                  data: filterd[index],
                                ));
                          }))
                      .toList(),
                ),
              );
            }
          },
        ));
  }
}
