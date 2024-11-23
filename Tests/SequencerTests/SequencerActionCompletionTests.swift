//
//  SequencerActionCompletionTests.swift
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

@testable import Sequencer
import XCTest

final class SequencerActionCompletionTests: XCTestCase {

  private var sequencer: Sequencer!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    sequencer = Sequencer()
  }

  override func tearDown() {
    super.tearDown()
    sequencer = nil
  }

  // MARK: - Tests

  func testActionCompletionHandlersWithNoClosureValue() {
    var identifiers: [Int: String] = [:]
    var runCount = 0

    let sequencer = Sequencer()

    sequencer
      .run { identifiers[0] = "foo" }
      .onActionCompletion { runCount += 1 }
      .run { identifiers[1] = "bar" }
      .onActionCompletion { runCount += 1 }
      .run { identifiers[2] = "baz" }
      .onActionCompletion { runCount += 1 }
      .run { identifiers[3] = "boz" }
      .onActionCompletion { runCount += 1 }
      .completion {
        self.assertEqual(runCount, 4, "Completion handler should confirm all actions were completed")
        self.assertEqual(identifiers[0], "foo", "Final check: identifiers[0] should be 'foo'")
        self.assertEqual(identifiers[1], "bar", "Final check: identifiers[1] should be 'bar'")
        self.assertEqual(identifiers[2], "baz", "Final check: identifiers[2] should be 'baz'")
        self.assertEqual(identifiers[3], "boz", "Final check: identifiers[3] should be 'boz'")
      }
      .start()
  }
}
