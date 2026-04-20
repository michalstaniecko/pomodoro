// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimerState _$TimerStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'idle':
      return TimerIdle.fromJson(json);
    case 'running':
      return TimerRunning.fromJson(json);
    case 'paused':
      return TimerPaused.fromJson(json);
    case 'finished':
      return TimerFinished.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'TimerState',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$TimerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SessionType nextSessionType) idle,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    running,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    paused,
    required TResult Function(PomodoroSession session) finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SessionType nextSessionType)? idle,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult? Function(PomodoroSession session)? finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SessionType nextSessionType)? idle,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult Function(PomodoroSession session)? finished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerFinished value) finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerFinished value)? finished,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerFinished value)? finished,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this TimerState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerStateCopyWith<$Res> {
  factory $TimerStateCopyWith(
    TimerState value,
    $Res Function(TimerState) then,
  ) = _$TimerStateCopyWithImpl<$Res, TimerState>;
}

/// @nodoc
class _$TimerStateCopyWithImpl<$Res, $Val extends TimerState>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TimerIdleImplCopyWith<$Res> {
  factory _$$TimerIdleImplCopyWith(
    _$TimerIdleImpl value,
    $Res Function(_$TimerIdleImpl) then,
  ) = __$$TimerIdleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SessionType nextSessionType});
}

/// @nodoc
class __$$TimerIdleImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerIdleImpl>
    implements _$$TimerIdleImplCopyWith<$Res> {
  __$$TimerIdleImplCopyWithImpl(
    _$TimerIdleImpl _value,
    $Res Function(_$TimerIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nextSessionType = null}) {
    return _then(
      _$TimerIdleImpl(
        nextSessionType: null == nextSessionType
            ? _value.nextSessionType
            : nextSessionType // ignore: cast_nullable_to_non_nullable
                  as SessionType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerIdleImpl implements TimerIdle {
  const _$TimerIdleImpl({
    this.nextSessionType = SessionType.work,
    final String? $type,
  }) : $type = $type ?? 'idle';

  factory _$TimerIdleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerIdleImplFromJson(json);

  @override
  @JsonKey()
  final SessionType nextSessionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TimerState.idle(nextSessionType: $nextSessionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerIdleImpl &&
            (identical(other.nextSessionType, nextSessionType) ||
                other.nextSessionType == nextSessionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nextSessionType);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerIdleImplCopyWith<_$TimerIdleImpl> get copyWith =>
      __$$TimerIdleImplCopyWithImpl<_$TimerIdleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SessionType nextSessionType) idle,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    running,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    paused,
    required TResult Function(PomodoroSession session) finished,
  }) {
    return idle(nextSessionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SessionType nextSessionType)? idle,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult? Function(PomodoroSession session)? finished,
  }) {
    return idle?.call(nextSessionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SessionType nextSessionType)? idle,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult Function(PomodoroSession session)? finished,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(nextSessionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerFinished value) finished,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerFinished value)? finished,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerFinished value)? finished,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerIdleImplToJson(this);
  }
}

abstract class TimerIdle implements TimerState {
  const factory TimerIdle({final SessionType nextSessionType}) =
      _$TimerIdleImpl;

  factory TimerIdle.fromJson(Map<String, dynamic> json) =
      _$TimerIdleImpl.fromJson;

  SessionType get nextSessionType;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerIdleImplCopyWith<_$TimerIdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerRunningImplCopyWith<$Res> {
  factory _$$TimerRunningImplCopyWith(
    _$TimerRunningImpl value,
    $Res Function(_$TimerRunningImpl) then,
  ) = __$$TimerRunningImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    PomodoroSession session,
    @DurationMillisecondsConverter() Duration elapsed,
  });

  $PomodoroSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$TimerRunningImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerRunningImpl>
    implements _$$TimerRunningImplCopyWith<$Res> {
  __$$TimerRunningImplCopyWithImpl(
    _$TimerRunningImpl _value,
    $Res Function(_$TimerRunningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? elapsed = null}) {
    return _then(
      _$TimerRunningImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as PomodoroSession,
        elapsed: null == elapsed
            ? _value.elapsed
            : elapsed // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PomodoroSessionCopyWith<$Res> get session {
    return $PomodoroSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerRunningImpl implements TimerRunning {
  const _$TimerRunningImpl({
    required this.session,
    @DurationMillisecondsConverter() this.elapsed = Duration.zero,
    final String? $type,
  }) : $type = $type ?? 'running';

  factory _$TimerRunningImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerRunningImplFromJson(json);

  @override
  final PomodoroSession session;
  @override
  @JsonKey()
  @DurationMillisecondsConverter()
  final Duration elapsed;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TimerState.running(session: $session, elapsed: $elapsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerRunningImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.elapsed, elapsed) || other.elapsed == elapsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, session, elapsed);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerRunningImplCopyWith<_$TimerRunningImpl> get copyWith =>
      __$$TimerRunningImplCopyWithImpl<_$TimerRunningImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SessionType nextSessionType) idle,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    running,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    paused,
    required TResult Function(PomodoroSession session) finished,
  }) {
    return running(session, elapsed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SessionType nextSessionType)? idle,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult? Function(PomodoroSession session)? finished,
  }) {
    return running?.call(session, elapsed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SessionType nextSessionType)? idle,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult Function(PomodoroSession session)? finished,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(session, elapsed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerFinished value) finished,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerFinished value)? finished,
  }) {
    return running?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerFinished value)? finished,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerRunningImplToJson(this);
  }
}

