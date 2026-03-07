import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_query.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String newValue) => state = newValue;
}
