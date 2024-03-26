
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fashion/common/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../../consts/consts.dart';
import '../controller/chat_admin_controller.dart';
import '../../../services/firestore_service.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../components/sender_bubble.dart';

class ChatAdminScreen extends StatelessWidget {
  const ChatAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsAdminController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkFontGrey),
          onPressed: () {
            Get.back();
          }, 
        ),
        title: boldText(text: "${controller.friendName}", size: 16.0, color: fontGrey),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: loadingIndicator(),
                      )
                    : Expanded(
                        child: StreamBuilder(
                        stream: FirestoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Send a message..."
                                  .text
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs.mapIndexed((currentValue, index) {

                                var data = snapshot.data!.docs[index];

                                return Align(
                                  alignment: data['uid'] == currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
                                  child: senderBubble(data));
                              }).toList(),
                            );
                          }
                        },
                      )),
              ),
              10.heightBox,
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: textfieldGrey,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: textfieldGrey,
                      )),
                      hintText: "Type a message...",
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        controller.sendMsg(controller.msgController.text);
                        controller.msgController.clear();
                      },
                      icon: const Icon(Icons.send, color: redColor))
                ],
              )
                  .box
                  .height(80)
                  .padding(const EdgeInsets.all(12))
                  .margin(const EdgeInsets.only(bottom: 8))
                  .make(),
            ],
          )),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: 20,
      //           itemBuilder: ((context, index) {
      //             return ChatBubble();
      //           })
      //         ),
      //       ),
      //       10.heightBox,
      //       SizedBox(
      //         height: 56,
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: TextFormField(
      //                 decoration: const InputDecoration(
      //                   isDense: true,
      //                   hintText: "Enter message",
      //                   border: OutlineInputBorder(
      //                     borderSide: BorderSide(
      //                       color: darkFontGrey
      //                     )
      //                   ),
      //                   focusedBorder: OutlineInputBorder(
      //                     borderSide: BorderSide(
      //                       color: darkFontGrey
      //                     )
      //                   )
      //                 ),
      //               )
      //             ),
      //             IconButton(
      //               onPressed: () {},
      //               icon: const Icon(Icons.send, color: darkFontGrey),
      //             )
      //           ],
      //         ).box.padding(const EdgeInsets.all(12)).make(),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}