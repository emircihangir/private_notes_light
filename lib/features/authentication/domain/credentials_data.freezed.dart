// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credentials_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CredentialsData {

 String get salt; String get iv; String get encryptedMasterKey;
/// Create a copy of CredentialsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CredentialsDataCopyWith<CredentialsData> get copyWith => _$CredentialsDataCopyWithImpl<CredentialsData>(this as CredentialsData, _$identity);

  /// Serializes this CredentialsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CredentialsData&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.encryptedMasterKey, encryptedMasterKey) || other.encryptedMasterKey == encryptedMasterKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,salt,iv,encryptedMasterKey);

@override
String toString() {
  return 'CredentialsData(salt: $salt, iv: $iv, encryptedMasterKey: $encryptedMasterKey)';
}


}

/// @nodoc
abstract mixin class $CredentialsDataCopyWith<$Res>  {
  factory $CredentialsDataCopyWith(CredentialsData value, $Res Function(CredentialsData) _then) = _$CredentialsDataCopyWithImpl;
@useResult
$Res call({
 String salt, String iv, String encryptedMasterKey
});




}
/// @nodoc
class _$CredentialsDataCopyWithImpl<$Res>
    implements $CredentialsDataCopyWith<$Res> {
  _$CredentialsDataCopyWithImpl(this._self, this._then);

  final CredentialsData _self;
  final $Res Function(CredentialsData) _then;

/// Create a copy of CredentialsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? salt = null,Object? iv = null,Object? encryptedMasterKey = null,}) {
  return _then(_self.copyWith(
salt: null == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String,iv: null == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String,encryptedMasterKey: null == encryptedMasterKey ? _self.encryptedMasterKey : encryptedMasterKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CredentialsData].
extension CredentialsDataPatterns on CredentialsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CredentialsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CredentialsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CredentialsData value)  $default,){
final _that = this;
switch (_that) {
case _CredentialsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CredentialsData value)?  $default,){
final _that = this;
switch (_that) {
case _CredentialsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String salt,  String iv,  String encryptedMasterKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CredentialsData() when $default != null:
return $default(_that.salt,_that.iv,_that.encryptedMasterKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String salt,  String iv,  String encryptedMasterKey)  $default,) {final _that = this;
switch (_that) {
case _CredentialsData():
return $default(_that.salt,_that.iv,_that.encryptedMasterKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String salt,  String iv,  String encryptedMasterKey)?  $default,) {final _that = this;
switch (_that) {
case _CredentialsData() when $default != null:
return $default(_that.salt,_that.iv,_that.encryptedMasterKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CredentialsData extends CredentialsData {
   _CredentialsData({required this.salt, required this.iv, required this.encryptedMasterKey}): super._();
  factory _CredentialsData.fromJson(Map<String, dynamic> json) => _$CredentialsDataFromJson(json);

@override final  String salt;
@override final  String iv;
@override final  String encryptedMasterKey;

/// Create a copy of CredentialsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CredentialsDataCopyWith<_CredentialsData> get copyWith => __$CredentialsDataCopyWithImpl<_CredentialsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CredentialsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CredentialsData&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.encryptedMasterKey, encryptedMasterKey) || other.encryptedMasterKey == encryptedMasterKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,salt,iv,encryptedMasterKey);

@override
String toString() {
  return 'CredentialsData(salt: $salt, iv: $iv, encryptedMasterKey: $encryptedMasterKey)';
}


}

/// @nodoc
abstract mixin class _$CredentialsDataCopyWith<$Res> implements $CredentialsDataCopyWith<$Res> {
  factory _$CredentialsDataCopyWith(_CredentialsData value, $Res Function(_CredentialsData) _then) = __$CredentialsDataCopyWithImpl;
@override @useResult
$Res call({
 String salt, String iv, String encryptedMasterKey
});




}
/// @nodoc
class __$CredentialsDataCopyWithImpl<$Res>
    implements _$CredentialsDataCopyWith<$Res> {
  __$CredentialsDataCopyWithImpl(this._self, this._then);

  final _CredentialsData _self;
  final $Res Function(_CredentialsData) _then;

/// Create a copy of CredentialsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? salt = null,Object? iv = null,Object? encryptedMasterKey = null,}) {
  return _then(_CredentialsData(
salt: null == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String,iv: null == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String,encryptedMasterKey: null == encryptedMasterKey ? _self.encryptedMasterKey : encryptedMasterKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
