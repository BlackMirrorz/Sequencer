//
//  DurationCalculableTests.swift
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

final class DurationCalculableTests: XCTestCase {

  struct TestAnimation: DurationCalculable {
    let duration: Double
    let speed: Double
    let repeatCount: Int?
  }

  func testSinglePlaythroughWithNormalSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 1.0, repeatCount: nil)
    assertEqual(
      animation.calculateAdjustedDuration(),
      2.0,
      "Duration should match the original duration when speed is 1.0 and no repeat count is specified."
    )
  }

  func testSinglePlaythroughWithIncreasedSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 2.0, repeatCount: nil)
    assertEqual(
      animation.calculateAdjustedDuration(),
      1.0,
      "Duration should halve when speed is 2.0 and no repeat count is specified."
    )
  }

  func testSinglePlaythroughWithDecreasedSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 0.5, repeatCount: nil)
    assertEqual(
      animation.calculateAdjustedDuration(),
      4.0,
      "Duration should double when speed is 0.5 and no repeat count is specified."
    )
  }

  func testRepeatedAnimationWithNormalSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 1.0, repeatCount: 2)
    assertEqual(
      animation.calculateAdjustedDuration(),
      6.0,
      "Duration should be three times the original duration (2.0 * (2 + 1)) when repeat count is 2."
    )
  }

  func testRepeatedAnimationWithIncreasedSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 2.0, repeatCount: 2)
    assertEqual(
      animation.calculateAdjustedDuration(),
      3.0,
      "Duration should be 3 seconds when repeat count is 2 and speed is 2.0 (adjusted duration * (repeatCount + 1))."
    )
  }

  func testRepeatedAnimationWithDecreasedSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 0.5, repeatCount: 2)
    assertEqual(
      animation.calculateAdjustedDuration(),
      12.0,
      "Duration should be 12 seconds when repeat count is 2 and speed is 0.5 (adjusted duration * (repeatCount + 1))."
    )
  }

  func testZeroSpeedDefaultsToNormalSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: 0.0, repeatCount: 2)
    assertEqual(
      animation.calculateAdjustedDuration(),
      6.0,
      "Zero speed should default to 1.0 speed, resulting in a duration of 6 seconds for repeat count of 2."
    )
  }

  func testNegativeSpeedDefaultsToNormalSpeed() {
    let animation = TestAnimation(duration: 2.0, speed: -1.0, repeatCount: 1)
    assertEqual(
      animation.calculateAdjustedDuration(),
      4.0,
      "Negative speed should default to 1.0 speed, resulting in a duration of 4 seconds for repeat count of 1."
    )
  }
}
