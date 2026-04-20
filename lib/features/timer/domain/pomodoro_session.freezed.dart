// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoro_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PomodoroSession _$PomodoroSessionFromJson(Map<String, dynamic> json) {
  return _PomodoroSession.fromJson(json);
}

/// @nodoc
mixin _$PomodoroSession {
  String get id => throw _privateConstructorUsedError;
  SessionType get type => throw _privateConstructorUsedError;
  @DurationMillisecondsConverter()
  Duration get duration => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this PomodoroSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PomodoroSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PomodoroSessionCopyWith<PomodoroSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroSessionCopyWith<$Res> {
  factory $PomodoroSessionCopyWith(
    PomodoroSession value,
    $Res Function(PomodoroSession) then,
  ) = _$PomodoroSessionCopyWithImpl<$Res, PomodoroSession>;
  @useResult
  $Res call({
    String id,
    SessionType type,
    @DurationMillisecondsConverter() Duration duration,
    DateTime startedAt,
    DateTime? completedAt,
    bool completed,
  });
}

/// @nodoc
class _$PomodoroSessionCopyWithImpl<$Res, $Val extends PomodoroSession>
    implements $PomodoroSessionCopyWith<$Res> {
  _$PomodoroSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PomodoroSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? duration = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SessionType,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PomodoroSessionImplCopyWith<$Res>
    implements $PomodoroSessionCopyWith<$Res> {
  factory _$$PomodoroSessionImplCopyWith(
    _$PomodoroSessionImpl value,
    $Res Function(_$PomodoroSessionImpl) then,
  ) = __$$PomodoroSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    SessionType type,
    @DurationMillisecondsConverter() Duration duration,
    DateTime startedAt,
    DateTime? completedAt,
    bool completed,
  });
}

/// @nodoc
class __$$PomodoroSessionImplCopyWithImpl<$Res>
    extends _$PomodoroSessionCopyWithImpl<$Res, _$PomodoroSessionImpl>
    implements _$$PomodoroSessionImplCopyWith<$Res> {
  __$$PomodoroSessionImplCopyWithImpl(
    _$PomodoroSessionImpl _value,
    $Res Function(_$PomodoroSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PomodoroSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? duration = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? completed = null,
  }) {
    return _then(
      _$PomodoroSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SessionType,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PomodoroSessionImpl implements _PomodoroSession {
  const _$PomodoroSessionImpl({
    required this.id,
    required this.type,
    @DurationMillisecondsConverter() required this.duration,
    required this.startedAt,
    this.completedAt,
    this.completed = false,
  });

  factory _$PomodoroSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PomodoroSessionImplFromJson(json);

  @override
  final String id;
  @override
  final SessionType type;
  @override
  @DurationMillisecondsConverter()
  final Duration duration;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'PomodoroSession(id: $id, type: $type, duration: $duration, startedAt: $startedAt, completedAt: $completedAt, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    duration,
    startedAt,
    completedAt,
    completed,
  );

  /// Create a copy of PomodoroSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroSessionImplCopyWith<_$PomodoroSessionImpl> get copyWith =>
      __$$PomodoroSessionImplCopyWithImpl<_$PomodoroSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PomodoroSessionImplToJson(this);
  }
}

abstract class _PomodoroSession implements PomodoroSession {
  const factory _PomodoroSession({
    required final String id,
    required final SessionType type,
    @DurationMillisecondsConverter() required final Duration duration,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final bool completed,
  }) = _$PomodoroSessionImpl;

  factory _PomodoroSession.fromJson(Map<String, dynamic> json) =
      _$PomodoroSessionImpl.fromJson;

  @override
  String get id;
  @override
  SessionType get type;
  @override
  @DurationMillisecondsConverter()
  Duration get duration;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  bool get completed;

  /// Create a copy of PomodoroSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PomodoroSessionImplCopyWith<_$PomodoroSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
