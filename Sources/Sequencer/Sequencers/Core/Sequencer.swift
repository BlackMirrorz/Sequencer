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
public final class Sequencer: ObservableObject {

  var actions: [SequenceAction] = []
  var originalActions: [SequenceAction] = []
  var isCancelled = false
  var logsSteps = false
  var loopCount = 0
  var remainingLoops = 0

  var completionHandler: DefaultClosure?
  var actionCompletionHandler: ((SequenceAction) -> Void)?

  var globalConfiguration = AnimationConfiguration.linear(duration: 1)

  let sequenceLogger = Logger(subsystem: "Sequencer", category: "State")

  // MARK: - Initialization

  public init() {}

  deinit {
    logState("Sequencer Deinitialized")
  }

  // MARK: - LifeCycle

  public final func start() {
    guard !actions.isEmpty else { return }
    logState("Starting sequence of \(actions.count) steps.")
    isCancelled = false
    if loopCount > 0 {
      originalActions = actions

      if actions.contains(where: { $0 is BlockAction }) {
        remainingLoops = loopCount
      } else {
        remainingLoops = loopCount - 1
      }
    }
    executeActions()
  }

  public final func cancel() {
    logState("Sequencer cancelled.")
    isCancelled = true
    actions.removeAll()
    completionHandler?()
  }

  // MARK: - Completion Handlers

  public final func completion(_ handler: @escaping DefaultClosure) -> Self {
    completionHandler = handler
    return self
  }

  public final func onActionCompletion(_ handler: @escaping DefaultClosure) -> Self {
    actionCompletionHandler = { _ in handler() }
    return self
  }

  // MARK: - Global Configuration

  @discardableResult
  public final func setGlobalConfiguration(_ configuration: AnimationConfiguration) -> Self {
    globalConfiguration = configuration
    return self
  }
}

// MARK: - Execution

extension Sequencer {

  private func executeActions() {
    guard
      !isCancelled,
      let action = actions.first
    else {
      handleSequenceCompletion()
      return
    }

    logState("Executing action: \(action.verboseDescription)")
    actions.removeFirst()

    action.execute { [weak self] in
      guard let self = self else { return }
      self.logState("Action \(action.verboseDescription) completed.")
      self.actionCompletionHandler?(action)
      self.executeActions()
    }
  }

  private func handleSequenceCompletion() {
    if remainingLoops > 0, !isCancelled {
      remainingLoops -= 1
      logState("Looping sequence: \(remainingLoops) remaining loops")
      actions = originalActions
      executeActions()
    } else {
      logState("All steps completed.")
      completionHandler?()
    }
  }
}

// MARK: - Base Configuration

extension Sequencer {

  public final func applyToAll(_ defaultConfiguration: AnimationConfiguration) -> Self {
    actions = actions.map { action in
      switch action {
      case let animateAction as AnimateAction:
        return AnimateAction(configuration: defaultConfiguration, action: animateAction.action)
      case let delayAction as DelayAction:
        return DelayAction(seconds: delayAction.seconds) {
          withAnimation(defaultConfiguration.animation) {
            delayAction.action()
          }
        }
      case let repeatAction as RepeatAction:
        let updatedAction = applyToAction(repeatAction.action, defaultConfiguration: defaultConfiguration)
        return RepeatAction(action: updatedAction, times: repeatAction.times)
      default:
        return action
      }
    }
    return self
  }

  private func applyToAction(
    _ action: SequenceAction,
    defaultConfiguration: AnimationConfiguration
  ) -> SequenceAction {
    switch action {
    case let animateAction as AnimateAction:
      return AnimateAction(configuration: defaultConfiguration, action: animateAction.action)
    case let delayAction as DelayAction:
      return DelayAction(seconds: delayAction.seconds) {
        withAnimation(defaultConfiguration.animation) {
          delayAction.action()
        }
      }
    case let repeatAction as RepeatAction:
      return RepeatAction(
        action: applyToAction(repeatAction.action, defaultConfiguration: defaultConfiguration),
        times: repeatAction.times
      )
    default:
      return action
    }
  }
}

// MARK: - Default Steps

extension Sequencer {

  @discardableResult
  public func perform(_ action: SequenceAction) -> Self {
    actions.append(action)
    return self
  }

  @discardableResult
  public final func run(action: @escaping DefaultClosure) -> Self {
    actions.append(RunAction(action: action))
    return self
  }

  public final func runBlock(_ block: (BlockSequencer) -> Void) -> Self {
    let tempBlockSequencer = BlockSequencer(globalConfiguration: globalConfiguration)
    block(tempBlockSequencer)
    let nestedActions = tempBlockSequencer.buildBlockAction()
    actions.append(nestedActions)
    return self
  }

  @discardableResult
  public final func animate(
    _ configuration: AnimationConfiguration? = nil,
    action: @escaping DefaultClosure
  ) -> Self {
    let effectiveConfiguration = configuration ?? globalConfiguration
    actions.append(AnimateAction(
      configuration: effectiveConfiguration,
      action: action
    ))
    return self
  }

  @discardableResult
  public final func delayFor(
    _ seconds: CGFloat,
    animate configuration: AnimationConfiguration? = nil,
    action: @escaping DefaultClosure
  ) -> Self {
    let effectiveConfiguration = configuration ?? globalConfiguration
    actions.append(DelayAction(seconds: seconds) {
      withAnimation(effectiveConfiguration.animation) {
        action()
      }
    })
    return self
  }

  @discardableResult
  public final func delayFor(_ seconds: CGFloat, action: @escaping DefaultClosure) -> Self {
    actions.append(DelayAction(seconds: seconds, action: action))
    return self
  }

  @discardableResult
  public final func pause(_ seconds: CGFloat) -> Self {
    actions.append(PauseAction(seconds: seconds))
    return self
  }

  @discardableResult
  public final func `repeat`(times: Int) -> Self {
    guard let lastAction = actions.last else { return self }
    actions.removeLast()
    actions.append(RepeatAction(action: lastAction, times: times))
    return self
  }

  @discardableResult
  public final func loop(times: Int) -> Self {
    guard times > 0 else { return self }
    loopCount = times
    return self
  }
}

// MARK: - Debugging

extension Sequencer {

  public final func debug() -> Self {
    logsSteps = true
    return self
  }

  func logState(_ message: String) {
    guard logsSteps else { return }

    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
      print(message)
    } else {
      sequenceLogger.log("\(message, privacy: .public)")
    }
  }
}
