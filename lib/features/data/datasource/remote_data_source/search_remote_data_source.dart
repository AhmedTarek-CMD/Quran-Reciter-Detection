import 'dart:io';

import 'package:quran/core/constants/api_constants.dart';
import 'package:quran/core/error/exceptions.dart';
import 'package:quran/features/data/models/reciter_model.dart';
import 'package:quran/features/data/models/search_result_model.dart';
import 'package:dio/dio.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> searchQuran(String content);

  Future<ReciterModel> detectModel(File file);
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<SearchResultModel> searchQuran(String content) async {
    final response = await dio.post('${APIConstants.API_URL}${APIConstants.RESOURCE_SEARCH}',
        data: {'question': content});
    // dio.options.headers['Authorization'] =
    //     'Bearer aQgdqCHYmga7sxDPqT8YCrtNmAZYZp5T4Adv4xEj2C2nDyNEjacKET9vzcUjkRS9'; // Set the token for this specific request

    if (response.statusCode == 200) {
      print(response);
      return SearchResultModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ReciterModel> detectModel(File file) async {
    print(file);
    String fileName = file.path.split('/').last; // Extract the filename from the File object

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    print(formData);

    dio.options.headers['Authorization'] =
        'Bearer aQgdqCHYmga7sxDPqT8YCrtNmAZYZp5T4Adv4xEj2C2nDyNEjacKET9vzcUjkRS9'; // Set the token for this specific request

    final response =
        await dio.post('${APIConstants.API_URL}${APIConstants.RESOURCE_DETECT}', data: formData);
    if (response.statusCode == 200) {
      return ReciterModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
