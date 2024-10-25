part of 'extensions.dart';

extension ListExtension<E, Id> on List<E> {
  bool containsAll(Iterable<E> iterable) {
    for (var element in iterable) {
      if (!contains(element)) return false;
    }
    return true;
  }

  bool containsOne(Iterable<E> iterable) {
    for (var element in iterable) {
      if (contains(element)) return true;
    }
    return false;
  }

  void removeAll(Iterable<E> iterable) {
    for (var element in iterable) {
      remove(element);
    }
  }

  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }

  List<E> copyWith(List<E> value) => this + value;

  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
