import 'package:dio/dio.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/help/models/help_video_model.dart';

/// A repository class for handling help-related API requests.
class HelpApiRepo {
  /// Fetches the help videos from the API.
  ///
  /// Returns a [HelpVideoModel] on success, or a [HelpVideoModel] with
  /// `success` set to `false` if there is a DioException with a message.
  /// Returns `null` for other errors.
  Future<HelpVideoModel?> getHelpVideos({
    List<String> states = const <String>[],
  }) async {
    try {
      final String query = states
          .map((e) => 'state=${Uri.encodeQueryComponent(e)}')
          .join('&');

      final String path = query.isEmpty
          ? ApiConstants.helpVideosList
          : '${ApiConstants.helpVideosList}?$query';
      final Response<dynamic>? response = await APIService.get(path: path);

      if (response?.statusCode == 200 && response?.data != null) {
        return HelpVideoModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      return e.response?.data['message'] != null
          ? HelpVideoModel(success: false)
          : null;
    }
    return null;
  }
}
