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

import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart' as pkg_file;
import 'package:file/local.dart' as local_file;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// {@template amplify_secure_storage_dart.file_key_value_store}
/// A Key-Value Store that stores data in the provided file.
/// {@endtemplate}
@internal
class FileKeyValueStore {
  /// {@macro amplify_secure_storage_dart.file_key_value_store}
  FileKeyValueStore({required this.directory, required this.fileName});

  /// The directory of the file.
  final String directory;

  /// The name of the file.
  ///
  /// The file will be created if it does not yet exist.
  final String fileName;

  late final File file = fs.file(
    path.join(
      directory,
      fileName,
    ),
  );

  pkg_file.FileSystem fs = const local_file.LocalFileSystem();

  /// Writes a single key to storage.
  Future<void> writeKey({
    required String key,
    required Object value,
  }) async {
    final data = await readAll();
    data[key] = value;
    return writeAll(data);
  }

  /// Overwrites the existing data.
  Future<void> writeAll(
    Map<String, Object> data,
  ) async {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final stringMap = json.encode(data);
    file.writeAsStringSync(stringMap);
  }

  /// Reads a single key from storage.
  Future<Object?> readKey({
    required String key,
  }) async {
    final data = await readAll();
    return data[key];
  }

  /// Returns true if the key exists in storage
  Future<bool> containsKey({
    required String key,
  }) async {
    final data = await readAll();
    return data.containsKey(key);
  }

  /// Reads all the key-value pairs from storage.
  Future<Map<String, Object>> readAll() async {
    if (file.existsSync()) {
      final stringMap = file.readAsStringSync();
      if (stringMap.isNotEmpty) {
        final Object? data = json.decode(stringMap);
        if (data is Map) {
          return data.cast<String, Object>();
        }
      }
    }
    return <String, Object>{};
  }
}
