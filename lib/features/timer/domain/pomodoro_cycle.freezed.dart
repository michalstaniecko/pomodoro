// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoro_cycle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PomodoroCycle {
  int get sessionsBeforeLongBreak => throw _privateConstructorUsedError;
  int get completedWorkSessions => throw _privateConstructorUsedError;

  /// Create a copy of PomodoroCycle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PomodoroCycleCopyWith<PomodoroCycle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroCycleCopyWith<$Res> {
  factory $PomodoroCycleCopyWith(
    PomodoroCycle value,
    $Res Function(PomodoroCycle) then,
  ) = _$PomodoroCycleCopyWithImpl<$Res, PomodoroCycle>;
  @useResult
  $Res call({int sessionsBeforeLongBreak, int completedWorkSessions});
}

/// @nodoc
class _$PomodoroCycleCopyWithImpl<$Res, $Val extends PomodoroCycle>
    implements $PomodoroCycleCopyWith<$Res> {
  _$PomodoroCycleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PomodoroCycle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionsBeforeLongBreak = null,
    Object? completedWorkSessions = null,
  }) {
    return _then(
      _value.copyWith(
            sessionsBeforeLongBreak: null == sessionsBeforeLongBreak
                ? _value.sessionsBeforeLongBreak
                : sessionsBeforeLongBreak // ignore: cast_nullable_to_non_nullable
                      as int,
            completedWorkSessions: null == completedWorkSessions
                ? _value.completedWorkSessions
                : completedWorkSessions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PomodoroCycleImplCopyWith<$Res>
    implements $PomodoroCycleCopyWith<$Res> {
  factory _$$PomodoroCycleImplCopyWith(
    _$PomodoroCycleImpl value,
    $Res Function(_$PomodoroCycleImpl) then,
  ) = __$$PomodoroCycleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sessionsBeforeLongBreak, int completedWorkSessions});
}

/// @nodoc
class __$$PomodoroCycleImplCopyWithImpl<$Res>
    extends _$PomodoroCycleCopyWithImpl<$Res, _$PomodoroCycleImpl>
    implements _$$PomodoroCycleImplCopyWith<$Res> {
  __$$PomodoroCycleImplCopyWithImpl(
    _$PomodoroCycleImpl _value,
    $Res Function(_$PomodoroCycleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PomodoroCycle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionsBeforeLongBreak = null,
    Object? completedWorkSessions = null,
  }) {
    return _then(
      _$PomodoroCycleImpl(
        sessionsBeforeLongBreak: null == sessionsBeforeLongBreak
            ? _value.sessionsBeforeLongBreak
            : sessionsBeforeLongBreak // ignore: cast_nullable_to_non_nullable
                  as int,
        completedWorkSessions: null == completedWorkSessions
            ? _value.completedWorkSessions
            : completedWorkSessions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PomodoroCycleImpl extends _PomodoroCycle {
  const _$PomodoroCycleImpl({
    this.sessionsBeforeLongBreak = 4,
    this.completedWorkSessions = 0,
  }) : assert(
         sessionsBeforeLongBreak >= 1,
         'sessionsBeforeLongBreak must be >= 1',
       ),
       assert(completedWorkSessions >= 0, 'completedWorkSessions must be >= 0'),
       super._();

  @override
  @JsonKey()
  final int sessionsBeforeLongBreak;
  @override
  @JsonKey()
  final int completedWorkSessions;

  @override
  String toString() {
    return 'PomodoroCycle(sessionsBeforeLongBreak: $sessionsBeforeLongBreak, completedWorkSessions: $completedWorkSessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroCycleImpl &&
            (identical(
                  other.sessionsBeforeLongBreak,
                  sessionsBeforeLongBreak,
                ) ||
                other.sessionsBeforeLongBreak == sessionsBeforeLongBreak) &&
            (identical(other.completedWorkSessions, completedWorkSessions) ||
                other.completedWorkSessions == completedWorkSessions));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sessionsBeforeLongBreak, completedWorkSessions);

  /// Create a copy of PomodoroCycle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroCycleImplCopyWith<_$PomodoroCycleImpl> get copyWith =>
      __$$PomodoroCycleImplCopyWithImpl<_$PomodoroCycleImpl>(this, _$identity);
}

abstract class _PomodoroCycle extends PomodoroCycle {
  const factory _PomodoroCycle({
    final int sessionsBeforeLongBreak,
    final int completedWorkSessions,
  }) = _$PomodoroCycleImpl;
  const _PomodoroCycle._() : super._();

  @override
  int get sessionsBeforeLongBreak;
  @override
  int get completedWorkSessions;

  /// Create a copy of PomodoroCycle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PomodoroCycleImplCopyWith<_$PomodoroCycleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
