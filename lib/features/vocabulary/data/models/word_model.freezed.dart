// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WordModel _$WordModelFromJson(Map<String, dynamic> json) {
  return _WordModel.fromJson(json);
}

/// @nodoc
mixin _$WordModel {
  int get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get englishWord => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordModelCopyWith<WordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordModelCopyWith<$Res> {
  factory $WordModelCopyWith(WordModel value, $Res Function(WordModel) then) =
      _$WordModelCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String userId,
      String englishWord,
      String translation,
      DateTime createdAt});
}

/// @nodoc
class _$WordModelCopyWithImpl<$Res> implements $WordModelCopyWith<$Res> {
  _$WordModelCopyWithImpl(this._value, this._then);

  final WordModel _value;
  // ignore: unused_field
  final $Res Function(WordModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? englishWord = freezed,
    Object? translation = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      englishWord: englishWord == freezed
          ? _value.englishWord
          : englishWord // ignore: cast_nullable_to_non_nullable
              as String,
      translation: translation == freezed
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$$_WordModelCopyWith<$Res> implements $WordModelCopyWith<$Res> {
  factory _$$_WordModelCopyWith(
          _$_WordModel value, $Res Function(_$_WordModel) then) =
      __$$_WordModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String userId,
      String englishWord,
      String translation,
      DateTime createdAt});
}

/// @nodoc
class __$$_WordModelCopyWithImpl<$Res> extends _$WordModelCopyWithImpl<$Res>
    implements _$$_WordModelCopyWith<$Res> {
  __$$_WordModelCopyWithImpl(
      _$_WordModel _value, $Res Function(_$_WordModel) _then)
      : super(_value, (v) => _then(v as _$_WordModel));

  @override
  _$_WordModel get _value => super._value as _$_WordModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? englishWord = freezed,
    Object? translation = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$_WordModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      englishWord: englishWord == freezed
          ? _value.englishWord
          : englishWord // ignore: cast_nullable_to_non_nullable
              as String,
      translation: translation == freezed
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WordModel extends _WordModel {
  const _$_WordModel(
      {required this.id,
      required this.userId,
      required this.englishWord,
      required this.translation,
      required this.createdAt})
      : super._();

  factory _$_WordModel.fromJson(Map<String, dynamic> json) =>
      _$$_WordModelFromJson(json);

  @override
  final int id;
  @override
  final String userId;
  @override
  final String englishWord;
  @override
  final String translation;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'WordModel(id: $id, userId: $userId, englishWord: $englishWord, translation: $translation, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WordModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality()
                .equals(other.englishWord, englishWord) &&
            const DeepCollectionEquality()
                .equals(other.translation, translation) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(englishWord),
      const DeepCollectionEquality().hash(translation),
      const DeepCollectionEquality().hash(createdAt));

  @JsonKey(ignore: true)
  @override
  _$$_WordModelCopyWith<_$_WordModel> get copyWith =>
      __$$_WordModelCopyWithImpl<_$_WordModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WordModelToJson(
      this,
    );
  }
}

abstract class _WordModel extends WordModel {
  const factory _WordModel(
      {required final int id,
      required final String userId,
      required final String englishWord,
      required final String translation,
      required final DateTime createdAt}) = _$_WordModel;
  const _WordModel._() : super._();

  factory _WordModel.fromJson(Map<String, dynamic> json) =
      _$_WordModel.fromJson;

  @override
  int get id;
  @override
  String get userId;
  @override
  String get englishWord;
  @override
  String get translation;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_WordModelCopyWith<_$_WordModel> get copyWith =>
      throw _privateConstructorUsedError;
}
