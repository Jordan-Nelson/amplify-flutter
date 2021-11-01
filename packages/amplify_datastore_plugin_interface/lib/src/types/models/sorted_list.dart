/*
 * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'dart:collection';

/// An Object that holds a list that maintains a specifc sort order
///
/// methods that modify the list of items will respect the sort order
/// and mutate the list in an efficient manor for sorted lists, generally
/// O(n) time complexity at worst
///
/// if no compare function is provided, the list behaves like an unsorted list
///
/// Note: this is intended for use in observeQuery and is not intended to be
/// part of the public API
class SortedList<E> with ListMixin<E> {
  // Required for ListMixin
  void set length(int newLength) {
    _items.length = newLength;
  }

  // Required for ListMixin
  int get length => _items.length;

  // Required for ListMixin
  E operator [](int index) => _items[index];

  // Required for ListMixin
  void operator []=(int index, E value) {
    _items[index] = value;
  }

  // ListMixin add() only works for lists that accept null
  void add(E value) => _items.add(value);

  // items in the list
  final List<E> _items;

  // comparision function used to maintain list sort
  final int Function(E a, E b)? _compare;

  /// creates a SortedList from a pre-sorted list of items
  ///
  /// This requires that the provided items are sorted according to the
  /// compare function, otherwise the sort order of the list will not be
  /// maintained
  const SortedList.fromPresortedList({
    required List<E> items,
    int Function(E a, E b)? compare,
  })  : _items = items,
        _compare = compare;

  SortedList.from(SortedList<E> list)
      : _items = List.from(list._items),
        _compare = list._compare;

  /// adds a new item to the list, maintaining the sort order
  void addSorted(E item) {
    if (this._compare == null || _items.length == 0) {
      add(item);
      return;
    }
    int insertIndex = _findIndex(item);
    insert(insertIndex, item);
  }

  /// Updates an item in the list, maintaining the sort order
  void updateSorted(E oldItem, E newItem) {
    if (this._compare == null) {
      int index = this.indexOf(oldItem);
      this[index] = newItem;
    } else {
      int index = this._findIndex(oldItem);
      removeAt(index);
      addSorted(newItem);
    }
  }

  /// Finds the index of the given item
  /// if the item is not in the list, the appropriate
  /// index to insert the [item] at will be returned
  ///
  /// O(log(n)) time complexity
  int _findIndex(E item) {
    int low = 0;
    int high = _items.length;

    while (low < high) {
      var mid = (low + high) >> 1;
      if (_compare!(item, _items[mid]) > 0)
        low = mid + 1;
      else
        high = mid;
    }
    return low;
  }
}
