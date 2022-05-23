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

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'keychain.bindings.g.dart';

export 'keychain.bindings.g.dart' hide Keychain;

final DynamicLibrary _dynamicLibrary = DynamicLibrary.executable();

final Keychain keychain = Keychain(_dynamicLibrary);

extension CFDataRefX on Pointer<CFData> {
  /// Converts a [CFDataRef] to a Dart String.
  String? toDartString() {
    if (this == nullptr) return null;
    final bytePtr = keychain.CFDataGetBytePtr(this);
    if (bytePtr == nullptr) return null;
    return bytePtr.cast<Utf8>().toDartString();
  }
}

extension CFStringPointerX on Pointer<CFString> {
  /// Converts a [CFStringRef] to a Dart String.
  String? toDartString() {
    if (this == nullptr) return null;
    final cStringPtr = keychain.CFStringGetCStringPtr(
      this,
      kCFStringEncodingUTF8,
    );
    if (cStringPtr == nullptr) return null;
    return cStringPtr.cast<Utf8>().toDartString();
  }
}
