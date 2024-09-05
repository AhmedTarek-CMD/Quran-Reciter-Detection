import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quran/core/error/exceptions.dart';
import 'package:quran/core/error/failures.dart';
import 'package:quran/core/platform/network_info.dart';
import 'package:quran/features/data/datasource/remote_data_source/search_remote_data_source.dart';
import 'package:quran/features/data/repository/search_repo.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

class SearchRepoImpl extends SearchRepository {
  final NetworkInfo networkInfo;
  final SearchRemoteDataSource remoteDataSource;

  SearchRepoImpl({required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, Reciter>> detectReciter(File file) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.detectModel(file);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SearchResult>> searchQuran(String content) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.searchQuran(content);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
