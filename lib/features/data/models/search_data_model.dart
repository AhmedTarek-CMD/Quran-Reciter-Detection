import 'dart:convert';

import 'package:quran/features/domain/entity/SearchData.dart';

class SearchDataModel extends SearchData {
  const SearchDataModel(
      {required super.tafsir,
      required super.surahNo,
      required super.surahNameEn,
      required super.surahNameAr,
      required super.surahNameRoman,
      required super.ayahNoSurah,
      required super.ayahNoQuran,
      required super.ayahAr,
      required super.ayahEn});

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
        tafsir: json['tafsir'],
        surahNo: (json['surah_no'] as num).toInt(),
        surahNameEn: json['surah_name_en'],
        surahNameAr: json['surah_name_ar'],
        surahNameRoman: json['surah_name_roman'],
        ayahNoSurah: (json['ayah_no_surah'] as num).toInt(),
        ayahNoQuran: (json['ayah_no_quran'] as num).toInt(),
        ayahAr: json['ayah_ar'],
        ayahEn: json['ayah_en']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tafsir': super.tafsir,
      'surahNo': super.surahNo,
      'surahNameEn': super.surahNameEn,
      'surahNameAr': super.surahNameAr,
      'surahNameRoman': super.surahNameRoman,
      'ayahNoSurah': super.ayahNoSurah,
      'ayahNoQuran': super.ayahNoQuran,
      'ayahAr': super.ayahAr,
      'ayahEn': super.ayahEn,
    };
  }

  static List<SearchDataModel> jsonToList(dynamic json) {
    final List<dynamic> jsonArray = json;
    return jsonArray.map((json) => SearchDataModel.fromJson(json)).toList();
  }

  static String listToJson(List<SearchDataModel> results) {
    final List<Map<String, dynamic>> resultList = results.map((result) => result.toJson()).toList();
    return jsonEncode(resultList);
  }
}
