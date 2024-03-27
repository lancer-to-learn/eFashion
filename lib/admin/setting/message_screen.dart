
import 'package:cloud_firestore/cloud_firestore.dart';
import './chat_admin_screen.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../../../services/firestore_service.dart';
import '../../../common/widgets/loading_indicator.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: boldText(text: "Messages", size: 16.0, color: fontGrey),
      ),
      body: StreamBuilder(
            stream: FirestoreServices.getAllAdminMessages(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return "No messages yet!"
                    .text
                    .color(darkFontGrey)
                    .makeCentered();
              } else {
                var data = snapshot.data!.docs;
                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Get.to(
                                      () => const ChatAdminScreen(),
                                      arguments: [
                                        data[index]['sender_name'],
                                        data[index]['fromId']
                                      ],
                                    );
                                  },
                                  leading: const CircleAvatar(
                                      backgroundColor: redColor,
                                      child: Icon(Icons.person,
                                          color: whiteColor)),
                                  title: "${data[index]['sender_name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  subtitle:
                                      "${data[index]['last_msg']}".text.make(),
                                ),
                              );
                            }))
                  ],
                );
              }
            }),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: SingleChildScrollView(
      //     physics: const BouncingScrollPhysics(),
      //     child: Column(
      //       children: List.generate(20, 
      //         (index) { 
      //           var t = data[index]['created_on'] == null ? DateTime.now() : data[index]['created_on'].toDate();
      //           var time = intl.DateFormat("h:mma").format(t);
      //           return ListTile(
      //           onTap: () {
      //             Get.to(() => const ChatAdminScreen());
      //           },
      //           leading: const CircleAvatar(
      //             backgroundColor: darkFontGrey,
      //             child: Icon(Icons.person, color: whiteColor),
      //           ),
      //           title: boldText(text: "${data[index]['sender_name']}", color: fontGrey),
      //           subtitle: normalText(text: "${data[index]['last_msg']}", color: darkFontGrey),
      //           trailing: normalText(text: "${time}", color: darkFontGrey),
      //         );
      //         },
      //       )
      //     ),
      //   ),
      //   ),
      );
  }
}