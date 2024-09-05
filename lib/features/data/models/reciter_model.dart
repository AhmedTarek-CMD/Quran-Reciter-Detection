import 'dart:convert';

import 'package:quran/features/domain/entity/Moshaf.dart';
import 'package:quran/features/domain/entity/Reciter.dart';

class ReciterModel extends Reciter {
  const ReciterModel({ required super.id, required super.name, required super.letter, required super.date, required super.moshaf});

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ReciterModel(id: json['id'], name: json['name'], letter: json['letter'], date: json['date'], moshaf: Moshaf.fromJson(json['moshaf'][0]) );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'letter': super.letter,
      'date': super.date,
      'moshaf': super.moshaf,
    };
  }
}
