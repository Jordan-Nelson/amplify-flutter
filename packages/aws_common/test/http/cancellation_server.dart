// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http2/http2.dart';
import 'package:stream_channel/stream_channel.dart';

import 'http_server.dart';

/// Pauses at one of a predetermined set of locations so that the client can
/// cancel the request.
Future<void> hybridMain(StreamChannel<Object?> channel) =>
    clientHybridMain(channel, _handleH1, _handleH2);

Future<void> _handleH1(
  StreamChannel<Object?> channel,
  HttpRequest request,
  int port,
) async {
  final path = request.uri.pathSegments.singleOrNull ?? '';
  if (path.isEmpty) {
    request.response.contentLength = 0;
    return request.response.close();
  }
  if (path == 'headers') {
    return channel.sink.done;
  }
  if (path == 'body') {
    request.response
      ..contentLength = -1
      ..add([1, 2, 3, 4, 5]);
    return channel.sink.done;
  }
}

Future<void> _handleH2(
  StreamChannel<Object?> channel,
  ServerTransportStream request,
  Stream<List<int>> body,
  Map<String, String> headers,
  int port,
) async {
  final path = Uri.parse(headers[':path']!).pathSegments.singleOrNull ?? '';
  if (path.isEmpty) {
    return request.sendHeaders(
      [Header.ascii(':status', '200')],
      endStream: true,
    );
  }
  if (path == 'headers') {
    return channel.sink.done;
  }
  if (path == 'body') {
    request
      ..sendHeaders([Header.ascii(':status', '200')])
      ..sendData([1, 2, 3, 4, 5]);
    return channel.sink.done;
  }
}
