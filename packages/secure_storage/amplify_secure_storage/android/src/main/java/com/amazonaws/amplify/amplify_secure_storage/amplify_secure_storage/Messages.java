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
// Autogenerated from Pigeon (v3.1.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.amazonaws.amplify.amplify_secure_storage.amplify_secure_storage;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Messages {
  private static class AmplifySecureStorageApiCodec extends StandardMessageCodec {
    public static final AmplifySecureStorageApiCodec INSTANCE = new AmplifySecureStorageApiCodec();
    private AmplifySecureStorageApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface AmplifySecureStorageApi {
    @Nullable String read(@NonNull String scope, @NonNull String key);
    void write(@NonNull String scope, @NonNull String key, @Nullable String value);
    void delete(@NonNull String scope, @NonNull String key);

    /** The codec used by AmplifySecureStorageApi. */
    static MessageCodec<Object> getCodec() {
      return AmplifySecureStorageApiCodec.INSTANCE;
    }

    /** Sets up an instance of `AmplifySecureStorageApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, AmplifySecureStorageApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.AmplifySecureStorageApi.read", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String scopeArg = (String)args.get(0);
              if (scopeArg == null) {
                throw new NullPointerException("scopeArg unexpectedly null.");
              }
              String keyArg = (String)args.get(1);
              if (keyArg == null) {
                throw new NullPointerException("keyArg unexpectedly null.");
              }
              String output = api.read(scopeArg, keyArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.AmplifySecureStorageApi.write", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String scopeArg = (String)args.get(0);
              if (scopeArg == null) {
                throw new NullPointerException("scopeArg unexpectedly null.");
              }
              String keyArg = (String)args.get(1);
              if (keyArg == null) {
                throw new NullPointerException("keyArg unexpectedly null.");
              }
              String valueArg = (String)args.get(2);
              api.write(scopeArg, keyArg, valueArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.AmplifySecureStorageApi.delete", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String scopeArg = (String)args.get(0);
              if (scopeArg == null) {
                throw new NullPointerException("scopeArg unexpectedly null.");
              }
              String keyArg = (String)args.get(1);
              if (keyArg == null) {
                throw new NullPointerException("keyArg unexpectedly null.");
              }
              api.delete(scopeArg, keyArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
