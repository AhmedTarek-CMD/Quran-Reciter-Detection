import 'package:equatable/equatable.dart';

class Moshaf extends Equatable {

  final int id;
  final String name;
  final String server;

  const Moshaf({required this.id, required this.name, required this.server});

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(id: json['id'], name: json['name'], server: json['server']);
  }

  @override
  List<Object?> get props => [id, name, server];

}