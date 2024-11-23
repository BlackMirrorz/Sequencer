//
//  BlockSequencer.swift
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
import SwiftUI

/**
 `BlockSequencer` is responsible for managing a sequence of actions that can include animations, delays, and repetitions.
  It supports the ability to globally configure animations and dynamically update configurations during execution.
 */
public final class BlockSequencer {
  var actions: [SequenceAction] = []
  var globalConfiguration: AnimationConfiguration?
  private var repeatCount: Int?
  private var loopCount: Int?

  // MARK: - Initialization

  /**
   Initializes a new `BlockSequencer` instance with an optional global configuration.

   - Parameter globalConfiguration: The global animation configuration to be applied to actions.
   */
  init(globalConfiguration: AnimationConfiguration?) {
    self.globalConfiguration = globalConfiguration
  }

  // MARK: - Build Actions

  func buildBlockAction() -> BlockAction {
    var builtActions = actions

    if let repeatCount = repeatCount {
      var repeatedActions: [SequenceAction] = []
      for _ in 0 ... repeatCount {
        repeatedActions.append(contentsOf: builtActions)
      }
      builtActions = repeatedActions
    }

    if let loopCount = loopCount {
      var loopedActions: [SequenceAction] = []
      for _ in 0 ..< loopCount {
        loopedActions.append(contentsOf: builtActions)
      }
      builtActions = loopedActions
    }

    return BlockAction(actions: builtActions)
  }
}

// MARK: - Blocks

extension BlockSequencer: BlockSequencable {

  public func run(action: @escaping DefaultClosure) {
    actions.append(RunAction(action: action))
  }

  public func perform(_ action: SequenceAction) {
    actions.append(action)
  }

  public func animate(_ configuration: AnimationConfiguration? = nil, action: @escaping DefaultClosure) {
    let effectiveConfiguration = configuration ?? globalConfiguration ?? .linear(duration: 0.3)
    actions.append(AnimateAction(configuration: effectiveConfiguration, action: action))
  }

  public final func delayFor(
    _ seconds: CGFloat,
    animate configuration: AnimationConfiguration? = nil,
    action: @escaping DefaultClosure
  ) {
    let effectiveConfiguration = configuration ?? globalConfiguration ?? .linear(duration: 0.3)
    actions.append(DelayAction(seconds: seconds) {
      withAnimation(effectiveConfiguration.animation) {
        action()
      }
    })
  }

  public final func delayFor(_ seconds: CGFloat, action: @escaping DefaultClosure) {
    actions.append(DelayAction(seconds: seconds, action: action))
  }

  public func pause(_ seconds: CGFloat) {
    actions.append(PauseAction(seconds: seconds))
  }

  public func `repeat`(times: Int) {
    repeatCount = times
  }

  public func loop(times: Int) {
    loopCount = times
  }
}
