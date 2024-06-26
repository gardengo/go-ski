import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goski_student/const/color.dart';
import 'package:goski_student/data/model/instructor.dart';
import 'package:goski_student/data/model/kakao_pay.dart';
import 'package:goski_student/data/model/reservation.dart';
import 'package:goski_student/data/model/student_info.dart';
import 'package:goski_student/data/repository/lesson_payment_repository.dart';
import 'package:goski_student/main.dart';
import 'package:goski_student/ui/reservation/u025_reservation_complete.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const MethodChannel methodChannel = MethodChannel('lesson_payment_channel');

class LessonPaymentViewModel {
  final lessonPaymentRepository = Get.find<LessonPaymentRepository>();
  var pgToken = '';

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(goskiBackground)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('http://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  Future<void> teamLessonPayment(
      ReservationRequest reservationRequest,
      BeginnerResponse beginnerResponse,
      List<StudentInfo> studentInfo,
      String requestComplain,
      BuildContext context) async {
    try {
      KakaoPayPrepareResponse kakaoPayPrepareResponse =
          await lessonPaymentRepository.teamLessonPayment(reservationRequest,
              beginnerResponse, studentInfo, requestComplain);
      if (kakaoPayPrepareResponse.next_redirect_pc_url.isNotEmpty && context.mounted) {
        _showWebView(kakaoPayPrepareResponse, context,
            beginnerResponse: beginnerResponse);
      } else {
        if (Get.isSnackbarOpen) {
          Get.snackbar('Payment Error', 'Failed to initiate payment');
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
            'Payment Error', 'An error occurred during payment initiation: $e');
      }
    }
  }

  Future<void> instLessonPayment(
      ReservationRequest reservationRequest,
      BeginnerResponse beginnerResponse,
      Instructor instructor,
      List<StudentInfo> studentInfo,
      String requestComplain,
      BuildContext context) async {
    try {
      KakaoPayPrepareResponse kakaoPayPrepareResponse =
          await lessonPaymentRepository.instLessonPayment(reservationRequest,
              beginnerResponse, instructor, studentInfo, requestComplain);
      if (kakaoPayPrepareResponse.next_redirect_pc_url.isNotEmpty && context.mounted) {
        _showWebView(kakaoPayPrepareResponse, context,
            beginnerResponse: beginnerResponse, instructor: instructor);
      } else {
        if (!Get.isSnackbarOpen) {
          Get.snackbar('Payment Error', 'Failed to initiate payment');
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
            'Payment Error', 'An error occurred during payment initiation: $e');
      }
    }
  }

  Future<void> advancedLessonPayment(
      ReservationRequest reservationRequest,
      Instructor instructor,
      List<StudentInfo> studentInfo,
      String requestComplain,
      BuildContext context) async {
    try {
      KakaoPayPrepareResponse kakaoPayPrepareResponse =
          await lessonPaymentRepository.advancedLessonPayment(
              reservationRequest, instructor, studentInfo, requestComplain);
      if (kakaoPayPrepareResponse.next_redirect_pc_url.isNotEmpty && context.mounted) {
        _showWebView(kakaoPayPrepareResponse, context, instructor: instructor);
      } else {
        if (!Get.isSnackbarOpen) {
          Get.snackbar('Payment Error', 'Failed to initiate payment');
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
            'Payment Error', 'An error occurred during payment initiation: $e');
      }
    }
  }

  void _showWebView(KakaoPayPrepareResponse response, BuildContext context,
      {BeginnerResponse? beginnerResponse, Instructor? instructor}) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(response.next_redirect_app_url))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          logger.d(request.url);

          getAppUrl(String url) async {
            var parsingUrl = await methodChannel
                .invokeMethod('getAppUrl', <String, Object>{'url': url});
            return parsingUrl;
          }

          getMarketUrl(String url) async {
            var parsingURl = await methodChannel
                .invokeMethod('getMarketUrl', <String, Object>{'url': url});
            return parsingURl;
          }

          if (request.url.startsWith('https://developers.kakao.com/success')) {
            Uri uri = Uri.parse(request.url);
            String? pgToken = uri.queryParameters['pg_token'];
            logger.d(pgToken);
            if (pgToken != null) {
              Get.back(); // Close the WebView dialog
              if (await _approvePayment(response.tid, pgToken)) {
                if (instructor == null) {
                  Get.to(() => ReservationCompleteScreen(
                      teamInformation: beginnerResponse));
                } else if (beginnerResponse == null) {
                  Get.to(
                          () => ReservationCompleteScreen(instructor: instructor));
                } else {
                  Get.to(() => ReservationCompleteScreen(
                    teamInformation: beginnerResponse,
                    instructor: instructor,
                  ));
                }
              }
            }
            return NavigationDecision.prevent;
          }

          if (!request.url.startsWith('http') &&
              !request.url.startsWith('https')) {
            if (Platform.isAndroid) {
              var value = await getAppUrl(request.url.toString());
              String url = value.toString();
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                var value = await getMarketUrl(request.url.toString());
                String marketUrl = value.toString();
                await launchUrl(Uri.parse(marketUrl));
              }
              return NavigationDecision.prevent;
            } else if (Platform.isIOS) {
              if (await canLaunchUrl(Uri.parse(request.url))) {
                await launchUrl(
                  Uri.parse(request.url),
                );
                return NavigationDecision.prevent;
              }
            }
          }

          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          debugPrint('url change to ${change.url}');
        },
        onPageFinished: (String url) async {
          // debugPrint('page finished loading: $url');
          // if (url.startsWith('https://developers.kakao.com/success')) {
          //   Uri uri = Uri.parse(url);
          //   String? pgToken = uri.queryParameters['pg_token'];
          //   logger.d(pgToken);
          //   if (pgToken != null) {
          //     Get.back(); // Close the WebView dialog
          //     if (await _approvePayment(response.tid, pgToken)) {
          //       if (instructor == null) {
          //         Get.to(() => ReservationCompleteScreen(
          //             teamInformation: beginnerResponse));
          //       } else if (beginnerResponse == null) {
          //         Get.to(
          //             () => ReservationCompleteScreen(instructor: instructor));
          //       } else {
          //         Get.to(() => ReservationCompleteScreen(
          //               teamInformation: beginnerResponse,
          //               instructor: instructor,
          //             ));
          //       }
          //     }
          //   }
          // }
        },
      ));
    Get.dialog(
      WebViewWidget(
        controller: controller,
      ),
    );
  }

  Future<bool> _approvePayment(String tid, String pgToken) async {
    try {
      bool result = await lessonPaymentRepository.approvePayment(tid, pgToken);
      if (result) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar(tr('successPayment'), tr('successPaymentContent'));
        }
        return true;
      } else {
        if (!Get.isSnackbarOpen) {
          Get.snackbar(tr('failPayment'), tr('failPaymentTryLater'));
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(tr('failPayment'), '${tr('failPaymentTryLater')}\n$e');
      }
    }
    return false;
  }
}
