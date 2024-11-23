//
//  SequencerGlobalConfigurationTests.swift
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

final class SequencerGlobalConfigurationTests: XCTestCase {

  private var sequencer: Sequencer!

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    sequencer = Sequencer()
  }

  override func tearDown() {
    sequencer = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testGlobalConfigurationIsAppliedWhenNoExplicitConfiguration() {
    let globalConfig = AnimationConfiguration.easeIn(duration: 0.5)
    let expectation = expectation(description: "Global configuration should apply to animatable actions")

    var capturedDescription: String?

    sequencer
      .setGlobalConfiguration(globalConfig)
      .animate {
        capturedDescription = self.sequencer.globalConfiguration.verboseDescription
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    assertEqual(
      capturedDescription,
      globalConfig.verboseDescription,
      "The global configuration should be applied to the action when no explicit configuration is provided."
    )
  }

  func testExplicitConfigurationOverridesGlobalConfiguration() {
    let globalConfig = AnimationConfiguration.easeIn(duration: 0.5)
    let explicitConfig = AnimationConfiguration.easeOut(duration: 0.3)
    let expectation = expectation(description: "Explicit configuration should override global configuration")

    var capturedDescription: String?

    sequencer
      .setGlobalConfiguration(globalConfig)
      .animate(explicitConfig) {
        capturedDescription = explicitConfig.verboseDescription
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    assertEqual(
      capturedDescription,
      explicitConfig.verboseDescription,
      "The explicit configuration should override the global configuration."
    )
  }

  func testApplyToAllOverridesGlobalConfiguration() {
    let globalConfig = AnimationConfiguration.easeIn(duration: 0.5)
    let newConfig = AnimationConfiguration.easeIn(duration: 1.0)
    let expectation = expectation(description: "applyToAll should override all existing configurations")

    var capturedDescriptions: [String] = []

    sequencer
      .setGlobalConfiguration(globalConfig)
      .animate {
        capturedDescriptions.append("First animation using global config")
      }
      .animate(AnimationConfiguration.linear(duration: 0.4)) {
        capturedDescriptions.append("Second animation with explicit config")
      }
      .applyToAll(newConfig)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 2.1)

    XCTAssertTrue(
      capturedDescriptions.contains("First animation using global config"),
      "First animation should respect the applied configuration via applyToAll."
    )
  }

  func testSetGlobalConfigurationDoesNotAffectExistingActions() {
    let globalConfig = AnimationConfiguration.easeIn(duration: 0.5)
    let expectation = expectation(description: "Set global configuration should not alter already added actions")

    var capturedDescription: String?

    sequencer
      .animate(AnimationConfiguration.easeOut(duration: 0.4)) {
        capturedDescription = "Initial explicit config"
      }
      .setGlobalConfiguration(globalConfig)
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    assertEqual(
      capturedDescription,
      "Initial explicit config",
      "Setting global configuration should not affect actions already in the sequence."
    )
  }

  func testSetGlobalConfigurationAffectsSubsequentActions() {
    let globalConfig = AnimationConfiguration.easeIn(duration: 0.5)
    let expectation = expectation(description: "Set global configuration should apply to actions added afterward")

    var capturedDescriptions: [String] = []

    sequencer
      .animate(AnimationConfiguration.easeOut(duration: 0.4)) {
        capturedDescriptions.append("Explicit config")
      }
      .setGlobalConfiguration(globalConfig)
      .animate {
        capturedDescriptions.append("Global config")
      }
      .completion {
        expectation.fulfill()
      }
      .start()

    wait(for: [expectation], timeout: 1.0)

    assertTrue(
      capturedDescriptions.contains("Explicit config"),
      "Explicit configuration should apply to the first action."
    )

    assertTrue(
      capturedDescriptions.contains("Global config"),
      "Global configuration should apply to actions added after it is set."
    )
  }
}
