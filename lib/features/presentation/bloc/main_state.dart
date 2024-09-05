import 'package:equatable/equatable.dart';
import 'package:quran/features/domain/entity/Reciter.dart';
import 'package:quran/features/domain/entity/SearchResult.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class MainEmpty extends MainState {
  @override
  List<Object> get props => [];
}


class MainError extends MainState {
  final String message;

  const MainError({required this.message});

  List<Object> get props => [message];
}


class MainLoading extends MainState {
  List<Object> get props => [];
}

class MainReciterDetected extends MainState {
  final Reciter reciter;

  const MainReciterDetected({required this.reciter});

  List<Object> get props => [reciter];
}

class MainSearchResultLoaded extends MainState {
  final SearchResult result;

  const MainSearchResultLoaded({required this.result});

  List<Object> get props => [result];
}
