//
//  XCTestCaseExtensions.swift
//  Sequencer
//
//  Copyright © 2024 Josh Robbins
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Combine
import Foundation
import XCTest

extension XCTestCase {

  /// A helper function to assert that two values are equal.
  /// - Parameters:
  ///   - actual: The actual value to test.
  ///   - expected: The expected value to compare against.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertEqual<T: Equatable>(
    _ actual: T,
    _ expected: T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      actual,
      expected,
      message ?? "Expected \(actual) to be equal to \(expected)",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that two values are not equal.
  /// - Parameters:
  ///   - actual: The first value to compare.
  ///   - expected: The second value to compare against.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertNotEqual<T: Equatable>(
    _ actual: T,
    _ expected: T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertNotEqual(
      actual,
      expected,
      message ?? "Expected \(actual) to not be equal to \(expected)",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that a condition is true.
  /// - Parameters:
  ///   - condition: The condition to test for truth.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertTrue(
    _ condition: Bool,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(
      condition,
      message ?? "Expected condition to be true",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that a condition is false.
  /// - Parameters:
  ///   - condition: The condition to test for falsity.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertFalse(
    _ condition: Bool,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(
      condition,
      message ?? "Expected condition to be false",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that an expression evaluates to `nil`.
  /// - Parameters:
  ///   - expression: The expression to evaluate.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertNil<T>(
    _ expression: @autoclosure () -> T?,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertNil(
      expression(),
      message ?? "Expected value to be nil",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that an expression evaluates to a non-nil value.
  /// - Parameters:
  ///   - expression: The expression to evaluate.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertNotNil<T>(
    _ expression: @autoclosure () -> T?,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertNotNil(
      expression(),
      message ?? "Expected value to be non-nil",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that an expression does not throw an error.
  /// - Parameters:
  ///   - expression: The expression to evaluate.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertNoThrow<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertNoThrow(
      try expression(),
      message ?? "Expected expression not to throw an error",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that an expression throws a specific error.
  /// - Parameters:
  ///   - expression: The expression to evaluate.
  ///   - expectedError: The expected error to compare against.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertThrowsError<T, E: Error & Equatable>(
    _ expression: @autoclosure () throws -> T,
    _ expectedError: E,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    do {
      _ = try expression()
      XCTFail(
        message ?? "Expected expression to throw \(expectedError), but no error was thrown",
        file: file,
        line: line
      )
    } catch let error as E {
      XCTAssertEqual(
        error,
        expectedError,
        message ?? "Expected error \(expectedError), but got \(error)",
        file: file,
        line: line
      )
    } catch {
      XCTFail(
        message ?? "Unexpected error type: \(error)",
        file: file,
        line: line
      )
    }
  }

  /// A helper function to assert that an expression throws an error.
  /// - Parameters:
  ///   - expression: The expression to evaluate.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertThrowsError<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    do {
      _ = try expression()
      XCTFail(
        message ?? "Expected expression to throw an error, but no error was thrown",
        file: file,
        line: line
      )
    } catch {}
  }

  /// A helper function to assert that one value is greater than or equal to another.
  /// - Parameters:
  ///   - actual: The actual value to test.
  ///   - expected: The value to compare against.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertGreaterThanOrEqual<T: Comparable>(
    _ actual: T,
    _ expected: T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertGreaterThanOrEqual(
      actual,
      expected,
      message ?? "Expected \(actual) to be greater than or equal to \(expected)",
      file: file,
      line: line
    )
  }

  /// A helper function to assert that one value is less than or equal to another.
  /// - Parameters:
  ///   - actual: The actual value to test.
  ///   - expected: The value to compare against.
  ///   - message: A message to display if the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func assertLessThanOrEqual<T: Comparable>(
    _ actual: T,
    _ expected: T,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertLessThanOrEqual(
      actual,
      expected,
      message ?? "Expected \(actual) to be less than or equal to \(expected)",
      file: file,
      line: line
    )
  }

  /// A helper function to force a test failure with a custom message.
  /// - Parameters:
  ///   - message: A message to display when the assertion fails (optional).
  ///   - file: The file in which failure occurs. The default is the current file.
  ///   - line: The line number at which failure occurs. The default is the current line.
  func fail(
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTFail(
      message ?? "Forced failure",
      file: file,
      line: line
    )
  }
}

// MARK: - Publishers

extension XCTestCase {

  /// Waits for a publisher to produce an output and returns the output.
  ///
  /// This method creates an expectation that will wait for the publisher to emit a value or complete.
  /// If the publisher emits a failure, the expectation is fulfilled with the error.
  /// If the publisher emits a value, the expectation is fulfilled with the value.
  ///
  /// - Parameters:
  ///   - publisher: The Combine publisher to wait for.
  ///   - timeout: The maximum time to wait for the publisher to emit a value. The default is 2.0 seconds.
  ///   - file: The file in which the failure occurred. The default is the file where this method is called.
  ///   - line: The line number on which the failure occurred. The default is the line where this method is called.
  /// - Returns: The output produced by the publisher.
  /// - Throws: An error if the publisher fails or if no output is produced within the timeout period.
  func awaitPublisher<T: Publisher>(
    _ publisher: T,
    timeout: TimeInterval = 2.0,
    file: StaticString = #file,
    line: UInt = #line
  ) throws -> T.Output {
    let expectation = expectation(description: "Awaiting publisher output")
    var result: Result<T.Output, Error>?

    let cancellable = publisher
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            result = .failure(error)
          }
          expectation.fulfill()
        },
        receiveValue: { value in
          result = .success(value)
          expectation.fulfill()
        }
      )

    waitForExpectations(timeout: timeout)
    cancellable.cancel()

    let unwrappedResult = try XCTUnwrap(
      result,
      "Awaited publisher did not produce any output",
      file: file,
      line: line
    )
    return try unwrappedResult.get()
  }
}

// MARK: - Sequence

extension Sequence {

  /// Performs an asynchronous compactMap operation over a sequence.
  /// - Parameter transform: An asynchronous closure that transforms an element of the sequence into an optional value of type T.
  /// - Returns: An array of transformed non-nil values.
  func asyncCompactMap<T>(
    _ transform: @escaping (Element) async -> T?
  ) async -> [T] {
    var results: [T] = []
    for element in self {
      if let transformed = await transform(element) {
        results.append(transformed)
      }
    }
    return results
  }
}
