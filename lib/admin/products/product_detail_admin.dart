// import 'package:e_fashion/views/profile_screen/edit_profile.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';


import '../../../consts/consts.dart';


class ProductDetailAdmin extends StatelessWidget {
  final dynamic data;
  const ProductDetailAdmin({super.key, this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: darkFontGrey),
            onPressed: () {
              Get.back();
            },
          ),
          title: boldText(text: "Product details", size: 16.0, color: fontGrey),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        aspectRatio: 16 / 9,
                        itemCount: data['p_imgs'].length,
                        viewportFraction: 1.0,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data["p_imgs"][index],
                            width: double.infinity,
                            fit: BoxFit.fitHeight,
                          );
                        }),
          // VxSwiper.builder(
          //     autoPlay: true,
          //     height: 350,
          //     aspectRatio: 16 / 9,
          //     itemCount: data['p_imgs'].length,
          //     viewportFraction: 1.0,
          //     itemBuilder: (context, index) {
          //       return Image.network(
          //         data['p_imgs'][index],
          //         width: double.infinity,
          //         fit: BoxFit.cover,
          //       );
          //     }),
          10.heightBox,
          // title and detais section
          // title!.text
          //     .size(16)
          //     .color(darkFontGrey)
          //     .fontFamily(semibold)
          //     .make(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
                10.heightBox,
                Row(
                  children: [
                    boldText(text: "${data['p_category']}", color: fontGrey, size: 16.0),
                    10.widthBox,
                    normalText(text: "${data['p_subcategory']}", color: fontGrey, size: 16.0),
                  ],
                ),
                10.heightBox,
                //rating
                VxRating(
                  isSelectable: false,
                  value: double.parse(data['p_rating']),
                  // value: double.parse(data['p_rating']),
                  onRatingUpdate: (value) {},
                  normalColor: textfieldGrey,
                  selectionColor: golden,
                  count: 5,
                  size: 25,
                  maxRating: 5,
                ),
                10.heightBox,
                boldText(text: "${data['p_price']}", color: redColor, size: 18.0),
                // "${data['p_price']}"
                //     .numCurrency
                //     .text
                //     .color(redColor)
                //     .fontFamily(bold)
                //     .size(18)
                //     .make(),


                20.heightBox,
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: normalText(text: "Color", color: fontGrey),
                          // child: "Color: ".text.color(textfieldGrey).make(),
                        ),
                        Row(
                          children: List.generate(
                              data['p_colors'].length,
                              (index) =>
                                      VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]))
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .make()
                                          .onTap(() {
                                      }),
                                     
                                    ),
                        )
                      ],
                    ).box.white.make(),
                    10.heightBox,
                    // quantity row
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: normalText(text: "Quantity", color: fontGrey)
                          // child: "Quantity: ".text.color(textfieldGrey).make(),
                        ),
                        normalText(text: "${data['p_quantity']} items", color: fontGrey),
                       
                      ],
                    ),
                  ],
                ).box.white.make(),
                const Divider(),
                20.heightBox,
                boldText(text: "Description", color: fontGrey),
                10.heightBox,
                normalText(text: "${data['p_desc']}", color: fontGrey)
              ],
            ),
          ),
        ])));
  }
}
