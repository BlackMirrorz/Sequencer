//
//  Sequencable.swift
//  Sequencer
//
//  Created by Josh Robbins on 10/28/24.
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

  /// Tracks if the sequence was cancelled.
  var isCancelled: Bool { get set }

  /// Completion handler to be called after the sequence completes all actions.
  var completionHandler: DefaultClosure? { get set }

  /// Indicates whether logging is enabled for each step in the sequence.
  var logsSteps: Bool { get set }

  /// Performs the specifed Sequece Action
  /// - Parameter action: The action to be be executed
  /// - Returns: The updated instance, allowing for method chaining.
  func perform(_ action: SequenceAction) -> Self

  /// Starts executing the sequence from the first action.
  func start()

  /// Cancels the sequence and stops further execution of actions.
  func cancel()

  /// Sets a completion handler to be called when the sequence finishes all actions.
  /// - Parameter handler: The closure to execute upon sequence completion.
  /// - Returns: The updated instance, allowing for method chaining.
  func completion(_ handler: @escaping DefaultClosure) -> Self

  /// Logs a message if logging is enabled.
  /// - Parameter message: The message to log.
  func logState(_ message: String)
}
