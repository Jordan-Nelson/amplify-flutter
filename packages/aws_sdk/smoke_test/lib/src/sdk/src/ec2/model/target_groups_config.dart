// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.ec2.model.target_groups_config; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i3;
import 'package:smoke_test/src/sdk/src/ec2/model/target_group.dart';

part 'target_groups_config.g.dart';

/// Describes the target groups to attach to a Spot Fleet. Spot Fleet registers the running Spot Instances with these target groups.
abstract class TargetGroupsConfig
    with _i1.AWSEquatable<TargetGroupsConfig>
    implements Built<TargetGroupsConfig, TargetGroupsConfigBuilder> {
  /// Describes the target groups to attach to a Spot Fleet. Spot Fleet registers the running Spot Instances with these target groups.
  factory TargetGroupsConfig({List<TargetGroup>? targetGroups}) {
    return _$TargetGroupsConfig._(
        targetGroups:
            targetGroups == null ? null : _i2.BuiltList(targetGroups));
  }

  /// Describes the target groups to attach to a Spot Fleet. Spot Fleet registers the running Spot Instances with these target groups.
  factory TargetGroupsConfig.build(
          [void Function(TargetGroupsConfigBuilder) updates]) =
      _$TargetGroupsConfig;

  const TargetGroupsConfig._();

  static const List<_i3.SmithySerializer<TargetGroupsConfig>> serializers = [
    TargetGroupsConfigEc2QuerySerializer()
  ];

  /// One or more target groups.
  _i2.BuiltList<TargetGroup>? get targetGroups;
  @override
  List<Object?> get props => [targetGroups];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('TargetGroupsConfig')
      ..add(
        'targetGroups',
        targetGroups,
      );
    return helper.toString();
  }
}

class TargetGroupsConfigEc2QuerySerializer
    extends _i3.StructuredSmithySerializer<TargetGroupsConfig> {
  const TargetGroupsConfigEc2QuerySerializer() : super('TargetGroupsConfig');

  @override
  Iterable<Type> get types => const [
        TargetGroupsConfig,
        _$TargetGroupsConfig,
      ];
  @override
  Iterable<_i3.ShapeId> get supportedProtocols => const [
        _i3.ShapeId(
          namespace: 'aws.protocols',
          shape: 'ec2Query',
        )
      ];
  @override
  TargetGroupsConfig deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TargetGroupsConfigBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'targetGroups':
          result.targetGroups.replace((const _i3.XmlBuiltListSerializer(
            memberName: 'item',
            indexer: _i3.XmlIndexer.ec2QueryList,
          ).deserialize(
            serializers,
            value is String ? const [] : (value as Iterable<Object?>),
            specifiedType: const FullType(
              _i2.BuiltList,
              [FullType(TargetGroup)],
            ),
          ) as _i2.BuiltList<TargetGroup>));
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TargetGroupsConfig object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[
      const _i3.XmlElementName(
        'TargetGroupsConfigResponse',
        _i3.XmlNamespace('http://ec2.amazonaws.com/doc/2016-11-15'),
      )
    ];
    final TargetGroupsConfig(:targetGroups) = object;
    if (targetGroups != null) {
      result$
        ..add(const _i3.XmlElementName('TargetGroups'))
        ..add(const _i3.XmlBuiltListSerializer(
          memberName: 'item',
          indexer: _i3.XmlIndexer.ec2QueryList,
        ).serialize(
          serializers,
          targetGroups,
          specifiedType: const FullType(
            _i2.BuiltList,
            [FullType(TargetGroup)],
          ),
        ));
    }
    return result$;
  }
}
