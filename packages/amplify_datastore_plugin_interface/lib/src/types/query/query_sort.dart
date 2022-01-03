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

part of 'query_field.dart';

enum QuerySortOrder { ascending, descending }

extension QuerySortOrderExtension on QuerySortOrder {
  String toShortString() {
    return this
        .toString()
        .split('.')
        .last; // toString returns the enumName.value
  }
}

/// Represents a model field and an order to sort by (ascending or descending),
/// used to specify the order of results from a query operation
class QuerySortBy<M extends Model, V> {
  final QuerySortOrder order;
  final String field;
  final V Function(M) getValue;

  const QuerySortBy({
    required this.order,
    required this.field,
    required this.getValue,
  });

  int compare(M a, M b) {
    final V valueA = getValue(a);
    final V valueB = getValue(b);
    int orderMultiplier = order == QuerySortOrder.ascending ? 1 : -1;
    if (valueA == null || valueB == null) {
      return orderMultiplier * _compareNull(valueA, valueB);
    } else if (valueA is bool && valueB is bool) {
      return orderMultiplier * _compareBool(valueA, valueB);
    } else if (valueA is Comparable && valueB is Comparable) {
      return orderMultiplier * valueA.compareTo(valueB);
    }
    throw DataStoreException(
        'A non-comparable field was used as a QuerySortBy');
  }

  int _compareBool(bool a, bool b) {
    if (a == b) return 0;
    return a ? 1 : -1;
  }

  int _compareNull(Object? a, Object? b) {
    if (a == b) return 0;
    return a != null ? 1 : -1;
  }

  Map<String, dynamic> serializeAsMap() {
    return <String, dynamic>{'field': field, 'order': order.toShortString()};
  }
}
