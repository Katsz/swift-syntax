//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

/// Abstractly represents a source location in the macro.
public struct AbstractSourceLocation {
  /// A primary expression that represents the file and is `ExpressibleByStringLiteral`.
  public let file: ExprSyntax

  /// A primary expression that represents the line and is `ExpressibleByIntegerLiteral`.
  public let line: ExprSyntax

  /// A primary expression that represents the column and is `ExpressibleByIntegerLiteral`.
  public let column: ExprSyntax
}
