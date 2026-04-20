// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PomodoroSessionImpl _$$PomodoroSessionImplFromJson(
  Map<String, dynamic> json,
) => _$PomodoroSessionImpl(
  id: json['id'] as String,
  type: $enumDecode(_$SessionTypeEnumMap, json['type']),
  duration: const DurationMillisecondsConverter().fromJson(
    (json['duration'] as num).toInt(),
  ),
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  completed: json['completed'] as bool? ?? false,
);

Map<String, dynamic> _$$PomodoroSessionImplToJson(
  _$PomodoroSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$SessionTypeEnumMap[instance.type]!,
  'duration': const DurationMillisecondsConverter().toJson(instance.duration),
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'completed': instance.completed,
};

const _$SessionTypeEnumMap = {
  SessionType.work: 'work',
  SessionType.shortBreak: 'shortBreak',
  SessionType.longBreak: 'longBreak',
};
