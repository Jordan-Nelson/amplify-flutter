// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.api_gateway.model.base_path_mappings; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i3;
import 'package:smoke_test/src/sdk/src/api_gateway/model/base_path_mapping.dart';

part 'base_path_mappings.g.dart';

/// Represents a collection of BasePathMapping resources.
abstract class BasePathMappings
    with _i1.AWSEquatable<BasePathMappings>
    implements Built<BasePathMappings, BasePathMappingsBuilder> {
  /// Represents a collection of BasePathMapping resources.
  factory BasePathMappings({
    List<BasePathMapping>? items,
    String? position,
  }) {
    return _$BasePathMappings._(
      items: items == null ? null : _i2.BuiltList(items),
      position: position,
    );
  }

  /// Represents a collection of BasePathMapping resources.
  factory BasePathMappings.build(
      [void Function(BasePathMappingsBuilder) updates]) = _$BasePathMappings;

  const BasePathMappings._();

  /// Constructs a [BasePathMappings] from a [payload] and [response].
  factory BasePathMappings.fromResponse(
    BasePathMappings payload,
    _i1.AWSBaseHttpResponse response,
  ) =>
      payload;

  static const List<_i3.SmithySerializer<BasePathMappings>> serializers = [
    BasePathMappingsRestJson1Serializer()
  ];

  /// The current page of elements from this collection.
  _i2.BuiltList<BasePathMapping>? get items;

  /// The current pagination position in the paged result set.
  String? get position;
  @override
  List<Object?> get props => [
        items,
        position,
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('BasePathMappings')
      ..add(
        'items',
        items,
      )
      ..add(
        'position',
        position,
      );
    return helper.toString();
  }
}

class BasePathMappingsRestJson1Serializer
    extends _i3.StructuredSmithySerializer<BasePathMappings> {
  const BasePathMappingsRestJson1Serializer() : super('BasePathMappings');

  @override
  Iterable<Type> get types => const [
        BasePathMappings,
        _$BasePathMappings,
      ];
  @override
  Iterable<_i3.ShapeId> get supportedProtocols => const [
        _i3.ShapeId(
          namespace: 'aws.protocols',
          shape: 'restJson1',
        )
      ];
  @override
  BasePathMappings deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BasePathMappingsBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'item':
          result.items.replace((serializers.deserialize(
            value,
            specifiedType: const FullType(
              _i2.BuiltList,
              [FullType(BasePathMapping)],
            ),
          ) as _i2.BuiltList<BasePathMapping>));
        case 'position':
          result.position = (serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String);
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    BasePathMappings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[];
    final BasePathMappings(:items, :position) = object;
    if (items != null) {
      result$
        ..add('item')
        ..add(serializers.serialize(
          items,
          specifiedType: const FullType(
            _i2.BuiltList,
            [FullType(BasePathMapping)],
          ),
        ));
    }
    if (position != null) {
      result$
        ..add('position')
        ..add(serializers.serialize(
          position,
          specifiedType: const FullType(String),
        ));
    }
    return result$;
  }
}
