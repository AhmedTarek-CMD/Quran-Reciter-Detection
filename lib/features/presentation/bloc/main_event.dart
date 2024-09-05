import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class DetectReciterEvent extends MainEvent {
  final File file;

  const DetectReciterEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

class SearchQuranEvent extends MainEvent {
  final String content;

  const SearchQuranEvent({required this.content});

  @override
  List<Object?> get props => [content];
}