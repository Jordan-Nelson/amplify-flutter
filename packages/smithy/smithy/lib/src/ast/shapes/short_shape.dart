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

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/ast.dart';

part 'short_shape.g.dart';

abstract class ShortShape
    implements SimpleShape, Built<ShortShape, ShortShapeBuilder> {
  factory ShortShape([void Function(ShortShapeBuilder) updates]) = _$ShortShape;
  ShortShape._();

  @BuiltValueHook(initializeBuilder: true)
  static void _init(ShortShapeBuilder b) {
    b.shapeId = id;
    b.traits = TraitMap.fromTraits(const [BoxTrait()]);
  }

  static const id = ShapeId.core('Short');

  @override
  ShapeType getType() => ShapeType.short;

  @override
  R accept<R>(ShapeVisitor<R> visitor, [Shape? parent]) =>
      visitor.shortShape(this, parent);

  static Serializer<ShortShape> get serializer => _$shortShapeSerializer;
}
