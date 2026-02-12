// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteDto {

 String get id; String get title; String get content; String get iv; String get dateCreated;
/// Create a copy of NoteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteDtoCopyWith<NoteDto> get copyWith => _$NoteDtoCopyWithImpl<NoteDto>(this as NoteDto, _$identity);

  /// Serializes this NoteDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,iv,dateCreated);

@override
String toString() {
  return 'NoteDto(id: $id, title: $title, content: $content, iv: $iv, dateCreated: $dateCreated)';
}


}

/// @nodoc
abstract mixin class $NoteDtoCopyWith<$Res>  {
  factory $NoteDtoCopyWith(NoteDto value, $Res Function(NoteDto) _then) = _$NoteDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, String iv, String dateCreated
});




}
/// @nodoc
class _$NoteDtoCopyWithImpl<$Res>
    implements $NoteDtoCopyWith<$Res> {
  _$NoteDtoCopyWithImpl(this._self, this._then);

  final NoteDto _self;
  final $Res Function(NoteDto) _then;

/// Create a copy of NoteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? iv = null,Object? dateCreated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,iv: null == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String,dateCreated: null == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteDto].
extension NoteDtoPatterns on NoteDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteDto value)  $default,){
final _that = this;
switch (_that) {
case _NoteDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteDto value)?  $default,){
final _that = this;
switch (_that) {
case _NoteDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String iv,  String dateCreated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteDto() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.iv,_that.dateCreated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String iv,  String dateCreated)  $default,) {final _that = this;
switch (_that) {
case _NoteDto():
return $default(_that.id,_that.title,_that.content,_that.iv,_that.dateCreated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  String iv,  String dateCreated)?  $default,) {final _that = this;
switch (_that) {
case _NoteDto() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.iv,_that.dateCreated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteDto extends NoteDto {
   _NoteDto({required this.id, required this.title, required this.content, required this.iv, required this.dateCreated}): super._();
  factory _NoteDto.fromJson(Map<String, dynamic> json) => _$NoteDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String content;
@override final  String iv;
@override final  String dateCreated;

/// Create a copy of NoteDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteDtoCopyWith<_NoteDto> get copyWith => __$NoteDtoCopyWithImpl<_NoteDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.dateCreated, dateCreated) || other.dateCreated == dateCreated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,iv,dateCreated);

@override
String toString() {
  return 'NoteDto(id: $id, title: $title, content: $content, iv: $iv, dateCreated: $dateCreated)';
}


}

/// @nodoc
abstract mixin class _$NoteDtoCopyWith<$Res> implements $NoteDtoCopyWith<$Res> {
  factory _$NoteDtoCopyWith(_NoteDto value, $Res Function(_NoteDto) _then) = __$NoteDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, String iv, String dateCreated
});




}
/// @nodoc
class __$NoteDtoCopyWithImpl<$Res>
    implements _$NoteDtoCopyWith<$Res> {
  __$NoteDtoCopyWithImpl(this._self, this._then);

  final _NoteDto _self;
  final $Res Function(_NoteDto) _then;

/// Create a copy of NoteDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? iv = null,Object? dateCreated = null,}) {
  return _then(_NoteDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,iv: null == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String,dateCreated: null == dateCreated ? _self.dateCreated : dateCreated // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
