import 'package:dartz/dartz.dart';
import 'package:quran/core/error/failures.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';
import 'package:quran/features/domain/usecase/detect_reciter.dart';
import 'package:quran/features/domain/usecase/search_quran_usecase.dart';
import 'package:quran/features/presentation/bloc/main_event.dart';
import 'package:quran/features/presentation/bloc/main_state.dart';
import 'package:bloc/bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final SearchQuranUseCase searchQuranUseCase;
  final DetectReciterUseCase detectReciterUseCase;

  MainBloc({required this.searchQuranUseCase, required this.detectReciterUseCase}) : super(MainEmpty()) {
    on<SearchQuranEvent>((event, emit) async {
      print("EMIT: SearchQuranEvent");
      emit(MainLoading());
      Either<Failure, SearchResult> response =
          await searchQuranUseCase(SearchQuranParams(content: event.content));
      response.fold((left) => emit(const MainError(message: 'fake error')), (right) {
        print("-------------- MainSearchResultLoaded Loaded -----------------");
        print(right);
        emit(MainSearchResultLoaded(result: right));
      });
    });
    on<DetectReciterEvent>((event, emit) async {
      print("EMIT: DetectReciterEvent");
      emit(MainLoading());
      Either<Failure, Reciter> response =
      await detectReciterUseCase(DetectReciterParams(file: event.file));
      response.fold((left) => emit(const MainError(message: 'fake error')), (right) {
        print("-------------- MainSearchResultLoaded Loaded -----------------");
        print(right);
        emit(MainReciterDetected(reciter: right));
      });
    });
  }
}
