//
//  SequencerDelayTests.swift
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

final class SequencerDelayTests: XCTestCase {

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

  func testBasicDelayAction() {
    let expectation = expectation(description: "Basic delay action should execute after delay")
    let startTime = Date()
    var timeElapsed: Double = 0

    sequencer
      .delayFor(1.0) {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2)

    let expectedDelay = 1.0
    let tolerance = 0.1

    assertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      """
      Basic delay did not execute as expected:
      elapsed time \(timeElapsed) was outside
      the tolerance of \(expectedDelay) ± \(tolerance)
      """
    )
  }

  func testDelayWithAnimationConfiguration() {
    let expectation = expectation(description: "Delay with animation configuration should execute after delay")
    let startTime = Date()
    var timeElapsed: Double = 0

    let animationType = AnimationConfiguration.linear(duration: 0.5)

    sequencer
      .delayFor(1.0, animate: animationType) {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2)

    let expectedDelay = 1.0
    let tolerance = 0.1

    assertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      """
      Delay with animation configuration did not execute as expected:
      elapsed time \(timeElapsed) was outside
      the tolerance of \(expectedDelay) ± \(tolerance)
      """
    )
  }

  func testDelayWithAnimationType() {
    let expectation = expectation(description: "Delay with animation type should execute after delay")
    let startTime = Date()
    var timeElapsed: Double = 0

    let animationType = AnimationConfiguration.easeIn(duration: 0.5)

    sequencer
      .delayFor(1.0, animate: animationType) {
        timeElapsed = Date().timeIntervalSince(startTime)
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2)

    let expectedDelay = 1.0
    let tolerance = 0.1

    assertTrue(
      abs(timeElapsed - expectedDelay) <= tolerance,
      """
      Delay with animation type did not execute as expected:
      elapsed time \(timeElapsed) was outside
      the tolerance of \(expectedDelay) ± \(tolerance)
      """
    )
  }
}
