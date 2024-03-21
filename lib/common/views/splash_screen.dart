import 'package:e_fashion/consts/consts.dart';
// import 'package:finalproj/controllers/admin/home_admin_contronller.dart';
// import 'package:finalproj/views/admin/home/home_admin.dart';
import 'login_screen.dart';
import 'package:e_fashion/user/views/home_screen/home_screen.dart';
import 'package:e_fashion/common/widgets/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() {
      return _SplashScreenState();
   }
}

class _SplashScreenState extends State<SplashScreen>{
  
  //method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      // Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user) async {
        if(user == null && mounted){
          Get.to(() => const LoginScreen());
        }else{
          Get.to(() => const LoginScreen()); // *delete later

          
          // var controller = Get.put(HomeAdminController());
          // print('abc');
          // await controller.getUsername();
          // print(controller.username);
          // if (controller.username != '') {
          //   Get.to(() => const Home_Admin());
          // } else {
          //   Get.to(() => const Home());
          // }
          
        }
       });
    });
  }

  @override
  void initState() {
    super.initState();
    // auth.authStateChanges().listen((User? user) async {
    //     if(user == null && mounted){
    //       Get.to(() => const LoginScreen());
    //     } else {         
    //       var controller = Get.put(HomeAdminController());
    //       changeScreen(controller);
    //     }
    // });
    changeScreen();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
              Align(alignment: Alignment.topLeft, child: Image.asset(icSplashBg, width: 300)),
              20.heightBox,
              applogoWidget(),
              10.heightBox,
              appname.text.fontFamily(bold).size(22).white.make(),
              5.heightBox,
              appversion.text.white.make(),
              const Spacer(),
              credits.text.white.fontFamily(semibold).make(),
              30.heightBox,
              //splash screen UI done
          ]),
      )
    );
  }

}