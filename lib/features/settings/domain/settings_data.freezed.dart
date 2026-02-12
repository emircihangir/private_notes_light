// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsData {

 bool get exportSuggestions; bool get exportWarnings; ThemeMode get theme;
/// Create a copy of SettingsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDataCopyWith<SettingsData> get copyWith => _$SettingsDataCopyWithImpl<SettingsData>(this as SettingsData, _$identity);

  /// Serializes this SettingsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsData&&(identical(other.exportSuggestions, exportSuggestions) || other.exportSuggestions == exportSuggestions)&&(identical(other.exportWarnings, exportWarnings) || other.exportWarnings == exportWarnings)&&(identical(other.theme, theme) || other.theme == theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exportSuggestions,exportWarnings,theme);

@override
String toString() {
  return 'SettingsData(exportSuggestions: $exportSuggestions, exportWarnings: $exportWarnings, theme: $theme)';
}


}

/// @nodoc
abstract mixin class $SettingsDataCopyWith<$Res>  {
  factory $SettingsDataCopyWith(SettingsData value, $Res Function(SettingsData) _then) = _$SettingsDataCopyWithImpl;
@useResult
$Res call({
 bool exportSuggestions, bool exportWarnings, ThemeMode theme
});




}
/// @nodoc
class _$SettingsDataCopyWithImpl<$Res>
    implements $SettingsDataCopyWith<$Res> {
  _$SettingsDataCopyWithImpl(this._self, this._then);

  final SettingsData _self;
  final $Res Function(SettingsData) _then;

/// Create a copy of SettingsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exportSuggestions = null,Object? exportWarnings = null,Object? theme = null,}) {
  return _then(_self.copyWith(
exportSuggestions: null == exportSuggestions ? _self.exportSuggestions : exportSuggestions // ignore: cast_nullable_to_non_nullable
as bool,exportWarnings: null == exportWarnings ? _self.exportWarnings : exportWarnings // ignore: cast_nullable_to_non_nullable
as bool,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsData].
extension SettingsDataPatterns on SettingsData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsData value)  $default,){
final _that = this;
switch (_that) {
case _SettingsData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsData value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool exportSuggestions,  bool exportWarnings,  ThemeMode theme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsData() when $default != null:
return $default(_that.exportSuggestions,_that.exportWarnings,_that.theme);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool exportSuggestions,  bool exportWarnings,  ThemeMode theme)  $default,) {final _that = this;
switch (_that) {
case _SettingsData():
return $default(_that.exportSuggestions,_that.exportWarnings,_that.theme);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool exportSuggestions,  bool exportWarnings,  ThemeMode theme)?  $default,) {final _that = this;
switch (_that) {
case _SettingsData() when $default != null:
return $default(_that.exportSuggestions,_that.exportWarnings,_that.theme);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsData extends SettingsData {
   _SettingsData({required this.exportSuggestions, required this.exportWarnings, required this.theme}): super._();
  factory _SettingsData.fromJson(Map<String, dynamic> json) => _$SettingsDataFromJson(json);

@override final  bool exportSuggestions;
@override final  bool exportWarnings;
@override final  ThemeMode theme;

/// Create a copy of SettingsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsDataCopyWith<_SettingsData> get copyWith => __$SettingsDataCopyWithImpl<_SettingsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsData&&(identical(other.exportSuggestions, exportSuggestions) || other.exportSuggestions == exportSuggestions)&&(identical(other.exportWarnings, exportWarnings) || other.exportWarnings == exportWarnings)&&(identical(other.theme, theme) || other.theme == theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exportSuggestions,exportWarnings,theme);

@override
String toString() {
  return 'SettingsData(exportSuggestions: $exportSuggestions, exportWarnings: $exportWarnings, theme: $theme)';
}


}

/// @nodoc
abstract mixin class _$SettingsDataCopyWith<$Res> implements $SettingsDataCopyWith<$Res> {
  factory _$SettingsDataCopyWith(_SettingsData value, $Res Function(_SettingsData) _then) = __$SettingsDataCopyWithImpl;
@override @useResult
$Res call({
 bool exportSuggestions, bool exportWarnings, ThemeMode theme
});




}
/// @nodoc
class __$SettingsDataCopyWithImpl<$Res>
    implements _$SettingsDataCopyWith<$Res> {
  __$SettingsDataCopyWithImpl(this._self, this._then);

  final _SettingsData _self;
  final $Res Function(_SettingsData) _then;

/// Create a copy of SettingsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exportSuggestions = null,Object? exportWarnings = null,Object? theme = null,}) {
  return _then(_SettingsData(
exportSuggestions: null == exportSuggestions ? _self.exportSuggestions : exportSuggestions // ignore: cast_nullable_to_non_nullable
as bool,exportWarnings: null == exportWarnings ? _self.exportWarnings : exportWarnings // ignore: cast_nullable_to_non_nullable
as bool,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

// dart format on
