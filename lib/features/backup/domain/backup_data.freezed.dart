// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupData implements DiagnosticableTreeMixin {

 CredentialsData get credentialsData; SettingsData get settingsData; List<NoteDto> get notesData;
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupDataCopyWith<BackupData> get copyWith => _$BackupDataCopyWithImpl<BackupData>(this as BackupData, _$identity);

  /// Serializes this BackupData to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupData'))
    ..add(DiagnosticsProperty('credentialsData', credentialsData))..add(DiagnosticsProperty('settingsData', settingsData))..add(DiagnosticsProperty('notesData', notesData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupData&&(identical(other.credentialsData, credentialsData) || other.credentialsData == credentialsData)&&(identical(other.settingsData, settingsData) || other.settingsData == settingsData)&&const DeepCollectionEquality().equals(other.notesData, notesData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentialsData,settingsData,const DeepCollectionEquality().hash(notesData));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupData(credentialsData: $credentialsData, settingsData: $settingsData, notesData: $notesData)';
}


}

/// @nodoc
abstract mixin class $BackupDataCopyWith<$Res>  {
  factory $BackupDataCopyWith(BackupData value, $Res Function(BackupData) _then) = _$BackupDataCopyWithImpl;
@useResult
$Res call({
 CredentialsData credentialsData, SettingsData settingsData, List<NoteDto> notesData
});


$CredentialsDataCopyWith<$Res> get credentialsData;$SettingsDataCopyWith<$Res> get settingsData;

}
/// @nodoc
class _$BackupDataCopyWithImpl<$Res>
    implements $BackupDataCopyWith<$Res> {
  _$BackupDataCopyWithImpl(this._self, this._then);

  final BackupData _self;
  final $Res Function(BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? credentialsData = null,Object? settingsData = null,Object? notesData = null,}) {
  return _then(_self.copyWith(
credentialsData: null == credentialsData ? _self.credentialsData : credentialsData // ignore: cast_nullable_to_non_nullable
as CredentialsData,settingsData: null == settingsData ? _self.settingsData : settingsData // ignore: cast_nullable_to_non_nullable
as SettingsData,notesData: null == notesData ? _self.notesData : notesData // ignore: cast_nullable_to_non_nullable
as List<NoteDto>,
  ));
}
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialsDataCopyWith<$Res> get credentialsData {
  
  return $CredentialsDataCopyWith<$Res>(_self.credentialsData, (value) {
    return _then(_self.copyWith(credentialsData: value));
  });
}/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsDataCopyWith<$Res> get settingsData {
  
  return $SettingsDataCopyWith<$Res>(_self.settingsData, (value) {
    return _then(_self.copyWith(settingsData: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupData].
extension BackupDataPatterns on BackupData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupData value)  $default,){
final _that = this;
switch (_that) {
case _BackupData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupData value)?  $default,){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CredentialsData credentialsData,  SettingsData settingsData,  List<NoteDto> notesData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.credentialsData,_that.settingsData,_that.notesData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CredentialsData credentialsData,  SettingsData settingsData,  List<NoteDto> notesData)  $default,) {final _that = this;
switch (_that) {
case _BackupData():
return $default(_that.credentialsData,_that.settingsData,_that.notesData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CredentialsData credentialsData,  SettingsData settingsData,  List<NoteDto> notesData)?  $default,) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.credentialsData,_that.settingsData,_that.notesData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupData extends BackupData with DiagnosticableTreeMixin {
   _BackupData({required this.credentialsData, required this.settingsData, required final  List<NoteDto> notesData}): _notesData = notesData,super._();
  factory _BackupData.fromJson(Map<String, dynamic> json) => _$BackupDataFromJson(json);

@override final  CredentialsData credentialsData;
@override final  SettingsData settingsData;
 final  List<NoteDto> _notesData;
@override List<NoteDto> get notesData {
  if (_notesData is EqualUnmodifiableListView) return _notesData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notesData);
}


/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupDataCopyWith<_BackupData> get copyWith => __$BackupDataCopyWithImpl<_BackupData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupDataToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BackupData'))
    ..add(DiagnosticsProperty('credentialsData', credentialsData))..add(DiagnosticsProperty('settingsData', settingsData))..add(DiagnosticsProperty('notesData', notesData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupData&&(identical(other.credentialsData, credentialsData) || other.credentialsData == credentialsData)&&(identical(other.settingsData, settingsData) || other.settingsData == settingsData)&&const DeepCollectionEquality().equals(other._notesData, _notesData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentialsData,settingsData,const DeepCollectionEquality().hash(_notesData));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BackupData(credentialsData: $credentialsData, settingsData: $settingsData, notesData: $notesData)';
}


}

/// @nodoc
abstract mixin class _$BackupDataCopyWith<$Res> implements $BackupDataCopyWith<$Res> {
  factory _$BackupDataCopyWith(_BackupData value, $Res Function(_BackupData) _then) = __$BackupDataCopyWithImpl;
@override @useResult
$Res call({
 CredentialsData credentialsData, SettingsData settingsData, List<NoteDto> notesData
});


@override $CredentialsDataCopyWith<$Res> get credentialsData;@override $SettingsDataCopyWith<$Res> get settingsData;

}
/// @nodoc
class __$BackupDataCopyWithImpl<$Res>
    implements _$BackupDataCopyWith<$Res> {
  __$BackupDataCopyWithImpl(this._self, this._then);

  final _BackupData _self;
  final $Res Function(_BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? credentialsData = null,Object? settingsData = null,Object? notesData = null,}) {
  return _then(_BackupData(
credentialsData: null == credentialsData ? _self.credentialsData : credentialsData // ignore: cast_nullable_to_non_nullable
as CredentialsData,settingsData: null == settingsData ? _self.settingsData : settingsData // ignore: cast_nullable_to_non_nullable
as SettingsData,notesData: null == notesData ? _self._notesData : notesData // ignore: cast_nullable_to_non_nullable
as List<NoteDto>,
  ));
}

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialsDataCopyWith<$Res> get credentialsData {
  
  return $CredentialsDataCopyWith<$Res>(_self.credentialsData, (value) {
    return _then(_self.copyWith(credentialsData: value));
  });
}/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsDataCopyWith<$Res> get settingsData {
  
  return $SettingsDataCopyWith<$Res>(_self.settingsData, (value) {
    return _then(_self.copyWith(settingsData: value));
  });
}
}

// dart format on