abstract class TimerRunning implements TimerState {
  const factory TimerRunning({
    required final PomodoroSession session,
    @DurationMillisecondsConverter() final Duration elapsed,
  }) = _$TimerRunningImpl;

  factory TimerRunning.fromJson(Map<String, dynamic> json) =
      _$TimerRunningImpl.fromJson;

  PomodoroSession get session;
  @DurationMillisecondsConverter()
  Duration get elapsed;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerRunningImplCopyWith<_$TimerRunningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerPausedImplCopyWith<$Res> {
  factory _$$TimerPausedImplCopyWith(
    _$TimerPausedImpl value,
    $Res Function(_$TimerPausedImpl) then,
  ) = __$$TimerPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    PomodoroSession session,
    @DurationMillisecondsConverter() Duration elapsed,
  });

  $PomodoroSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$TimerPausedImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerPausedImpl>
    implements _$$TimerPausedImplCopyWith<$Res> {
  __$$TimerPausedImplCopyWithImpl(
    _$TimerPausedImpl _value,
    $Res Function(_$TimerPausedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? elapsed = null}) {
    return _then(
      _$TimerPausedImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as PomodoroSession,
        elapsed: null == elapsed
            ? _value.elapsed
            : elapsed // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PomodoroSessionCopyWith<$Res> get session {
    return $PomodoroSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerPausedImpl implements TimerPaused {
  const _$TimerPausedImpl({
    required this.session,
    @DurationMillisecondsConverter() required this.elapsed,
    final String? $type,
  }) : $type = $type ?? 'paused';

  factory _$TimerPausedImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerPausedImplFromJson(json);

  @override
  final PomodoroSession session;
  @override
  @DurationMillisecondsConverter()
  final Duration elapsed;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TimerState.paused(session: $session, elapsed: $elapsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerPausedImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.elapsed, elapsed) || other.elapsed == elapsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, session, elapsed);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      __$$TimerPausedImplCopyWithImpl<_$TimerPausedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SessionType nextSessionType) idle,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    running,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    paused,
    required TResult Function(PomodoroSession session) finished,
  }) {
    return paused(session, elapsed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SessionType nextSessionType)? idle,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult? Function(PomodoroSession session)? finished,
  }) {
    return paused?.call(session, elapsed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SessionType nextSessionType)? idle,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult Function(PomodoroSession session)? finished,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(session, elapsed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerFinished value) finished,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerFinished value)? finished,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerFinished value)? finished,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerPausedImplToJson(this);
  }
}

abstract class TimerPaused implements TimerState {
  const factory TimerPaused({
    required final PomodoroSession session,
    @DurationMillisecondsConverter() required final Duration elapsed,
  }) = _$TimerPausedImpl;

  factory TimerPaused.fromJson(Map<String, dynamic> json) =
      _$TimerPausedImpl.fromJson;

  PomodoroSession get session;
  @DurationMillisecondsConverter()
  Duration get elapsed;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerFinishedImplCopyWith<$Res> {
  factory _$$TimerFinishedImplCopyWith(
    _$TimerFinishedImpl value,
    $Res Function(_$TimerFinishedImpl) then,
  ) = __$$TimerFinishedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PomodoroSession session});

  $PomodoroSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$TimerFinishedImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerFinishedImpl>
    implements _$$TimerFinishedImplCopyWith<$Res> {
  __$$TimerFinishedImplCopyWithImpl(
    _$TimerFinishedImpl _value,
    $Res Function(_$TimerFinishedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null}) {
    return _then(
      _$TimerFinishedImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as PomodoroSession,
      ),
    );
  }

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PomodoroSessionCopyWith<$Res> get session {
    return $PomodoroSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerFinishedImpl implements TimerFinished {
  const _$TimerFinishedImpl({required this.session, final String? $type})
    : $type = $type ?? 'finished';

  factory _$TimerFinishedImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerFinishedImplFromJson(json);

  @override
  final PomodoroSession session;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TimerState.finished(session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerFinishedImpl &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, session);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerFinishedImplCopyWith<_$TimerFinishedImpl> get copyWith =>
      __$$TimerFinishedImplCopyWithImpl<_$TimerFinishedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SessionType nextSessionType) idle,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    running,
    required TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )
    paused,
    required TResult Function(PomodoroSession session) finished,
  }) {
    return finished(session);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SessionType nextSessionType)? idle,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult? Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult? Function(PomodoroSession session)? finished,
  }) {
    return finished?.call(session);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SessionType nextSessionType)? idle,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    running,
    TResult Function(
      PomodoroSession session,
      @DurationMillisecondsConverter() Duration elapsed,
    )?
    paused,
    TResult Function(PomodoroSession session)? finished,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerRunning value) running,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerFinished value) finished,
  }) {
    return finished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerRunning value)? running,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerFinished value)? finished,
  }) {
    return finished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerRunning value)? running,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerFinished value)? finished,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerFinishedImplToJson(this);
  }
}

abstract class TimerFinished implements TimerState {
  const factory TimerFinished({required final PomodoroSession session}) =
      _$TimerFinishedImpl;

  factory TimerFinished.fromJson(Map<String, dynamic> json) =
      _$TimerFinishedImpl.fromJson;

  PomodoroSession get session;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerFinishedImplCopyWith<_$TimerFinishedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
