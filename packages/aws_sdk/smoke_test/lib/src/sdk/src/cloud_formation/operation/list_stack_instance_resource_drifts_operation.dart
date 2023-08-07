// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.cloud_formation.operation.list_stack_instance_resource_drifts_operation; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i5;

import 'package:aws_common/aws_common.dart' as _i4;
import 'package:aws_signature_v4/aws_signature_v4.dart' as _i2;
import 'package:smithy/smithy.dart' as _i1;
import 'package:smithy_aws/smithy_aws.dart' as _i3;
import 'package:smoke_test/src/sdk/src/cloud_formation/common/endpoint_resolver.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/common/serializers.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/model/list_stack_instance_resource_drifts_input.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/model/list_stack_instance_resource_drifts_output.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/model/operation_not_found_exception.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/model/stack_instance_not_found_exception.dart';
import 'package:smoke_test/src/sdk/src/cloud_formation/model/stack_set_not_found_exception.dart';

/// Returns drift information for resources in a stack instance.
///
/// `ListStackInstanceResourceDrifts` returns drift information for the most recent drift detection operation. If an operation is in progress, it may only return partial results.
class ListStackInstanceResourceDriftsOperation extends _i1.HttpOperation<
    ListStackInstanceResourceDriftsInput,
    ListStackInstanceResourceDriftsInput,
    ListStackInstanceResourceDriftsOutput,
    ListStackInstanceResourceDriftsOutput> {
  /// Returns drift information for resources in a stack instance.
  ///
  /// `ListStackInstanceResourceDrifts` returns drift information for the most recent drift detection operation. If an operation is in progress, it may only return partial results.
  ListStackInstanceResourceDriftsOperation({
    required String region,
    Uri? baseUri,
    _i2.AWSCredentialsProvider credentialsProvider =
        const _i2.AWSCredentialsProvider.environment(),
    List<_i1.HttpRequestInterceptor> requestInterceptors = const [],
    List<_i1.HttpResponseInterceptor> responseInterceptors = const [],
  })  : _region = region,
        _baseUri = baseUri,
        _credentialsProvider = credentialsProvider,
        _requestInterceptors = requestInterceptors,
        _responseInterceptors = responseInterceptors;

  @override
  late final List<
      _i1.HttpProtocol<
          ListStackInstanceResourceDriftsInput,
          ListStackInstanceResourceDriftsInput,
          ListStackInstanceResourceDriftsOutput,
          ListStackInstanceResourceDriftsOutput>> protocols = [
    _i3.AwsQueryProtocol(
      serializers: serializers,
      builderFactories: builderFactories,
      requestInterceptors: <_i1.HttpRequestInterceptor>[
            const _i1.WithHost(),
            const _i1.WithContentLength(),
            _i3.WithSigV4(
              region: _region,
              service: _i4.AWSService.cloudFormation,
              credentialsProvider: _credentialsProvider,
            ),
            const _i1.WithUserAgent('aws-sdk-dart/0.3.1'),
            const _i3.WithSdkInvocationId(),
            const _i3.WithSdkRequest(),
          ] +
          _requestInterceptors,
      responseInterceptors:
          <_i1.HttpResponseInterceptor>[] + _responseInterceptors,
      action: 'ListStackInstanceResourceDrifts',
      version: '2010-05-15',
      awsQueryErrors: const [
        _i3.AwsQueryError(
          shape: 'OperationNotFoundException',
          code: 'OperationNotFoundException',
          httpResponseCode: 404,
        ),
        _i3.AwsQueryError(
          shape: 'StackInstanceNotFoundException',
          code: 'StackInstanceNotFoundException',
          httpResponseCode: 404,
        ),
        _i3.AwsQueryError(
          shape: 'StackSetNotFoundException',
          code: 'StackSetNotFoundException',
          httpResponseCode: 404,
        ),
      ],
    )
  ];

  late final _i3.AWSEndpoint _awsEndpoint = endpointResolver.resolve(
    sdkId,
    _region,
  );

  final String _region;

  final Uri? _baseUri;

  final _i2.AWSCredentialsProvider _credentialsProvider;

  final List<_i1.HttpRequestInterceptor> _requestInterceptors;

  final List<_i1.HttpResponseInterceptor> _responseInterceptors;

  @override
  _i1.HttpRequest buildRequest(ListStackInstanceResourceDriftsInput input) =>
      _i1.HttpRequest((b) {
        b.method = 'POST';
        b.path = r'/';
      });
  @override
  int successCode([ListStackInstanceResourceDriftsOutput? output]) => 200;
  @override
  ListStackInstanceResourceDriftsOutput buildOutput(
    ListStackInstanceResourceDriftsOutput payload,
    _i4.AWSBaseHttpResponse response,
  ) =>
      ListStackInstanceResourceDriftsOutput.fromResponse(
        payload,
        response,
      );
  @override
  List<_i1.SmithyError> get errorTypes => const [
        _i1.SmithyError<OperationNotFoundException, OperationNotFoundException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.cloudformation',
            shape: 'OperationNotFoundException',
          ),
          _i1.ErrorKind.client,
          OperationNotFoundException,
          statusCode: 404,
          builder: OperationNotFoundException.fromResponse,
        ),
        _i1.SmithyError<StackInstanceNotFoundException,
            StackInstanceNotFoundException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.cloudformation',
            shape: 'StackInstanceNotFoundException',
          ),
          _i1.ErrorKind.client,
          StackInstanceNotFoundException,
          statusCode: 404,
          builder: StackInstanceNotFoundException.fromResponse,
        ),
        _i1.SmithyError<StackSetNotFoundException, StackSetNotFoundException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.cloudformation',
            shape: 'StackSetNotFoundException',
          ),
          _i1.ErrorKind.client,
          StackSetNotFoundException,
          statusCode: 404,
          builder: StackSetNotFoundException.fromResponse,
        ),
      ];
  @override
  String get runtimeTypeName => 'ListStackInstanceResourceDrifts';
  @override
  _i3.AWSRetryer get retryer => _i3.AWSRetryer();
  @override
  Uri get baseUri => _baseUri ?? endpoint.uri;
  @override
  _i1.Endpoint get endpoint => _awsEndpoint.endpoint;
  @override
  _i1.SmithyOperation<ListStackInstanceResourceDriftsOutput> run(
    ListStackInstanceResourceDriftsInput input, {
    _i4.AWSHttpClient? client,
    _i1.ShapeId? useProtocol,
  }) {
    return _i5.runZoned(
      () => super.run(
        input,
        client: client,
        useProtocol: useProtocol,
      ),
      zoneValues: {
        ...?_awsEndpoint.credentialScope?.zoneValues,
        ...{_i4.AWSHeaders.sdkInvocationId: _i4.uuid(secure: true)},
      },
    );
  }
}
