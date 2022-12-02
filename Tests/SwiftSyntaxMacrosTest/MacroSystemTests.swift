//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@_spi(Testing) import _SwiftSyntaxMacros
import _SwiftSyntaxTestSupport

final class MacroSystemTests: XCTestCase {
  func testExpressionExpansion() {
    let sf: SourceFileSyntax =
      """
      let b = #stringify(x + y)
      #colorLiteral(red: 0.5, green: 0.5, blue: 0.25, alpha: 1.0)
      """
    let context = MacroEvaluationContext(
      moduleName: "MyModule", fileName: "test.swift"
    )
    let transformedSF = MacroSystem.exampleSystem.evaluateMacros(
      node: sf, in: context, errorHandler: { error in }
    )
    AssertStringsEqualWithDiff(
      transformedSF.description,
      """
      let b = (x + y, "x + y")
      .init(_colorLiteralRed: 0.5, green: 0.5, blue: 0.25, alpha: 1.0)
      """
    )
  }

  func testStringifyExpression() {
    let sf: SourceFileSyntax =
      """
      _ = #stringify({ () -> Bool in
        print("hello")
        return true
      })
      """
    let context = MacroEvaluationContext(
      moduleName: "MyModule", fileName: "test.swift"
    )
    let transformedSF = MacroSystem.exampleSystem.evaluateMacros(
      node: sf, in: context, errorHandler: { error in }
    )
    AssertStringsEqualWithDiff(
      transformedSF.description,
      """
      _ = ({ () -> Bool in
        print("hello")
        return true
      }, #"{ () -> Bool in\\#n  print("hello")\\#n  return true\\#n}"#)
      """
    )
  }

  func testPoundFunctionExpansion() {
    let sf: SourceFileSyntax =
      """
      func f(a: Int, _: Double, c: Int) {
        print(#function)
      }

      struct X {
        var computed: String {
          get {
            #function
          }
        }

        init(from: String) {
          #function
        }

        subscript(a: Int) -> String {
          #function
        }

        subscript(a a: Int) -> String {
          #function
        }
      }

      extension A {
        static var staticProp: String = #function
      }
      """
    let context = MacroEvaluationContext(
      moduleName: "MyModule", fileName: "test.swift"
    )
    let transformedSF = MacroSystem.exampleSystem.evaluateMacros(
      node: sf, in: context, errorHandler: { error in }
    )
    AssertStringsEqualWithDiff(
      transformedSF.description,
      """
      func f(a: Int, _: Double, c: Int) {
        print("f(a:_:c:)")
      }

      struct X {
        var computed: String {
          get {
            "computed"
          }
        }

        init(from: String) {
          "init(from:)"
        }

        subscript(a: Int) -> String {
          "subscript(_:)"
        }

        subscript(a a: Int) -> String {
          "subscript(a:)"
        }
      }

      extension A {
        static var staticProp: String = "A"
      }
      """
    )
  }

  func testFileExpansions() {
    let sf: SourceFileSyntax =
      """
      let b = #fileID
      """
    let context = MacroEvaluationContext(
      moduleName: "MyModule", fileName: "taylor.swift"
    )
    let transformedSF = MacroSystem.exampleSystem.evaluateMacros(
      node: sf, in: context, errorHandler: { error in }
    )
    AssertStringsEqualWithDiff(
      transformedSF.description,
      """
      let b = "MyModule/taylor.swift"
      """
    )
  }
}
