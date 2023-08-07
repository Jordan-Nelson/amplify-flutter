// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library rest_xml_v2.rest_xml_protocol.operation.flattened_xml_map_with_xml_name_operation; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i4;

import 'package:aws_common/aws_common.dart' as _i3;
import 'package:rest_xml_v2/src/rest_xml_protocol/common/endpoint_resolver.dart';
import 'package:rest_xml_v2/src/rest_xml_protocol/common/serializers.dart';
import 'package:rest_xml_v2/src/rest_xml_protocol/model/flattened_xml_map_with_xml_name_input_output.dart';
import 'package:smithy/smithy.dart' as _i1;
import 'package:smithy_aws/smithy_aws.dart' as _i2;

/// Flattened maps with @xmlName
class FlattenedXmlMapWithXmlNameOperation extends _i1.HttpOperation<
    FlattenedXmlMapWithXmlNameInputOutput,
    FlattenedXmlMapWithXmlNameInputOutput,
    FlattenedXmlMapWithXmlNameInputOutput,
    FlattenedXmlMapWithXmlNameInputOutput> {
  /// Flattened maps with @xmlName
  FlattenedXmlMapWithXmlNameOperation({
    required String region,
    Uri? baseUri,
    List<_i1.HttpRequestInterceptor> requestInterceptors = const [],
    List<_i1.HttpResponseInterceptor> responseInterceptors = const [],
  })  : _region = region,
        _baseUri = baseUri,
        _requestInterceptors = requestInterceptors,
        _responseInterceptors = responseInterceptors;

  @override
  late final List<
      _i1.HttpProtocol<
          FlattenedXmlMapWithXmlNameInputOutput,
          FlattenedXmlMapWithXmlNameInputOutput,
          FlattenedXmlMapWithXmlNameInputOutput,
          FlattenedXmlMapWithXmlNameInputOutput>> protocols = [
    _i2.RestXmlProtocol(
      serializers: serializers,
      builderFactories: builderFactories,
      requestInterceptors: <_i1.HttpRequestInterceptor>[
            const _i1.WithHost(),
            const _i1.WithContentLength(),
            const _i1.WithUserAgent('aws-sdk-dart/0.3.1'),
            const _i2.WithSdkInvocationId(),
            const _i2.WithSdkRequest(),
          ] +
          _requestInterceptors,
      responseInterceptors:
          <_i1.HttpResponseInterceptor>[] + _responseInterceptors,
      noErrorWrapping: false,
    )
  ];

  late final _i2.AWSEndpoint _awsEndpoint = endpointResolver.resolve(
    sdkId,
    _region,
  );

  final String _region;

  final Uri? _baseUri;

  final List<_i1.HttpRequestInterceptor> _requestInterceptors;

  final List<_i1.HttpResponseInterceptor> _responseInterceptors;

  @override
  _i1.HttpRequest buildRequest(FlattenedXmlMapWithXmlNameInputOutput input) =>
      _i1.HttpRequest((b) {
        b.method = 'POST';
        b.path = r'/FlattenedXmlMapWithXmlName';
      });
  @override
  int successCode([FlattenedXmlMapWithXmlNameInputOutput? output]) => 200;
  @override
  FlattenedXmlMapWithXmlNameInputOutput buildOutput(
    FlattenedXmlMapWithXmlNameInputOutput payload,
    _i3.AWSBaseHttpResponse response,
  ) =>
      FlattenedXmlMapWithXmlNameInputOutput.fromResponse(
        payload,
        response,
      );
  @override
  List<_i1.SmithyError> get errorTypes => const [];
  @override
  String get runtimeTypeName => 'FlattenedXmlMapWithXmlName';
  @override
  _i2.AWSRetryer get retryer => _i2.AWSRetryer();
  @override
  Uri get baseUri => _baseUri ?? endpoint.uri;
  @override
  _i1.Endpoint get endpoint => _awsEndpoint.endpoint;
  @override
  _i1.SmithyOperation<FlattenedXmlMapWithXmlNameInputOutput> run(
    FlattenedXmlMapWithXmlNameInputOutput input, {
    _i3.AWSHttpClient? client,
    _i1.ShapeId? useProtocol,
  }) {
    return _i4.runZoned(
      () => super.run(
        input,
        client: client,
        useProtocol: useProtocol,
      ),
      zoneValues: {
        ...?_awsEndpoint.credentialScope?.zoneValues,
        ...{_i3.AWSHeaders.sdkInvocationId: _i3.uuid(secure: true)},
      },
    );
  }
}
