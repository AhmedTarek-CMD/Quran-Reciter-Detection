import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quran/core/platform/network_info.dart';
import 'package:quran/features/data/datasource/remote_data_source/search_remote_data_source.dart';
import 'package:quran/features/data/repository/search_repo.dart';
import 'package:quran/features/domain/repository/search_repo_impl.dart';
import 'package:quran/features/domain/usecase/detect_reciter.dart';
import 'package:quran/features/domain/usecase/search_quran_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {

  /// Data Layer
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SearchRemoteDataSource>(
          () => SearchRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<SearchRepository>(
          () => SearchRepoImpl(remoteDataSource: sl(), networkInfo: sl()));

  /// Domain Layer

  sl.registerLazySingleton<SearchQuranUseCase>(
          () => SearchQuranUseCase(repository: sl()));

  sl.registerLazySingleton<DetectReciterUseCase>(
          () => DetectReciterUseCase(repository: sl()));

  //! Core

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
