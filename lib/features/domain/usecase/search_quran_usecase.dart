import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/core/error/failures.dart';
import 'package:quran/core/usecase/base_usecase.dart';
import 'package:quran/features/data/repository/search_repo.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

class SearchQuranUseCase extends BaseUseCase<SearchResult, SearchQuranParams> {

  final SearchRepository repository;

  SearchQuranUseCase({required this.repository});

  @override
  Future<Either<Failure, SearchResult>> call(SearchQuranParams params) async {
    return await repository.searchQuran(params.content);
  }

}



class SearchQuranParams extends Equatable {
  final String content;

  const SearchQuranParams({required this.content}) : super();

  @override
  List<Object?> get props => [content];
}
