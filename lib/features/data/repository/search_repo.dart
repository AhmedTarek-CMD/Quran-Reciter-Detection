import 'dart:io';

import 'package:quran/core/error/failures.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:dartz/dartz.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchQuran(String content);
  Future<Either<Failure, Reciter>> detectReciter(File file);
}