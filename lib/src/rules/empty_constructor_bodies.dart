// Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../analyzer.dart';

const _desc = r'Use `;` instead of `{}` for empty constructor bodies.';

const _details = r'''
From the [style guide](https://dart.dev/guides/language/effective-dart/style/):

**DO** use `;` instead of `{}` for empty constructor bodies.

In Dart, a constructor with an empty body can be terminated with just a
semicolon.  This is required for const constructors.  For consistency and
brevity, other constructors should also do this.

**BAD:**
```dart
class Point {
  int x, y;
  Point(this.x, this.y) {}
}
```

**GOOD:**
```dart
class Point {
  int x, y;
  Point(this.x, this.y);
}
```

''';

class EmptyConstructorBodies extends LintRule {
  static const LintCode code = LintCode('empty_constructor_bodies',
      "Empty constructor bodies should be written using a ';' rather than '{}'.",
      correctionMessage: "Try replacing the constructor body with ';'.");

  EmptyConstructorBodies()
      : super(
            name: 'empty_constructor_bodies',
            description: _desc,
            details: _details,
            group: Group.style);

  @override
  LintCode get lintCode => code;

  @override
  void registerNodeProcessors(
      NodeLintRegistry registry, LinterContext context) {
    var visitor = _Visitor(this);
    registry.addConstructorDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final LintRule rule;

  _Visitor(this.rule);

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    var body = node.body;
    if (body is BlockFunctionBody) {
      var block = body.block;
      if (block.statements.isEmpty) {
        if (block.endToken.precedingComments == null) {
          rule.reportLint(block);
        }
      }
    }
  }
}
