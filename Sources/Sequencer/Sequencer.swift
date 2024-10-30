//
//  Sequencer.swift
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

import Foundation
import OSLog
import SwiftUI

// MARK: - Sequencer Class

/**
 A class that manages the execution of a sequence of actions.
 Actions can include animations, delays, pauses, and immediate actions.
 The `Sequencer` supports logging each step and has start, cancel, and completion controls.
 */
public final class Sequencer: Sequencable, ObservableObject {
  var actions: [SequenceAction] = []
  var isCancelled = false
  var completionHandler: DefaultClosure?
  var logsSteps = true

  let sequenceLogger = Logger(subsystem: "Sequencer", category: "State")

  // MARK: - Initialization

  /// Initializes a new `Sequencer` instance with optional logging.
  /// - Parameter logsSteps: Enables logging for each step if set to `true`.
  public init(logsSteps: Bool = false) {
    self.logsSteps = logsSteps
  }

  deinit {
    logState("Sequencer Deinitialized")
  }

  // MARK: - LifeCycle

  /// Starts executing the sequence of actions.
  /// Logs the number of steps and begins processing the queued actions.
  public final func start() {
    logState("Starting sequence of \(actions.count) steps.")
    isCancelled = false
    executeActions()
  }

  /// Cancels the sequence, clearing all pending actions and calling the completion handler if set.
  public final func cancel() {
    logState("Sequencer cancelled.")
    isCancelled = true
    actions.removeAll()
    completionHandler?()
  }

  /// Sets a completion handler to be called when the sequence completes.
  /// - Parameter handler: The closure to be executed upon sequence completion.
  /// - Returns: The `Sequencer` instance, allowing for method chaining.
  public final func completion(_ handler: @escaping DefaultClosure) -> Self {
    completionHandler = handler
    return self
  }

  // MARK: - Steps

  /// Adds an action to be performed as part of the sequence.
  /// - Parameter action: The action to perform, of type `SequenceAction`.
  /// - Returns: The `Sequencer` instance, enabling chaining of further actions.
  public func perform(_ action: SequenceAction) -> Self {
    actions.append(action)
    return self
  }

  /// Executes actions in sequence, calling each one and handling completion.
  /// Logs the current step and recursively processes each action until the sequence is complete.
  func executeActions() {

    guard
      !isCancelled,
      !actions.isEmpty
    else {
      logState("All steps completed.")
      completionHandler?()
      return
    }

    let action = actions.removeFirst()
    logState("Executing step: \(action.verboseDescription)")

    action.execute { [weak self] in
      guard let self = self else { return }
      self.logState("Step \(action.verboseDescription) completed.")

      self.executeActions()
    }
  }
}

// MARK: - Default Steps

public extension Sequencer {

  /// Adds an instantaneous action to the sequence.
  /// - Parameter action: The block of code to be executed.
  /// - Returns: The `Sequencer` instance with the new action added, allowing for method chaining.
  final func run(action: @escaping DefaultClosure) -> Self {
    actions.append(RunAction(action: action))
    return self
  }

  /// Adds an animated action to the sequence.
  /// - Parameters:
  ///   - animationWithDuration: An `AnimationWithDuration` instance defining the animation style and duration.
  ///   - action: The closure to execute within the animation.
  /// - Returns: The `Sequencer` instance with the animated action added, allowing for method chaining.
  final func animate(
    _ animationWithDuration: AnimationWithDuration,
    action: @escaping DefaultClosure
  ) -> Self {
    actions.append(AnimateAction(
      animationWithDuration: animationWithDuration,
      action: action
    ))
    return self
  }

  /// Convenience method to add a default `SequencerAnimationType`.
  /// - Parameters:
  ///   - type: The animation type (e.g., linear, spring) specified as `SequencerAnimationType`.
  ///   - action: The closure to execute within the animation.
  /// - Returns: The `Sequencer` instance with the animated action added, allowing for method chaining.
  final func animate(
    type: SequencerAnimationType,
    action: @escaping DefaultClosure
  ) -> Self {
    actions.append(AnimateAction(
      animationWithDuration: type.animationWithDuration,
      action: action
    ))
    return self
  }

  /// Pauses the sequence for the specified number of seconds.
  /// - Parameter seconds: Duration to pause in seconds.
  /// - Returns: The `Sequencer` instance with the pause action added, allowing for method chaining.
  final func pause(_ seconds: CGFloat) -> Self {
    actions.append(PauseAction(seconds: seconds))
    return self
  }

  /// Performs a block of code after the given duration.
  /// - Parameters:
  ///   - seconds: Duration before the action is executed.
  ///   - action: The block of code to be executed.
  /// - Returns: The `Sequencer` instance with the delayed action added, allowing for method chaining.
  final func delayFor(_ seconds: CGFloat, action: @escaping DefaultClosure) -> Self {
    actions.append(DelayAction(seconds: seconds, action: action))
    return self
  }

  /// Repeats the last action in the sequence a specified number of times.
  /// This allows you to duplicate the last added step, such as an animation, run, or delay action,
  /// without needing to re-define it multiple times.
  /// - Parameter times: The number of times to repeat the last action in the sequence.
  /// - Returns: The `Sequencer` instance with the repeated action, allowing for method chaining.
  final func `repeat`(times: Int) -> Self {
    guard let lastAction = actions.last else { return self }

    actions.removeLast()
    let repeatAction = RepeatAction(action: lastAction, times: times)
    actions.append(repeatAction)

    return self
  }
}

// MARK: - Debug

extension Sequencer {
  
  /// Logs the state of the sequencer if logging is enabled.
  /// - Parameter message: The message to log.
  func logState(_ message: String) {
    guard logsSteps else { return }
    
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
      print(message)
    } else {
      sequenceLogger.log("\(message, privacy: .public)")
    }
  }
}
