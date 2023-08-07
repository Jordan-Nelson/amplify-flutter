// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.dynamo_db.model.replica_update; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i2;
import 'package:smoke_test/src/sdk/src/dynamo_db/model/create_replica_action.dart';
import 'package:smoke_test/src/sdk/src/dynamo_db/model/delete_replica_action.dart';

part 'replica_update.g.dart';

/// Represents one of the following:
///
/// *   A new replica to be added to an existing global table.
///
/// *   New parameters for an existing replica.
///
/// *   An existing replica to be removed from an existing global table.
abstract class ReplicaUpdate
    with _i1.AWSEquatable<ReplicaUpdate>
    implements Built<ReplicaUpdate, ReplicaUpdateBuilder> {
  /// Represents one of the following:
  ///
  /// *   A new replica to be added to an existing global table.
  ///
  /// *   New parameters for an existing replica.
  ///
  /// *   An existing replica to be removed from an existing global table.
  factory ReplicaUpdate({
    CreateReplicaAction? create,
    DeleteReplicaAction? delete,
  }) {
    return _$ReplicaUpdate._(
      create: create,
      delete: delete,
    );
  }

  /// Represents one of the following:
  ///
  /// *   A new replica to be added to an existing global table.
  ///
  /// *   New parameters for an existing replica.
  ///
  /// *   An existing replica to be removed from an existing global table.
  factory ReplicaUpdate.build([void Function(ReplicaUpdateBuilder) updates]) =
      _$ReplicaUpdate;

  const ReplicaUpdate._();

  static const List<_i2.SmithySerializer<ReplicaUpdate>> serializers = [
    ReplicaUpdateAwsJson10Serializer()
  ];

  /// The parameters required for creating a replica on an existing global table.
  CreateReplicaAction? get create;

  /// The name of the existing replica to be removed.
  DeleteReplicaAction? get delete;
  @override
  List<Object?> get props => [
        create,
        delete,
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('ReplicaUpdate')
      ..add(
        'create',
        create,
      )
      ..add(
        'delete',
        delete,
      );
    return helper.toString();
  }
}

class ReplicaUpdateAwsJson10Serializer
    extends _i2.StructuredSmithySerializer<ReplicaUpdate> {
  const ReplicaUpdateAwsJson10Serializer() : super('ReplicaUpdate');

  @override
  Iterable<Type> get types => const [
        ReplicaUpdate,
        _$ReplicaUpdate,
      ];
  @override
  Iterable<_i2.ShapeId> get supportedProtocols => const [
        _i2.ShapeId(
          namespace: 'aws.protocols',
          shape: 'awsJson1_0',
        )
      ];
  @override
  ReplicaUpdate deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReplicaUpdateBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'Create':
          result.create.replace((serializers.deserialize(
            value,
            specifiedType: const FullType(CreateReplicaAction),
          ) as CreateReplicaAction));
        case 'Delete':
          result.delete.replace((serializers.deserialize(
            value,
            specifiedType: const FullType(DeleteReplicaAction),
          ) as DeleteReplicaAction));
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ReplicaUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[];
    final ReplicaUpdate(:create, :delete) = object;
    if (create != null) {
      result$
        ..add('Create')
        ..add(serializers.serialize(
          create,
          specifiedType: const FullType(CreateReplicaAction),
        ));
    }
    if (delete != null) {
      result$
        ..add('Delete')
        ..add(serializers.serialize(
          delete,
          specifiedType: const FullType(DeleteReplicaAction),
        ));
    }
    return result$;
  }
}
