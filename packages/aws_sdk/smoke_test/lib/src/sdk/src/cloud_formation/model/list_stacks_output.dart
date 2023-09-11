// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.cloud_formation.model.list_stacks_output; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i3;
import 'package:smoke_test/src/sdk/src/cloud_formation/model/stack_summary.dart';

part 'list_stacks_output.g.dart';

/// The output for ListStacks action.
abstract class ListStacksOutput
    with _i1.AWSEquatable<ListStacksOutput>
    implements Built<ListStacksOutput, ListStacksOutputBuilder> {
  /// The output for ListStacks action.
  factory ListStacksOutput({
    List<StackSummary>? stackSummaries,
    String? nextToken,
  }) {
    return _$ListStacksOutput._(
      stackSummaries:
          stackSummaries == null ? null : _i2.BuiltList(stackSummaries),
      nextToken: nextToken,
    );
  }

  /// The output for ListStacks action.
  factory ListStacksOutput.build(
      [void Function(ListStacksOutputBuilder) updates]) = _$ListStacksOutput;

  const ListStacksOutput._();

  /// Constructs a [ListStacksOutput] from a [payload] and [response].
  factory ListStacksOutput.fromResponse(
    ListStacksOutput payload,
    _i1.AWSBaseHttpResponse response,
  ) =>
      payload;

  static const List<_i3.SmithySerializer<ListStacksOutput>> serializers = [
    ListStacksOutputAwsQuerySerializer()
  ];

  /// A list of `StackSummary` structures containing information about the specified stacks.
  _i2.BuiltList<StackSummary>? get stackSummaries;

  /// If the output exceeds 1 MB in size, a string that identifies the next page of stacks. If no additional page exists, this value is null.
  String? get nextToken;
  @override
  List<Object?> get props => [
        stackSummaries,
        nextToken,
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('ListStacksOutput')
      ..add(
        'stackSummaries',
        stackSummaries,
      )
      ..add(
        'nextToken',
        nextToken,
      );
    return helper.toString();
  }
}

class ListStacksOutputAwsQuerySerializer
    extends _i3.StructuredSmithySerializer<ListStacksOutput> {
  const ListStacksOutputAwsQuerySerializer() : super('ListStacksOutput');

  @override
  Iterable<Type> get types => const [
        ListStacksOutput,
        _$ListStacksOutput,
      ];
  @override
  Iterable<_i3.ShapeId> get supportedProtocols => const [
        _i3.ShapeId(
          namespace: 'aws.protocols',
          shape: 'awsQuery',
        )
      ];
  @override
  ListStacksOutput deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListStacksOutputBuilder();
    final responseIterator = serialized.iterator;
    while (responseIterator.moveNext()) {
      final key = responseIterator.current as String;
      responseIterator.moveNext();
      if (key.endsWith('Result')) {
        serialized = responseIterator.current as Iterable;
      }
    }
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'StackSummaries':
          result.stackSummaries.replace((const _i3.XmlBuiltListSerializer(
                  indexer: _i3.XmlIndexer.awsQueryList)
              .deserialize(
            serializers,
            value is String ? const [] : (value as Iterable<Object?>),
            specifiedType: const FullType(
              _i2.BuiltList,
              [FullType(StackSummary)],
            ),
          ) as _i2.BuiltList<StackSummary>));
        case 'NextToken':
          result.nextToken = (serializers.deserialize(
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
    ListStacksOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[
      const _i3.XmlElementName(
        'ListStacksOutputResponse',
        _i3.XmlNamespace('http://cloudformation.amazonaws.com/doc/2010-05-15/'),
      )
    ];
    final ListStacksOutput(:stackSummaries, :nextToken) = object;
    if (stackSummaries != null) {
      result$
        ..add(const _i3.XmlElementName('StackSummaries'))
        ..add(const _i3.XmlBuiltListSerializer(
                indexer: _i3.XmlIndexer.awsQueryList)
            .serialize(
          serializers,
          stackSummaries,
          specifiedType: const FullType(
            _i2.BuiltList,
            [FullType(StackSummary)],
          ),
        ));
    }
    if (nextToken != null) {
      result$
        ..add(const _i3.XmlElementName('NextToken'))
        ..add(serializers.serialize(
          nextToken,
          specifiedType: const FullType(String),
        ));
    }
    return result$;
  }
}
