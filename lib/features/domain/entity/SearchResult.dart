import 'package:equatable/equatable.dart';
import 'package:quran/features/domain/entity/SearchData.dart';

class SearchResult extends Equatable {
  final List<SearchData> resultText;

  const SearchResult({required this.resultText});

  @override
  List<Object?> get props => [resultText];
}
