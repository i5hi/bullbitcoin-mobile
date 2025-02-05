// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthState {
  SecurityStep get step => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  String get confirmPin => throw _privateConstructorUsedError;
  bool get checking => throw _privateConstructorUsedError;
  String get err => throw _privateConstructorUsedError;
  bool get fromSettings => throw _privateConstructorUsedError;
  bool get loggedIn => throw _privateConstructorUsedError;
  bool get onStartChecking => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {SecurityStep step,
      String pin,
      String confirmPin,
      bool checking,
      String err,
      bool fromSettings,
      bool loggedIn,
      bool onStartChecking});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? pin = null,
    Object? confirmPin = null,
    Object? checking = null,
    Object? err = null,
    Object? fromSettings = null,
    Object? loggedIn = null,
    Object? onStartChecking = null,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as SecurityStep,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPin: null == confirmPin
          ? _value.confirmPin
          : confirmPin // ignore: cast_nullable_to_non_nullable
              as String,
      checking: null == checking
          ? _value.checking
          : checking // ignore: cast_nullable_to_non_nullable
              as bool,
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
      fromSettings: null == fromSettings
          ? _value.fromSettings
          : fromSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      loggedIn: null == loggedIn
          ? _value.loggedIn
          : loggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      onStartChecking: null == onStartChecking
          ? _value.onStartChecking
          : onStartChecking // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$$_AuthStateCopyWith(
          _$_AuthState value, $Res Function(_$_AuthState) then) =
      __$$_AuthStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SecurityStep step,
      String pin,
      String confirmPin,
      bool checking,
      String err,
      bool fromSettings,
      bool loggedIn,
      bool onStartChecking});
}

/// @nodoc
class __$$_AuthStateCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_AuthState>
    implements _$$_AuthStateCopyWith<$Res> {
  __$$_AuthStateCopyWithImpl(
      _$_AuthState _value, $Res Function(_$_AuthState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? pin = null,
    Object? confirmPin = null,
    Object? checking = null,
    Object? err = null,
    Object? fromSettings = null,
    Object? loggedIn = null,
    Object? onStartChecking = null,
  }) {
    return _then(_$_AuthState(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as SecurityStep,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPin: null == confirmPin
          ? _value.confirmPin
          : confirmPin // ignore: cast_nullable_to_non_nullable
              as String,
      checking: null == checking
          ? _value.checking
          : checking // ignore: cast_nullable_to_non_nullable
              as bool,
      err: null == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as String,
      fromSettings: null == fromSettings
          ? _value.fromSettings
          : fromSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      loggedIn: null == loggedIn
          ? _value.loggedIn
          : loggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      onStartChecking: null == onStartChecking
          ? _value.onStartChecking
          : onStartChecking // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AuthState extends _AuthState {
  const _$_AuthState(
      {this.step = SecurityStep.enterPin,
      this.pin = '',
      this.confirmPin = '',
      this.checking = true,
      this.err = '',
      this.fromSettings = false,
      this.loggedIn = false,
      this.onStartChecking = true})
      : super._();

  @override
  @JsonKey()
  final SecurityStep step;
  @override
  @JsonKey()
  final String pin;
  @override
  @JsonKey()
  final String confirmPin;
  @override
  @JsonKey()
  final bool checking;
  @override
  @JsonKey()
  final String err;
  @override
  @JsonKey()
  final bool fromSettings;
  @override
  @JsonKey()
  final bool loggedIn;
  @override
  @JsonKey()
  final bool onStartChecking;

  @override
  String toString() {
    return 'AuthState(step: $step, pin: $pin, confirmPin: $confirmPin, checking: $checking, err: $err, fromSettings: $fromSettings, loggedIn: $loggedIn, onStartChecking: $onStartChecking)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthState &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.confirmPin, confirmPin) ||
                other.confirmPin == confirmPin) &&
            (identical(other.checking, checking) ||
                other.checking == checking) &&
            (identical(other.err, err) || other.err == err) &&
            (identical(other.fromSettings, fromSettings) ||
                other.fromSettings == fromSettings) &&
            (identical(other.loggedIn, loggedIn) ||
                other.loggedIn == loggedIn) &&
            (identical(other.onStartChecking, onStartChecking) ||
                other.onStartChecking == onStartChecking));
  }

  @override
  int get hashCode => Object.hash(runtimeType, step, pin, confirmPin, checking,
      err, fromSettings, loggedIn, onStartChecking);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthStateCopyWith<_$_AuthState> get copyWith =>
      __$$_AuthStateCopyWithImpl<_$_AuthState>(this, _$identity);
}

abstract class _AuthState extends AuthState {
  const factory _AuthState(
      {final SecurityStep step,
      final String pin,
      final String confirmPin,
      final bool checking,
      final String err,
      final bool fromSettings,
      final bool loggedIn,
      final bool onStartChecking}) = _$_AuthState;
  const _AuthState._() : super._();

  @override
  SecurityStep get step;
  @override
  String get pin;
  @override
  String get confirmPin;
  @override
  bool get checking;
  @override
  String get err;
  @override
  bool get fromSettings;
  @override
  bool get loggedIn;
  @override
  bool get onStartChecking;
  @override
  @JsonKey(ignore: true)
  _$$_AuthStateCopyWith<_$_AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}
