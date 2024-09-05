import 'dart:convert';

import 'package:quran/features/data/models/search_data_model.dart';
import 'package:quran/features/domain/entity/SearchData.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({required super.resultText});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(resultText: SearchDataModel.jsonToList(json['result_text']));
  }

  Map<String, dynamic> toJson() {
    return {
      'result_text': super.resultText,
    };
  }
}
