//
//  SequencerBasicActionsTests.swift
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

final class SequencerBasicActionsTests: XCTestCase {

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

  func testRunAction() {
    let expectation = expectation(description: "Run action should execute immediately")

    sequencer.run {
      expectation.fulfill()
    }.start()

    wait(for: [expectation], timeout: 0)
  }

  func testPauseAction() {
    let expectation = expectation(description: "Pause action should delay the next step")
    let startTime = Date()
    var timeElapsed: Double = 0

    sequencer
      .pause(0.5)
      .run {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1)

    let expectedDelay = 0.5
    let tolerance = 0.1

    assertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      """
      Pause did not delay as expected:
      elapsed time \(timeElapsed) was outside
      the tolerance of \(expectedDelay) ± \(tolerance)
      """
    )
  }

  func testCancelAction() {
    let expectation = expectation(description: "Cancel should prevent further steps from executing")

    var stepsCalled = 0

    sequencer
      .run { stepsCalled += 1 }
      .run { stepsCalled += 1 }
      .pause(1)
      .run { stepsCalled += 1 }
      .run { stepsCalled += 1 }
      .run { stepsCalled += 1 }
      .start()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.sequencer.cancel()
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 3)

    assertEqual(
      stepsCalled,
      2,
      """
      Sequence should have only executed 2 steps
      before cancellation, but executed \(stepsCalled)
      """
    )
  }

  func testCustomAction() {
    let expectation = expectation(description: "Custom action should execute within the sequence")

    sequencer
      .perform(FooAction {
        expectation.fulfill()
      })
      .start()

    wait(for: [expectation], timeout: 1.0)
  }

  func testSequenceCompletion() {
    let expectation = expectation(description: "Completion handler should be called after all actions")

    sequencer
      .run {}
      .pause(0.5)
      .completion {
        expectation.fulfill()
      }.start()

    wait(for: [expectation], timeout: 1.0)
  }
}
