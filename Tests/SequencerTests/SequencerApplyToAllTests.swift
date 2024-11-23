//
//  SequencerApplyToAllTests.swift
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

final class SequencerApplyToAllTests: XCTestCase {

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

  func testApplyToAllConfiguresAllActions() {
    let expectation = expectation(description: "All actions should respect the default configuration")
    let defaultConfiguration = AnimationConfiguration.easeInEaseOut(duration: 0.3)
    var capturedDescriptions: [String] = []

    sequencer
      .animate(AnimationConfiguration.linear(duration: 0.5)) {
        capturedDescriptions.append("First animation")
      }
      .delayFor(1.0) {
        capturedDescriptions.append("Delay action")
      }
      .pause(0.5)
      .applyToAll(defaultConfiguration)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2)

    assertEqual(
      capturedDescriptions,
      ["First animation", "Delay action"],
      "Actions should execute in order, and only modifiable actions should have changed configurations."
    )

    assertTrue(
      capturedDescriptions.contains("First animation"),
      "The default configuration should apply to AnimateAction."
    )
  }

  func testApplyToAllDoesNotModifyNonAnimatableActions() {
    let expectation = expectation(description: "Non-animatable actions should remain unchanged")
    var capturedDescriptions: [String] = []

    let defaultConfiguration = AnimationConfiguration.easeInEaseOut(duration: 0.5)

    sequencer
      .run {
        capturedDescriptions.append("Run action")
      }
      .pause(1.0)
      .applyToAll(defaultConfiguration)
      .completion {
        capturedDescriptions.append("Sequence completed")
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2.0)

    assertEqual(
      capturedDescriptions,
      ["Run action", "Sequence completed"],
      "Non-animatable actions like RunAction and PauseAction should remain unchanged after applyToAll is called."
    )
  }

  func testApplyToAllAppliesToRepeatActionRecursively() {
    let expectation = expectation(description: "Repeat actions should apply configuration recursively")
    let defaultConfiguration = AnimationConfiguration.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.1)
    var capturedDescriptions: [String] = []

    var counter = 0

    sequencer
      .animate(AnimationConfiguration.linear(duration: 0.3)) {
        capturedDescriptions.append("First animation")
        counter += 1
      }
      .repeat(times: 2)
      .applyToAll(defaultConfiguration)
      .completion {
        capturedDescriptions.append("Sequence completed")
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 3.0)

    assertEqual(
      capturedDescriptions,
      ["First animation", "First animation", "First animation", "Sequence completed"],
      """
      RepeatAction should apply the default configuration recursively to all repeated actions.
      """
    )
  }

  func testApplyToAllWithMixedActions() {
    let expectation = expectation(description: "Default configuration should apply only to animatable actions")
    let defaultConfiguration = AnimationConfiguration.easeIn(duration: 1.0)
    var capturedDescriptions: [String] = []

    let updatedSequencer = sequencer
      .animate(AnimationConfiguration.easeOut(duration: 0.1)) {
        capturedDescriptions.append("First animation")
      }
      .animate(AnimationConfiguration.easeOut(duration: 0.1)) {
        capturedDescriptions.append("Second animation")
      }
      .animate(AnimationConfiguration.easeOut(duration: 0.1)) {
        capturedDescriptions.append("Third animation")
      }
      .pause(0.5)
      .applyToAll(defaultConfiguration)

    let verboseDescriptionsBeforeExecution = updatedSequencer.actions.map { $0.verboseDescription }

    updatedSequencer
      .completion {
        capturedDescriptions.append("Sequence completed")
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 5.0)

    XCTAssertEqual(
      capturedDescriptions,
      ["First animation", "Second animation", "Third animation", "Sequence completed"],
      """
      Animatable actions like AnimateAction should execute correctly,
      and non-animatable actions like PauseAction should remain unchanged.
      """
    )

    let expectedVerboseDescriptions = [
      "Animation of type Ease In Animation | Duration: 1.0 s, Speed: 1.0, Repeat Count: 0",
      "Animation of type Ease In Animation | Duration: 1.0 s, Speed: 1.0, Repeat Count: 0",
      "Animation of type Ease In Animation | Duration: 1.0 s, Speed: 1.0, Repeat Count: 0",
      "Pausing for 0.5 seconds."
    ]

    XCTAssertEqual(
      verboseDescriptionsBeforeExecution,
      expectedVerboseDescriptions,
      """
      Verbose descriptions should reflect the applied default configuration
      for animatable actions while leaving non-animatable actions unchanged.
      """
    )
  }

  func testValidateConfigurationUpdatesAfterApplyToAll() {
    let expectation = expectation(description: "All applicable actions should update their configuration")
    let defaultConfiguration = AnimationConfiguration.bouncy(duration: 0.5)
    let tolerance = 0.1
    let expectedDuration = 0.5 + 0.5

    let updatedSequencer = sequencer
      .animate(AnimationConfiguration.linear(duration: 0.3)) {}
      .delayFor(0.5) {}
      .applyToAll(defaultConfiguration)
      .completion {
        expectation.fulfill()
      }

    let firstAction = sequencer.actions.first as? AnimateAction
    let secondAction = sequencer.actions[1] as? DelayAction

    let actualDuration = (firstAction?.confguration.duration ?? 0) + (secondAction?.seconds ?? 0)
    XCTAssertTrue(
      abs(actualDuration - expectedDuration) <= tolerance,
      """
      The total duration should be close to \(expectedDuration) ± \(tolerance),
      but was \(actualDuration).
      """
    )

    updatedSequencer.start()

    wait(for: [expectation], timeout: 3.0)
  }
}
