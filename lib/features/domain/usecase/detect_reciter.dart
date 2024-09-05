import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/core/error/failures.dart';
import 'package:quran/core/usecase/base_usecase.dart';
import 'package:quran/features/data/repository/search_repo.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

class DetectReciterUseCase extends BaseUseCase<Reciter, DetectReciterParams> {

  final SearchRepository repository;

  DetectReciterUseCase({required this.repository});

  @override
  Future<Either<Failure, Reciter>> call(DetectReciterParams params) async {
    final reciter = await repository.detectReciter(params.file);
    print(reciter);
    return reciter;
  }

}



class DetectReciterParams extends Equatable {
  final File file;

  const DetectReciterParams({required this.file}) : super();

  @override
  List<Object?> get props => [file];
}
