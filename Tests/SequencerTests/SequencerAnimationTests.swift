//
//  SequencerAnimationTests.swift
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

final class SequencerAnimationTests: XCTestCase {

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

  func testAllSequencerAnimationTypes() {
    verifyAnimationConfigurationCompletes(
      configuration: .linear(duration: 0.5),
      expectedDescription: "Linear Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )

    verifyAnimationConfigurationCompletes(
      configuration: .easeIn(duration: 0.5),
      expectedDescription: "Ease In Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )

    verifyAnimationConfigurationCompletes(
      configuration: .easeOut(duration: 0.5),
      expectedDescription: "Ease Out Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )

    verifyAnimationConfigurationCompletes(
      configuration: .easeInEaseOut(duration: 0.5),
      expectedDescription: "Ease In-Ease Out Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )

    verifyAnimationConfigurationCompletes(
      configuration: .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.1),
      expectedDescription: "Spring Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )

    verifyAnimationConfigurationCompletes(
      configuration: .bouncy(duration: 0.5),
      expectedDescription: "Bouncy Animation | Duration: 0.5 s, Speed: 1.0, Repeat Count: 0"
    )
  }

  // MARK: - Looping

  func testLoopAction() {
    let loopCount = 3
    let expectedRunCount = loopCount
    var runCount = 0
    let expectation = expectation(description: "Loop action should execute \(expectedRunCount) times")

    sequencer
      .run { runCount += 1 }
      .loop(times: loopCount)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    assertEqual(
      runCount,
      expectedRunCount,
      """
      The action should have been executed \(expectedRunCount) times (initial run + \(loopCount) loops),
      but it was executed \(runCount) times.
      """
    )
  }

  // MARK: - Action CompletionHandlers

  func testActionCompletionHandlers() {
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
      }
      .start()
  }
}

// MARK: - Helpers

extension SequencerAnimationTests {

  func verifyAnimationConfigurationCompletes(
    configuration: AnimationConfiguration,
    expectedDescription: String
  ) {
    let expectation = expectation(description: "\(expectedDescription) should complete within duration")

    assertEqual(configuration.verboseDescription, expectedDescription)

    Sequencer()
      .animate(configuration) {}
      .completion { expectation.fulfill() }
      .start()

    wait(for: [expectation], timeout: configuration.duration + 0.1)
  }
}
