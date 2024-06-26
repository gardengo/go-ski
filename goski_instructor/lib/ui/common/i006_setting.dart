import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:goski_instructor/const/color.dart';
import 'package:goski_instructor/const/font_size.dart';
import 'package:goski_instructor/const/util/screen_size_controller.dart';
import 'package:goski_instructor/ui/common/i001_login.dart';
import 'package:goski_instructor/ui/component/goski_sub_header.dart';
import 'package:goski_instructor/ui/component/goski_text.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
final screenSizeController = Get.find<ScreenSizeController>();
FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: GoskiSubHeader(title: tr('setting')),
        body: Container(
          decoration: const BoxDecoration(
            color: goskiBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SettingTitle(
                          title: tr('notification'),
                        ),
                        SettingContent(
                          content: tr('notificationSetting'),
                          onConfirm: () => 0,
                          // () => showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) => GoskiModal(
                          //     title: tr('notificationSetting'),
                          //     child: const NotificationSettingDialog(),
                          //   ),
                          // ),
                        ),
                        SettingTitle(
                          title: tr('userInfo'),
                        ),
                        SettingContent(
                          content: tr('logout'),
                          onConfirm: () => {
                            secureStorage.deleteAll(),
                            Get.offAll(() => const LoginScreen())
                          },
                        ),
                        SettingTitle(
                          title: tr('etc'),
                        ),
                        SettingContent(
                          content: tr('termsOfUse'),
                          onConfirm: () => 0,
                          // onConfirm: () => Get.to(() => const TermScreen()),
                        ),
                        buildDivider(),
                        SettingContent(
                          content: tr('guide'),
                          onConfirm: () => 0,
                          // onConfirm: () => Get.to(() => const GuideScreen()),
                        ),
                        buildDivider(),
                        SettingContent(
                          content: tr('ask'),
                          onConfirm: () => 0,
                          // onConfirm: () => Get.to(() => const AskScreen()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: goskiWhite,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => 0,
                      // () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return GoskiModal(
                      //         title: tr('deleteUser'),
                      //         child: ResignConfirmDialog(
                      //           onCancel: () {
                      //             Navigator.pop(context);
                      //           },
                      //           onConfirm: () async {
                      //             await userViewModel.requestResign();
                      //             if (context.mounted) Navigator.pop(context);
                      //             secureStorage.deleteAll();
                      //             Get.offAll(() => const LoginScreen());
                      //           },
                      //         ),
                      //       );
                      //     },
                      //   );
                      // },
                      child: Padding(
                        padding: EdgeInsets.all(
                            screenSizeController.getWidthByRatio(0.03)),
                        child: GoskiText(
                          text: tr('deleteUser'),
                          size: goskiFontMedium,
                          color: goskiDarkGray,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildDivider() {
    return const Divider(
      thickness: 1,
      height: 0,
    );
  }
}

class SettingContent extends StatelessWidget {
  final String content;
  final VoidCallback? onConfirm;

  const SettingContent({
    required this.content,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onConfirm,
      child: Container(
        decoration: const BoxDecoration(
          color: goskiWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.all(screenSizeController.getWidthByRatio(0.03)),
              child: GoskiText(
                text: tr(content),
                size: goskiFontLarge,
                color: goskiBlack,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingTitle extends StatelessWidget {
  final String title;

  const SettingTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(screenSizeController.getWidthByRatio(0.03)),
          child: GoskiText(
            text: tr(title),
            size: goskiFontMedium,
            color: goskiDarkGray,
          ),
        )
      ],
    );
  }
}
