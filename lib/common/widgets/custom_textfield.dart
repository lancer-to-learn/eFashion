import 'package:e_fashion/consts/consts.dart';
import 'text_style.dart';

Widget customTextField({String? title, String? hint, controller, isPass = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: redColor
            )
          )
        ),
      ),
      5.heightBox,
    ],
  );
}


Widget customTextFieldAdmin({String? title, String? hint, controller, isPass = false, isDesc = false, enabled = true}) {
  return 
      TextFormField(
        maxLines: isDesc ? 4 : 1,
        obscureText: isPass,
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          label: normalText(text: title, color: darkFontGrey),
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: whiteColor,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: whiteColor,
            ),
          ),
        )
      );
}