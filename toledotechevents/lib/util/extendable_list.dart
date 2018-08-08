import 'dart:collection';

class ExtendableList<T> extends ListBase<T> {
  ExtendableList([int length]) : _list = List<T>(length);
  ExtendableList.from(Iterable elements, {bool growable: true})
      : _list = List.from(elements, growable: growable);
  ExtendableList.filled(int length, T fill, {bool growable: false})
      : _list = List.filled(length, fill, growable: growable);
  ExtendableList.generate(int length, T Function(int) generator,
      {bool growable: true})
      : _list = List.generate(length, generator, growable: growable);
  ExtendableList.of(Iterable<T> elements, {bool growable: true})
      : _list = List.of(elements, growable: growable);
  ExtendableList.unmodifiable(Iterable elements)
      : _list = List.unmodifiable(elements);

  final List<T> _list;

  @override
  int get length => _list.length;

  @override
  void set length(int value) => _list.length = value;

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) => _list[index] = value;

  @override
  void add(T value) => _list.add(value);

  @override
  void addAll(Iterable<T> iterable) => _list.addAll(iterable);
}
