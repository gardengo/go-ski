import 'package:get/get.dart';
import 'package:goski_student/const/util/custom_dio.dart';
import 'package:goski_student/data/data_source/main_service.dart';
import 'package:goski_student/data/model/instructor.dart';
import 'package:goski_student/data/model/reservation.dart';
import 'package:goski_student/main.dart';

class ReservationService extends GetxService {
  Future<List<BeginnerResponse>> getBeginnerLessonTeamInfo(
      ReservationRequest reservationRequest) async {
    logger.e(reservationRequest.reservationRequestToJson());
    try {
      dynamic response = await CustomDio.dio.post(
        '$baseUrl/lesson/reserve/novice',
        data: reservationRequest.reservationRequestToJson(),
      );
      logger.d("ReservationService : \n$response.data");

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        // List<BeginnerResponse> data = (response.data['data'] as List)
        //     .map<BeginnerResponse>((json) =>
        //         BeginnerResponse.fromJson(json as Map<String, dynamic>))
        //     .toList();
        List<dynamic> dataList = response.data['data'];
        List<BeginnerResponse> teams = dataList
            .map<BeginnerResponse>((json) =>
                BeginnerResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        logger
            .d('ReservationService - getBeginnerLessonTeamInfo - 응답 성공 $teams');

        return teams;
      } else {
        logger.e(
            'ReservationService - getBeginnerLessonTeamInfo - 응답 실패 ${response.data}');
      }
    } catch (e) {
      logger.e('ReservationService - getBeginnerLessonTeamInfo - 응답 실패 $e');
    }
    return [];
  }

  Future<List<Instructor>> getBeginnerInstructorList(
      Map<String, dynamic> beginnerInstListRequest, int teamId) async {
    logger.e(beginnerInstListRequest);
    try {
      dynamic response = await CustomDio.dio.post(
        '$baseUrl/lesson/reserve/novice/$teamId',
        data: beginnerInstListRequest,
      );
      logger.d("ReservationService : \n${response.data['data']}");

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        // List<BeginnerResponse> data = (response.data['data'] as List)
        //     .map<BeginnerResponse>((json) =>
        //         BeginnerResponse.fromJson(json as Map<String, dynamic>))
        //     .toList();
        List<dynamic> dataList = response.data['data'];
        List<Instructor> instList = dataList
            .map<Instructor>(
                (json) => Instructor.fromJson(json as Map<String, dynamic>))
            .toList();
        logger.d(
            'ReservationService - getBeginnerInstructorList - 응답 성공 $instList');

        return instList;
      } else {
        logger.e(
            'ReservationService - getBeginnerInstructorList - 응답 실패 ${response.data}');
      }
    } catch (e) {
      logger.e(
          'ReservationService - getBeginnerInstructorList - 응답 실패 CATCH\n $e');
    }
    return [];
  }

  Future<List<Instructor>> getAdvancedInstructorList(
      ReservationRequest reservationRequest) async {
    logger.e(reservationRequest.reservationRequestToJson());
    try {
      dynamic response = await CustomDio.dio.post(
        '$baseUrl/lesson/reserve/advanced',
        data: reservationRequest.reservationRequestToJson(),
      );
      logger.d("ReservationService : \n$response.data");

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        // List<BeginnerResponse> data = (response.data['data'] as List)
        //     .map<BeginnerResponse>((json) =>
        //         BeginnerResponse.fromJson(json as Map<String, dynamic>))
        //     .toList();
        List<dynamic> dataList = response.data['data'];
        List<Instructor> instructors = dataList
            .map<Instructor>(
                (json) => Instructor.fromJson(json as Map<String, dynamic>))
            .toList();
        logger.d(
            'ReservationService - getAdvancedInstructorList - 응답 성공 $instructors');

        return instructors;
      } else {
        logger.e(
            'ReservationService - getAdvancedInstructorList - 응답 실패 ${response.data}');
      }
    } catch (e) {
      logger.e('ReservationService - getAdvancedInstructorList - 응답 실패 $e');
    }
    return [];
  }
}
