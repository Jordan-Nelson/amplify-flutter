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

/// {@template amplify_secure_storage_dart.ios_secure_storage_options}
/// Configuration options that are specific to iOS.
/// {@endtemplate}
class IOSSecureStorageOptions {
  /// {@macro amplify_secure_storage_dart.ios_secure_storage_options}
  const IOSSecureStorageOptions({
    this.accessGroup,
  });

  /// The default options for iOS.
  static const defaultOptions = IOSSecureStorageOptions();

  /// Sets the `kSecAttrAccessGroup` attribute for all Keychain operations.
  ///
  /// Reference: [kSecAttrAccessGroup](https://developer.apple.com/documentation/security/ksecattraccessgroup?language=objc)
  final String? accessGroup;
}
