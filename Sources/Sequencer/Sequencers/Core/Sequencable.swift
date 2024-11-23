//
//  Sequencable.swift
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

import SwiftUI

// MARK: - Sequencable Protocol

/**
 Protocol defining requirements for creating a sequence of actions that can be controlled, animated, and logged.
 Conforming types allow adding actions to a sequence and managing execution flow with start, cancel, and completion controls.
 */
protocol Sequencable {

  /// Array of sequential actions to execute.
  var actions: [SequenceAction] { get set }

  /// Original array of actions used when looping.
  var originalActions: [SequenceAction] { get set }

  /// The initial count of loops to be executed.
  var loopCount: Int { get set }

  /// The number of remaining loops to complete.
  var remainingLoops: Int { get set }

  /// Tracks if the sequence was cancelled.
  var isCancelled: Bool { get set }

  /// Indicates whether logging is enabled for each step in the sequence.
  var logsSteps: Bool { get set }

  /// Completion handler to be called after the sequence completes all actions.
  var completionHandler: DefaultClosure? { get set }

  /// Completion handler to be called after each action occurs.
  var actionCompletionHandler: ((SequenceAction) -> Void)? { get set }

  /// Global configuration for animatable actions.
  var globalConfiguration: AnimationConfiguration { get set }

  /// Starts executing the sequence from the first action.
  func start()

  /// Cancels the sequence and stops further execution of actions.
  func cancel()

  /// Sets the global animation configuration for the sequence.
  /// - Parameter configuration: The global animation configuration to apply.
  /// - Returns: The updated instance, allowing for method chaining.
  func setGlobalConfiguration(_ configuration: AnimationConfiguration) -> Self

  /// Applies a default animation configuration to all applicable actions in the sequence.
  /// - Parameter defaultConfiguration: The animation configuration to be applied to all actions.
  /// - Returns: The updated instance with the configuration applied to relevant actions, allowing for method chaining.
  func applyToAll(_ defaultConfiguration: AnimationConfiguration) -> Self

  /// Adds an instantaneous action to the sequence.
  /// - Parameter action: The block of code to be executed.
  /// - Returns: The updated instance with the new action added, allowing for method chaining.
  func run(action: @escaping DefaultClosure) -> Self

  /// Runs a block of actions as a grouped sequence.
  /// This method allows you to define a temporary sequence of actions within the provided closure.
  /// Actions defined inside the block will inherit the current global configuration unless updated
  /// explicitly within the block. Once the block finishes, its actions are wrapped into a `BlockAction`
  /// and appended to the main sequence.
  ///
  /// - Parameter block: A closure that accepts a `BlockSequencer` for chaining actions within the block.
  /// - Returns: The `Sequencer` instance for continued chaining.
  func runBlock(_ block: (Sequencer) -> Void) -> Self

  /// Adds the specified sequence action to the sequence. Ideal for custom actions.
  /// - Parameter action: The action to be executed.
  /// - Returns: The updated instance, allowing for method chaining.
  func perform(_ action: SequenceAction) -> Self

  /// Adds an animated action to the sequence.
  /// - Parameters:
  ///   - configuration: An optional `AnimationConfiguration` instance defining the animation style and duration.
  ///                    If `nil`, the global configuration is used.
  ///   - action: The closure to execute within the animation.
  /// - Returns: The updated instance with the animated action added, allowing for method chaining.
  func animate(
    _ configuration: AnimationConfiguration?,
    action: @escaping DefaultClosure
  ) -> Self

  /// Pauses the sequence for a specified duration.
  /// - Parameter seconds: Duration to pause in seconds.
  /// - Returns: The updated instance with the pause action added, allowing for method chaining.
  func pause(_ seconds: CGFloat) -> Self

  /// Delays the execution of an action for a specified duration with an optional animation.
  /// - Parameters:
  ///   - seconds: Duration to wait before the action is executed.
  ///   - configuration: An optional `AnimationConfiguration` for animating the delay.
  ///                    If `nil`, the global configuration is used.
  ///   - action: The block of code to be executed after the delay.
  /// - Returns: The updated instance with the delayed action added, allowing for method chaining.
  func delayFor(
    _ seconds: CGFloat,
    animate configuration: AnimationConfiguration?,
    action: @escaping DefaultClosure
  ) -> Self

  /// Delays the execution of an action for a specified duration without animation.
  /// - Parameters:
  ///   - seconds: Duration to wait before the action is executed.
  ///   - action: The block of code to be executed after the delay.
  /// - Returns: The updated instance with the delayed action added, allowing for method chaining.
  func delayFor(_ seconds: CGFloat, action: @escaping DefaultClosure) -> Self

  /// Repeats the last action in the sequence a specified number of times.
  /// - Parameter times: The number of times to repeat the last action in the sequence.
  /// - Returns: The updated instance with the repeated action, allowing for method chaining.
  func `repeat`(times: Int) -> Self

  /// Loops the sequence a specified number of times.
  /// - Parameter times: The number of times to repeat the entire sequence.
  /// - Returns: The updated instance with the loop functionality added, allowing for method chaining.
  func loop(times: Int) -> Self

  /// Sets a completion handler to be called when the sequence finishes all actions.
  /// - Parameter handler: The closure to execute upon sequence completion.
  /// - Returns: The updated instance, allowing for method chaining.
  func completion(_ handler: @escaping DefaultClosure) -> Self

  /// Sets a closure to be called after each action in the sequence completes.
  /// - Parameter handler: A closure that executes after each action completes.
  /// - Returns: The updated instance, allowing for method chaining.
  func onActionCompletion(_ handler: @escaping DefaultClosure) -> Self

  /// Enables debug logging for the sequence.
  /// - Returns: The updated instance with debugging enabled.
  func debug() -> Self

  /// Logs a message if logging is enabled.
  /// - Parameter message: The message to log.
  func logState(_ message: String)
}
