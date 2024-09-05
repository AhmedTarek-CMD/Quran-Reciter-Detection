import 'package:equatable/equatable.dart';

class SearchData extends Equatable {
  final String? tafsir;
  final int? surahNo;
  final String? surahNameEn;
  final String? surahNameAr;
  final String? surahNameRoman;
  final int? ayahNoSurah;
  final int? ayahNoQuran;
  final String? ayahAr;
  final String? ayahEn;

  const SearchData(
      {required this.tafsir,
      required this.surahNo,
      required this.surahNameEn,
      required this.surahNameAr,
      required this.surahNameRoman,
      required this.ayahNoSurah,
      required this.ayahNoQuran,
      required this.ayahAr,
      required this.ayahEn});

  @override
  List<Object?> get props => [
        tafsir,
        surahNo,
        surahNameEn,
        surahNameAr,
        surahNameRoman,
        ayahNoSurah,
        ayahNoQuran,
        ayahAr,
        ayahEn
      ];
}
