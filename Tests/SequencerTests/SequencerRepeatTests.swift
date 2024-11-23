//
//  SequencerRepeatTests.swift
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

final class SequencerRepeatTests: XCTestCase {

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
    assertEqual(
      runCount,
      repeatCount + 1,
      """
      The action should have been repeated \(repeatCount) times,
      but it was repeated \(runCount) times.
      """
    )
  }

  func testRepeatActionWithDuration() {
    let repeatCount = 5
    let actionDuration = 2.0
    let expectedTotalDuration = actionDuration * Double(repeatCount + 1)
    var runCount = 0
    let expectation = expectation(
      description:
      """
      Repeat action should execute \(repeatCount) times and total duration should be \(expectedTotalDuration) seconds
      """
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

    assertEqual(
      runCount,
      repeatCount + 1,
      """
      The action should have been repeated \(repeatCount) times,
      but it was repeated \(runCount) times.
      """
    )

    let tolerance = 0.5

    assertTrue(
      abs(timeElapsed - expectedTotalDuration) <= tolerance,
      """
      Total duration was not as expected:
      elapsed time \(timeElapsed) was outside
      the tolerance of \(expectedTotalDuration) ± \(tolerance)
      """
    )
  }

  func testLoopAction() {
    let loopCount = 3
    let expectedRunCount = loopCount
    var runCount = 0
    let expectation = expectation(description: "Loop action should execute \(expectedRunCount) times")

    sequencer
      .run {
        runCount += 1
      }
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

  func testRepeatActionWithAnimations() {
    let repeatCount = 3
    let loopCount = 3
    let expectedRunCount = (repeatCount + 1) * loopCount
    var runCount = 0
    let expectation = expectation(
      description: "Repeat action with animations should execute \(expectedRunCount) times with animation"
    )

    sequencer
      .animate(AnimationConfiguration.easeInEaseOut(duration: 0.2)) {
        runCount += 1
      }
      .repeat(times: repeatCount)
      .loop(times: loopCount)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 10.0)

    XCTAssertEqual(
      runCount,
      expectedRunCount,
      """
      The action should have been executed \(repeatCount + 1) times per loop,
      with \(loopCount) loops, for a total of \(expectedRunCount) executions.
      """
    )
  }
}
