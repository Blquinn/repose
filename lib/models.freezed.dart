// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResponseDetail {
  http.Response get response => throw _privateConstructorUsedError;
  Duration get timing => throw _privateConstructorUsedError;

  /// Create a copy of ResponseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseDetailCopyWith<ResponseDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseDetailCopyWith<$Res> {
  factory $ResponseDetailCopyWith(
          ResponseDetail value, $Res Function(ResponseDetail) then) =
      _$ResponseDetailCopyWithImpl<$Res, ResponseDetail>;
  @useResult
  $Res call({http.Response response, Duration timing});
}

/// @nodoc
class _$ResponseDetailCopyWithImpl<$Res, $Val extends ResponseDetail>
    implements $ResponseDetailCopyWith<$Res> {
  _$ResponseDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? timing = null,
  }) {
    return _then(_value.copyWith(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as http.Response,
      timing: null == timing
          ? _value.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseDetailImplCopyWith<$Res>
    implements $ResponseDetailCopyWith<$Res> {
  factory _$$ResponseDetailImplCopyWith(_$ResponseDetailImpl value,
          $Res Function(_$ResponseDetailImpl) then) =
      __$$ResponseDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({http.Response response, Duration timing});
}

/// @nodoc
class __$$ResponseDetailImplCopyWithImpl<$Res>
    extends _$ResponseDetailCopyWithImpl<$Res, _$ResponseDetailImpl>
    implements _$$ResponseDetailImplCopyWith<$Res> {
  __$$ResponseDetailImplCopyWithImpl(
      _$ResponseDetailImpl _value, $Res Function(_$ResponseDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponseDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? timing = null,
  }) {
    return _then(_$ResponseDetailImpl(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as http.Response,
      timing: null == timing
          ? _value.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$ResponseDetailImpl implements _ResponseDetail {
  const _$ResponseDetailImpl({required this.response, required this.timing});

  @override
  final http.Response response;
  @override
  final Duration timing;

  @override
  String toString() {
    return 'ResponseDetail(response: $response, timing: $timing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseDetailImpl &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response, timing);

  /// Create a copy of ResponseDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseDetailImplCopyWith<_$ResponseDetailImpl> get copyWith =>
      __$$ResponseDetailImplCopyWithImpl<_$ResponseDetailImpl>(
          this, _$identity);
}

abstract class _ResponseDetail implements ResponseDetail {
  const factory _ResponseDetail(
      {required final http.Response response,
      required final Duration timing}) = _$ResponseDetailImpl;

  @override
  http.Response get response;
  @override
  Duration get timing;

  /// Create a copy of ResponseDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseDetailImplCopyWith<_$ResponseDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppLayout {
  Axis get requestResponseViewAxis => throw _privateConstructorUsedError;

  /// Create a copy of AppLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppLayoutCopyWith<AppLayout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppLayoutCopyWith<$Res> {
  factory $AppLayoutCopyWith(AppLayout value, $Res Function(AppLayout) then) =
      _$AppLayoutCopyWithImpl<$Res, AppLayout>;
  @useResult
  $Res call({Axis requestResponseViewAxis});
}

/// @nodoc
class _$AppLayoutCopyWithImpl<$Res, $Val extends AppLayout>
    implements $AppLayoutCopyWith<$Res> {
  _$AppLayoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestResponseViewAxis = null,
  }) {
    return _then(_value.copyWith(
      requestResponseViewAxis: null == requestResponseViewAxis
          ? _value.requestResponseViewAxis
          : requestResponseViewAxis // ignore: cast_nullable_to_non_nullable
              as Axis,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppLayoutImplCopyWith<$Res>
    implements $AppLayoutCopyWith<$Res> {
  factory _$$AppLayoutImplCopyWith(
          _$AppLayoutImpl value, $Res Function(_$AppLayoutImpl) then) =
      __$$AppLayoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Axis requestResponseViewAxis});
}

/// @nodoc
class __$$AppLayoutImplCopyWithImpl<$Res>
    extends _$AppLayoutCopyWithImpl<$Res, _$AppLayoutImpl>
    implements _$$AppLayoutImplCopyWith<$Res> {
  __$$AppLayoutImplCopyWithImpl(
      _$AppLayoutImpl _value, $Res Function(_$AppLayoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestResponseViewAxis = null,
  }) {
    return _then(_$AppLayoutImpl(
      requestResponseViewAxis: null == requestResponseViewAxis
          ? _value.requestResponseViewAxis
          : requestResponseViewAxis // ignore: cast_nullable_to_non_nullable
              as Axis,
    ));
  }
}

/// @nodoc

class _$AppLayoutImpl implements _AppLayout {
  const _$AppLayoutImpl({required this.requestResponseViewAxis});

  @override
  final Axis requestResponseViewAxis;

  @override
  String toString() {
    return 'AppLayout(requestResponseViewAxis: $requestResponseViewAxis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppLayoutImpl &&
            (identical(
                    other.requestResponseViewAxis, requestResponseViewAxis) ||
                other.requestResponseViewAxis == requestResponseViewAxis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestResponseViewAxis);

  /// Create a copy of AppLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppLayoutImplCopyWith<_$AppLayoutImpl> get copyWith =>
      __$$AppLayoutImplCopyWithImpl<_$AppLayoutImpl>(this, _$identity);
}

abstract class _AppLayout implements AppLayout {
  const factory _AppLayout({required final Axis requestResponseViewAxis}) =
      _$AppLayoutImpl;

  @override
  Axis get requestResponseViewAxis;

  /// Create a copy of AppLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppLayoutImplCopyWith<_$AppLayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
