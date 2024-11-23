//
//  SequenceAction.swift
//  Sequencer
//
//  Created by Josh Robbins on 10/28/24.
//

// MARK: - SequenceAction Protocol

/**
 Protocol defining a single step in the sequence, allowing custom actions
 to be added by conforming to this protocol and implementing the `execute` method.
 */
public protocol SequenceAction {

  /// Descriptive string for logging the action.
  var verboseDescription: String { get }

  /// Executes the action and calls the completion handler when done.
  /// - Parameter completion: The closure to call after the action completes.
  func execute(completion: @escaping DefaultClosure)
}
