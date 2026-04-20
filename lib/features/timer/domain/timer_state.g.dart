// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerIdleImpl _$$TimerIdleImplFromJson(Map<String, dynamic> json) =>
    _$TimerIdleImpl(
      nextSessionType:
          $enumDecodeNullable(_$SessionTypeEnumMap, json['nextSessionType']) ??
          SessionType.work,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TimerIdleImplToJson(_$TimerIdleImpl instance) =>
    <String, dynamic>{
      'nextSessionType': _$SessionTypeEnumMap[instance.nextSessionType]!,
      'runtimeType': instance.$type,
    };

const _$SessionTypeEnumMap = {
  SessionType.work: 'work',
  SessionType.shortBreak: 'shortBreak',
  SessionType.longBreak: 'longBreak',
};

_$TimerRunningImpl _$$TimerRunningImplFromJson(Map<String, dynamic> json) =>
    _$TimerRunningImpl(
      session: PomodoroSession.fromJson(
        json['session'] as Map<String, dynamic>,
      ),
      elapsed: json['elapsed'] == null
          ? Duration.zero
          : const DurationMillisecondsConverter().fromJson(
              (json['elapsed'] as num).toInt(),
            ),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TimerRunningImplToJson(_$TimerRunningImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'elapsed': const DurationMillisecondsConverter().toJson(instance.elapsed),
      'runtimeType': instance.$type,
    };

_$TimerPausedImpl _$$TimerPausedImplFromJson(Map<String, dynamic> json) =>
    _$TimerPausedImpl(
      session: PomodoroSession.fromJson(
        json['session'] as Map<String, dynamic>,
      ),
      elapsed: const DurationMillisecondsConverter().fromJson(
        (json['elapsed'] as num).toInt(),
      ),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TimerPausedImplToJson(_$TimerPausedImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'elapsed': const DurationMillisecondsConverter().toJson(instance.elapsed),
      'runtimeType': instance.$type,
    };

_$TimerFinishedImpl _$$TimerFinishedImplFromJson(Map<String, dynamic> json) =>
    _$TimerFinishedImpl(
      session: PomodoroSession.fromJson(
        json['session'] as Map<String, dynamic>,
      ),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TimerFinishedImplToJson(_$TimerFinishedImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'runtimeType': instance.$type,
    };
