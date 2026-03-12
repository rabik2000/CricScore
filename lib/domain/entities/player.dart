import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String teamId,
    required String name,
    required String battingStyle, // e.g., 'Right-hand bat'
    required String bowlingStyle, // e.g., 'Right-arm medium'
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
