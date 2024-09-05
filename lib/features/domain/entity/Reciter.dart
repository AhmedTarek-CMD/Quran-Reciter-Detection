import 'package:equatable/equatable.dart';
import 'package:quran/features/domain/entity/Moshaf.dart';

class Reciter extends Equatable {

  final int id;
  final String name;
  final String letter;
  final String date;
  final Moshaf moshaf;

  const Reciter({required this.id, required this.name, required this.letter, required this.date, required this.moshaf});

  @override
  List<Object?> get props => [id, name, letter, date, moshaf];

}