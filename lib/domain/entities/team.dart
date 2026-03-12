import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required String createdBy,
    required DateTime createdAt,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
