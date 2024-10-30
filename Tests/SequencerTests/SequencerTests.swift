//
//  SequencerTests.swift
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

final class SequencerTests: XCTestCase {

  private var sequencer: Sequencer!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    sequencer = Sequencer(logsSteps: true)
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

    XCTAssertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      "Pause did not delay as expected: elapsed time \(timeElapsed) was outside the tolerance of \(expectedDelay) ± \(tolerance)"
    )
  }

  func testDelayAction() {
    let expectation = expectation(description: "Delay action should delay the next step")
    let startTime = Date()
    var timeElapsed: Double = 0

    sequencer
      .delayFor(2, action: {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      })
      .start()

    wait(for: [expectation], timeout: 3)

    let expectedDelay = 2.0
    let tolerance = 0.1

    XCTAssertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      "Delay did nor work as expected: elapsed time \(timeElapsed) was outside the tolerance of \(expectedDelay) ± \(tolerance)"
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

    XCTAssertEqual(stepsCalled, 2, "Sequence should have only executed 2 steps before cancellation.")
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

  // MARK: - Animations

  func testAnimateActions() {
    verifyAnimationCompletes(animation: .linear(duration: 0.5), expectedDescription: "Linear Animation")
    verifyAnimationCompletes(animation: .easeIn(duration: 0.5), expectedDescription: "Ease In Animation")
    verifyAnimationCompletes(animation: .easeOut(duration: 0.5), expectedDescription: "Ease Out Animation")
    verifyAnimationCompletes(animation: .easeInEaseOut(duration: 0.5), expectedDescription: "Ease In-Ease Out Animation")
    verifyAnimationCompletes(animation: .spring(response: 0.5, dampingFraction: 0.8), expectedDescription: "Spring Animation")
    verifyAnimationCompletes(animation: .bouncy(duration: 0.5), expectedDescription: "Bouncy Animation")
  }

  // MARK: - Repeat Actions

  func testRepeatAction() {
    let repeatCount = 3
    var runCount = 0
    let expectation = expectation(description: "Repeat action should execute \(repeatCount) times")

    sequencer
      .run {
        runCount += 1
      }
      .repeat(times: repeatCount)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(
      runCount,
      repeatCount,
      "The action should have been repeated \(repeatCount) times, but it was repeated \(runCount) times."
    )
  }

  func testRepeatLastActionMultipleTimes() {
    let repeatCount = 2
    var runCount = 0
    var action1Count = 0
    let expectation = expectation(description: "Each action should execute the correct number of times with repeat.")

    sequencer
      .run {
        action1Count += 1
      }
      .run {
        runCount += 1
      }
      .repeat(times: repeatCount)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    XCTAssertEqual(
      action1Count,
      1,
      "The first action should have executed once."
    )
    XCTAssertEqual(
      runCount,
      repeatCount,
      "The last action should have been repeated \(repeatCount) times, but it was repeated \(runCount) times."
    )
  }

  func testRepeatActionWithDuration() {
    let repeatCount = 5
    let actionDuration = 2.0
    let expectedTotalDuration = actionDuration * Double(repeatCount)
    var runCount = 0
    let expectation = expectation(
      description: "Repeat action should execute \(repeatCount) times and total duration should be \(expectedTotalDuration) seconds"
    )

    let startTime = Date()
    var timeElapsed: Double = 0

    sequencer
      .delayFor(actionDuration) {
        runCount += 1
      }
      .repeat(times: repeatCount)
      .completion {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: expectedTotalDuration + 1.0)

    XCTAssertEqual(
      runCount,
      repeatCount,
      "The action should have been repeated \(repeatCount) times, but it was repeated \(runCount) times."
    )

    let tolerance = 0.5

    XCTAssertTrue(
      abs(timeElapsed - expectedTotalDuration) <= tolerance,
      "Total duration was not as expected: elapsed time \(timeElapsed) was outside the tolerance of \(expectedTotalDuration) ± \(tolerance)"
    )
  }
}

// MARK: - Helpers

extension SequencerTests {

  private func verifyAnimationCompletes(animation: AnimationWithDuration, expectedDescription: String) {
    let expectation = expectation(description: "\(expectedDescription) should complete within duration")

    XCTAssertEqual(animation.verboseDescription, expectedDescription)

    sequencer
      .animate(animation) {}
      .completion { expectation.fulfill() }
      .start()

    wait(for: [expectation], timeout: animation.duration + 0.1)
  }
}

// MARK: - Custom Action Helpers

extension SequencerTests {

  fileprivate struct FooAction: SequenceAction {

    let action: DefaultClosure

    var verboseDescription: String { "Running Foo step." }

    func execute(completion: @escaping DefaultClosure) {
      action()
      completion()
    }
  }
}
