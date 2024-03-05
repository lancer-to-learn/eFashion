import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/common/controllers/auth_controller.dart';
import 'package:e_fashion/user/controllers/profile_controller.dart';
import 'package:e_fashion/common/views/login_screen.dart';
import 'package:e_fashion/common/widgets/bg_widget.dart';
import 'package:e_fashion/common/widgets/loading_indicator.dart';
import 'package:e_fashion/consts/consts.dart';
import 'package:e_fashion/consts/lists.dart';
import 'package:e_fashion/services/firestore_service.dart';
import 'package:e_fashion/user/views/profile_screen/components/detail_card.dart';
import 'package:e_fashion/user/views/profile_screen/edit_profile.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
        child: Scaffold(
            body: StreamBuilder(
                stream: FirestoreServices.getUser(currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor)));
                  } else {
                    var data = snapshot.data!.docs[0];

                    print("############");
                    print(currentUser!.email);
                    print("############");

                    print("Image url: " + data['imageUrl']);
                    return SafeArea(
                        child: Column(
                      children: [
                        // edit profile button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.edit, color: whiteColor))
                              .onTap(() {
                            controller.nameController.text = data['name'];

                            Get.to(() => EditProfileScreen(
                                  data: data,
                                ));
                          }),
                        ),

                        // users detais section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              data['imageUrl'] == ''
                                  ? Image.asset(imgProfile,
                                          width: 100, fit: BoxFit.fill)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.network(data['imageUrl'],
                                          width: 100, fit: BoxFit.fill)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                              10.widthBox,
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${data['name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .white
                                      .make(),
                                  "${data['email']}".text.white.make(),
                                ],
                              )),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: whiteColor,
                                  )),
                                  onPressed: () async {
                                    VxToast.show(context, msg: loggedOut);
                                    await Get.put(AuthController())
                                        .signoutMethod(context);
                                    Get.offAll(() => const LoginScreen());
                                  },
                                  child: logout.text
                                      .fontFamily(semibold)
                                      .white
                                      .make())
                            ],
                          ),
                        ),

                        20.heightBox,

                        FutureBuilder(
                            future: FirestoreServices.getCounts(),
                            builder: (BuildContext context,
                                AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: loadingIndicator());
                              } else {
                                var countData = snapshot.data;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    detailsCard(
                                        count: countData[0].toString(),
                                        title: "Your Cart",
                                        width: context.screenWidth / 3.3),
                                    detailsCard(
                                        count: countData[1].toString(),
                                        title: "Your Wishlist",
                                        width: context.screenWidth / 3.3),
                                    detailsCard(
                                        count: countData[2].toString(),
                                        title: "Your Orders",
                                        width: context.screenWidth / 3.3),
                                  ],
                                );
                              }
                            }),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     detailsCard(
                        //         count: "${data['cart_count']}",
                        //         title: "Your Cart",
                        //         width: context.screenWidth / 3.4),
                        //     detailsCard(
                        //         count: "${data['wishlist_count']}",
                        //         title: "Your Wishlist",
                        //         width: context.screenWidth / 3.4),
                        //     detailsCard(
                        //         count: "${data['order_count']}",
                        //         title: "Your Orders",
                        //         width: context.screenWidth / 3.4),
                        //   ],
                        // ),

                        //buttons section

                        ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return const Divider(color: lightGrey);
                                },
                                itemCount: profileButtonsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      // switch (index) {
                                      //   case 0:
                                      //     Get.to(() => const OrdersScreen());
                                      //     break;
                                      //   case 1:
                                      //     Get.to(() => const WishlishScreen());
                                      //     break;
                                      //   case 2:
                                      //     Get.to(() => const MessagesScreen());
                                      //     break;
                                      // }
                                    },
                                    leading: Image.asset(
                                      proflieButtonIcon[index],
                                      width: 22,
                                    ),
                                    title: profileButtonsList[index]
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                  );
                                })
                            .box
                            .white
                            .rounded
                            .margin(const EdgeInsets.all(12))
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make()
                            .box
                            .color(redColor)
                            .make(),
                      ],
                    ));
                  }
                })));
  }
}
