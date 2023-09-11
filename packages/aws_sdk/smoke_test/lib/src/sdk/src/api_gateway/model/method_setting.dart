// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.api_gateway.model.method_setting; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i2;
import 'package:smoke_test/src/sdk/src/api_gateway/model/unauthorized_cache_control_header_strategy.dart';

part 'method_setting.g.dart';

/// Specifies the method setting properties.
abstract class MethodSetting
    with _i1.AWSEquatable<MethodSetting>
    implements Built<MethodSetting, MethodSettingBuilder> {
  /// Specifies the method setting properties.
  factory MethodSetting({
    bool? metricsEnabled,
    String? loggingLevel,
    bool? dataTraceEnabled,
    int? throttlingBurstLimit,
    double? throttlingRateLimit,
    bool? cachingEnabled,
    int? cacheTtlInSeconds,
    bool? cacheDataEncrypted,
    bool? requireAuthorizationForCacheControl,
    UnauthorizedCacheControlHeaderStrategy?
        unauthorizedCacheControlHeaderStrategy,
  }) {
    metricsEnabled ??= false;
    dataTraceEnabled ??= false;
    throttlingBurstLimit ??= 0;
    throttlingRateLimit ??= 0;
    cachingEnabled ??= false;
    cacheTtlInSeconds ??= 0;
    cacheDataEncrypted ??= false;
    requireAuthorizationForCacheControl ??= false;
    return _$MethodSetting._(
      metricsEnabled: metricsEnabled,
      loggingLevel: loggingLevel,
      dataTraceEnabled: dataTraceEnabled,
      throttlingBurstLimit: throttlingBurstLimit,
      throttlingRateLimit: throttlingRateLimit,
      cachingEnabled: cachingEnabled,
      cacheTtlInSeconds: cacheTtlInSeconds,
      cacheDataEncrypted: cacheDataEncrypted,
      requireAuthorizationForCacheControl: requireAuthorizationForCacheControl,
      unauthorizedCacheControlHeaderStrategy:
          unauthorizedCacheControlHeaderStrategy,
    );
  }

  /// Specifies the method setting properties.
  factory MethodSetting.build([void Function(MethodSettingBuilder) updates]) =
      _$MethodSetting;

  const MethodSetting._();

  static const List<_i2.SmithySerializer<MethodSetting>> serializers = [
    MethodSettingRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(MethodSettingBuilder b) {
    b
      ..metricsEnabled = false
      ..dataTraceEnabled = false
      ..throttlingBurstLimit = 0
      ..throttlingRateLimit = 0
      ..cachingEnabled = false
      ..cacheTtlInSeconds = 0
      ..cacheDataEncrypted = false
      ..requireAuthorizationForCacheControl = false;
  }

  /// Specifies whether Amazon CloudWatch metrics are enabled for this method.
  bool get metricsEnabled;

  /// Specifies the logging level for this method, which affects the log entries pushed to Amazon CloudWatch Logs. Valid values are `OFF`, `ERROR`, and `INFO`. Choose `ERROR` to write only error-level entries to CloudWatch Logs, or choose `INFO` to include all `ERROR` events as well as extra informational events.
  String? get loggingLevel;

  /// Specifies whether data trace logging is enabled for this method, which affects the log entries pushed to Amazon CloudWatch Logs.
  bool get dataTraceEnabled;

  /// Specifies the throttling burst limit.
  int get throttlingBurstLimit;

  /// Specifies the throttling rate limit.
  double get throttlingRateLimit;

  /// Specifies whether responses should be cached and returned for requests. A cache cluster must be enabled on the stage for responses to be cached.
  bool get cachingEnabled;

  /// Specifies the time to live (TTL), in seconds, for cached responses. The higher the TTL, the longer the response will be cached.
  int get cacheTtlInSeconds;

  /// Specifies whether the cached responses are encrypted.
  bool get cacheDataEncrypted;

  /// Specifies whether authorization is required for a cache invalidation request.
  bool get requireAuthorizationForCacheControl;

  /// Specifies how to handle unauthorized requests for cache invalidation.
  UnauthorizedCacheControlHeaderStrategy?
      get unauthorizedCacheControlHeaderStrategy;
  @override
  List<Object?> get props => [
        metricsEnabled,
        loggingLevel,
        dataTraceEnabled,
        throttlingBurstLimit,
        throttlingRateLimit,
        cachingEnabled,
        cacheTtlInSeconds,
        cacheDataEncrypted,
        requireAuthorizationForCacheControl,
        unauthorizedCacheControlHeaderStrategy,
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('MethodSetting')
      ..add(
        'metricsEnabled',
        metricsEnabled,
      )
      ..add(
        'loggingLevel',
        loggingLevel,
      )
      ..add(
        'dataTraceEnabled',
        dataTraceEnabled,
      )
      ..add(
        'throttlingBurstLimit',
        throttlingBurstLimit,
      )
      ..add(
        'throttlingRateLimit',
        throttlingRateLimit,
      )
      ..add(
        'cachingEnabled',
        cachingEnabled,
      )
      ..add(
        'cacheTtlInSeconds',
        cacheTtlInSeconds,
      )
      ..add(
        'cacheDataEncrypted',
        cacheDataEncrypted,
      )
      ..add(
        'requireAuthorizationForCacheControl',
        requireAuthorizationForCacheControl,
      )
      ..add(
        'unauthorizedCacheControlHeaderStrategy',
        unauthorizedCacheControlHeaderStrategy,
      );
    return helper.toString();
  }
}

class MethodSettingRestJson1Serializer
    extends _i2.StructuredSmithySerializer<MethodSetting> {
  const MethodSettingRestJson1Serializer() : super('MethodSetting');

  @override
  Iterable<Type> get types => const [
        MethodSetting,
        _$MethodSetting,
      ];
  @override
  Iterable<_i2.ShapeId> get supportedProtocols => const [
        _i2.ShapeId(
          namespace: 'aws.protocols',
          shape: 'restJson1',
        )
      ];
  @override
  MethodSetting deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MethodSettingBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'cacheDataEncrypted':
          result.cacheDataEncrypted = (serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool);
        case 'cacheTtlInSeconds':
          result.cacheTtlInSeconds = (serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int);
        case 'cachingEnabled':
          result.cachingEnabled = (serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool);
        case 'dataTraceEnabled':
          result.dataTraceEnabled = (serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool);
        case 'loggingLevel':
          result.loggingLevel = (serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String);
        case 'metricsEnabled':
          result.metricsEnabled = (serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool);
        case 'requireAuthorizationForCacheControl':
          result.requireAuthorizationForCacheControl = (serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool);
        case 'throttlingBurstLimit':
          result.throttlingBurstLimit = (serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int);
        case 'throttlingRateLimit':
          result.throttlingRateLimit = (serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double);
        case 'unauthorizedCacheControlHeaderStrategy':
          result.unauthorizedCacheControlHeaderStrategy =
              (serializers.deserialize(
            value,
            specifiedType:
                const FullType(UnauthorizedCacheControlHeaderStrategy),
          ) as UnauthorizedCacheControlHeaderStrategy);
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    MethodSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[];
    final MethodSetting(
      :cacheDataEncrypted,
      :cacheTtlInSeconds,
      :cachingEnabled,
      :dataTraceEnabled,
      :loggingLevel,
      :metricsEnabled,
      :requireAuthorizationForCacheControl,
      :throttlingBurstLimit,
      :throttlingRateLimit,
      :unauthorizedCacheControlHeaderStrategy
    ) = object;
    result$.addAll([
      'cacheDataEncrypted',
      serializers.serialize(
        cacheDataEncrypted,
        specifiedType: const FullType(bool),
      ),
      'cacheTtlInSeconds',
      serializers.serialize(
        cacheTtlInSeconds,
        specifiedType: const FullType(int),
      ),
      'cachingEnabled',
      serializers.serialize(
        cachingEnabled,
        specifiedType: const FullType(bool),
      ),
      'dataTraceEnabled',
      serializers.serialize(
        dataTraceEnabled,
        specifiedType: const FullType(bool),
      ),
      'metricsEnabled',
      serializers.serialize(
        metricsEnabled,
        specifiedType: const FullType(bool),
      ),
      'requireAuthorizationForCacheControl',
      serializers.serialize(
        requireAuthorizationForCacheControl,
        specifiedType: const FullType(bool),
      ),
      'throttlingBurstLimit',
      serializers.serialize(
        throttlingBurstLimit,
        specifiedType: const FullType(int),
      ),
      'throttlingRateLimit',
      serializers.serialize(
        throttlingRateLimit,
        specifiedType: const FullType(double),
      ),
    ]);
    if (loggingLevel != null) {
      result$
        ..add('loggingLevel')
        ..add(serializers.serialize(
          loggingLevel,
          specifiedType: const FullType(String),
        ));
    }
    if (unauthorizedCacheControlHeaderStrategy != null) {
      result$
        ..add('unauthorizedCacheControlHeaderStrategy')
        ..add(serializers.serialize(
          unauthorizedCacheControlHeaderStrategy,
          specifiedType: const FullType(UnauthorizedCacheControlHeaderStrategy),
        ));
    }
    return result$;
  }
}
