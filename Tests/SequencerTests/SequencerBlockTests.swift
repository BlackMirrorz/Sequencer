//
//  SequencerBlockTests.swift
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

final class SequencerBlockTests: XCTestCase {

  private var sequencer: Sequencer!
  private var executionStartTime: Date!

  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()
    sequencer = Sequencer()
    executionStartTime = Date()
  }

  override func tearDown() {
    super.tearDown()
    sequencer = nil
    executionStartTime = nil
  }

  // MARK: - Basic Tests

  func testBlockExecutionOfBasicRunActions() {
    var runCounter = 0

    sequencer
      .runBlock { block in
        block.run { runCounter += 1 }
        block.run { runCounter += 3 }
        block.run { runCounter += 1 }
      }
      .start()

    assertEqual(runCounter, 5, "The sequencer should have incremented the counter to 5.")
  }

  func testBlockWithDefaultAnimation() {

    var runCounter = 0

    let expectation = self.expectation(description: "Default Animation should be applied")

    let upatedSequencer = sequencer
      .runBlock { block in
        block.animate { runCounter += 1 }
      }

    let verboseDescription = sequencer.actions.flatMap { action in
      action.verboseDescription.split(separator: "\n").map { String($0) }
    }

    let expectedDescriptions: [String] = [
      "Block Action:",
      "Animation of type Linear Animation | Duration: 1.0 s, Speed: 1.0, Repeat Count: 0"
    ]

    upatedSequencer
      .onActionCompletion { expectation.fulfill() }
      .start()

    wait(for: [expectation], timeout: 1.2)

    assertEqual(runCounter, 1, "Run Counter should have been incremented once")
    assertEqual(verboseDescription, expectedDescriptions, "Logs should be the same")
  }

  func testBlockWithAnimationApplied() {

    var runCounter = 0

    let expectation = self.expectation(description: "Custom Animation should be applied")

    let upatedSequencer = sequencer
      .runBlock { block in
        block.animate(.linear(duration: 2.0)) { runCounter += 1 }
      }

    let verboseDescription = sequencer.actions.flatMap { action in
      action.verboseDescription.split(separator: "\n").map { String($0) }
    }

    let expectedDescriptions: [String] = [
      "Block Action:",
      "Animation of type Linear Animation | Duration: 2.0 s, Speed: 1.0, Repeat Count: 0"
    ]

    upatedSequencer
      .onActionCompletion { expectation.fulfill() }
      .start()

    wait(for: [expectation], timeout: 2.2)

    assertEqual(runCounter, 1, "Run Counter should have been incremented once")
    assertEqual(verboseDescription, expectedDescriptions, "Logs should be the same")
  }

  func testBlockWithInternalRepeat() {
    var runCounter = 0

    sequencer
      .runBlock { block in
        block.run { runCounter += 5 }
        block.repeat(times: 3)
      }
      .start()

    assertEqual(runCounter, 20, "The sequencer should have incremented the counter to 20.")
  }

  func testBlockWithInternalLoop() {
    var runCounter = 0

    sequencer
      .runBlock { block in
        block.run { runCounter += 5 }
        block.repeat(times: 3)
        block.loop(times: 2)
      }
      .start()

    assertEqual(runCounter, 40, "The sequencer should have incremented the counter to 40.")
  }

  func testBlockWithExternalLoop() {
    var runCounter = 0

    sequencer
      .runBlock { block in
        block.run { runCounter += 5 }
        block.repeat(times: 3)
        block.loop(times: 2)
      }
      .loop(times: 1)
      .start()

    assertEqual(runCounter, 80, "The sequencer should have incremented the counter to 80.")
  }

  // MARK: - Timing Tests

  func testBlockWithDelays() {
    let expectation = self.expectation(description: "Block actions with delays should respect timing")
    var runCounter = 0

    sequencer
      .runBlock { block in
        block.run { runCounter += 1 }
        block.delayFor(0.5) { runCounter += 1 }
        block.run { runCounter += 1 }
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2.0)
    assertEqual(runCounter, 3, "The sequencer should have executed all actions, respecting delays.")
  }

  func testBlockWithPauses() {
    let expectation = self.expectation(description: "Block actions with pauses should respect timing")
    let expectedDuration: TimeInterval = 1.0
    var actualDuration: TimeInterval = 0

    sequencer
      .runBlock { block in
        block.run {
          actualDuration = Date().timeIntervalSince(self.executionStartTime)
        }
        block.pause(1.0)
        block.run {
          actualDuration = Date().timeIntervalSince(self.executionStartTime)
        }
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2.0)
    assertTrue(
      abs(actualDuration - expectedDuration) < 0.1,
      "The sequencer should respect pauses and execute subsequent actions after the specified duration."
    )
  }

  func testBlockWithTimingsAndLoops() {
    let expectation = self.expectation(description: "Block actions with loops should respect timing")
    var runCounter = 0
    let expectedDuration: TimeInterval = 1.5

    sequencer
      .runBlock { block in
        block.run { runCounter += 1 }
        block.delayFor(0.5) { runCounter += 1 }
        block.run { runCounter += 1 }
        block.loop(times: 3)
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    let startTime = Date()
    wait(for: [expectation], timeout: 5.0)
    let actualDuration = Date().timeIntervalSince(startTime)

    assertEqual(runCounter, 9, "The sequencer should have executed all actions in the block, respecting loops.")
    assertTrue(
      abs(actualDuration - expectedDuration) < 0.2,
      "The sequencer should respect timing within looped blocks."
    )
  }

  func testBlockWithRepeatsAndTiming() {
    let expectation = self.expectation(description: "Block actions with repeats should respect timing")
    var runCounter = 0
    let expectedDuration: TimeInterval = 2.0

    sequencer
      .runBlock { block in
        block.run { runCounter += 1 }
        block.delayFor(1.0) { runCounter += 1 }
        block.repeat(times: 1)
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    let startTime = Date()
    wait(for: [expectation], timeout: 3.0)
    let actualDuration = Date().timeIntervalSince(startTime)

    assertEqual(runCounter, 4, "The sequencer should have executed all actions in the block, respecting repeats.")
    assertTrue(
      abs(actualDuration - expectedDuration) < 0.2,
      "The sequencer should respect timing within repeated blocks."
    )
  }

  func testVeboseLogging() {

    let expectation = self.expectation(description: "Block actions with repeats should respect timing")
    var runCounter = 0

    let updatedSequencer = sequencer
      .runBlock { block in
        block.run { runCounter += 1 }
        block.delayFor(1.0) { runCounter += 1 }
        block.repeat(times: 2)
      }
      .completion {
        expectation.fulfill()
      }

    let verboseDescriptions = sequencer.actions.flatMap { action in
      action.verboseDescription.split(separator: "\n").map { String($0) }
    }

    let expectedVerboseDescriptions: [String] = [
      "Block Action:",
      "Running instantaneous step.",
      "Delay of 1.0 seconds.",
      "Running instantaneous step.",
      "Delay of 1.0 seconds.",
      "Running instantaneous step.",
      "Delay of 1.0 seconds."
    ]

    updatedSequencer.start()

    wait(for: [expectation], timeout: 6.5)

    assertEqual(
      verboseDescriptions,
      expectedVerboseDescriptions,
      "The sequencer should have executed all actions in the block, respecting repeats."
    )
  }

  // MARK: - Configuration Tests

  func testExternalGlobalConfiguration() {
    let expectation = self.expectation(description: "Block actions correct with global configuration")

    var runCounter = 0
    var capturedDescriptions: [String] = []

    let startTime = Date()

    sequencer
      .setGlobalConfiguration(.easeIn(duration: 0.5))
      .runBlock { block in
        block.run {
          runCounter += 1
          capturedDescriptions.append("Immediate run action executed.")
        }
        block.animate {
          runCounter += 2
          capturedDescriptions.append("Animation with global config executed.")
        }
        block.delayFor(0.5) {
          runCounter += 3
          capturedDescriptions.append("Delay action with global config executed.")
        }
      }
      .completion {
        expectation.fulfill()
      }.start()

    wait(for: [expectation], timeout: 1.5)

    let elapsedTime = Date().timeIntervalSince(startTime)

    assertEqual(runCounter, 6, "The sequencer should have incremented the counter to 6.")
    assertEqual(
      capturedDescriptions,
      [
        "Immediate run action executed.",
        "Animation with global config executed.",
        "Delay action with global config executed."
      ],
      "Verbose descriptions should match expected actions."
    )

    let expectedTime: TimeInterval = 1.0
    let tolerance: TimeInterval = 0.1

    assertTrue(
      abs(elapsedTime - expectedTime) <= tolerance,
      "Elapsed time \(elapsedTime) is outside the tolerance range."
    )
  }
}
