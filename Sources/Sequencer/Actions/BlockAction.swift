//
//  BlockAction.swift
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
 Runs a block(Array) of Sequence Actions
 */
public struct BlockAction: SequenceAction {
  var actions: [SequenceAction]
  private(set) var repeatCount: Int?
  private(set) var loopCount: Int?

  public var verboseDescription: String {

    let descriptions = actions.map { $0.verboseDescription }
    return """
    Block Action:
    \(descriptions.joined(separator: "\n"))
    """
  }

  // MARK: - Execution

  public func execute(completion: @escaping () -> Void) {
    guard !actions.isEmpty else {
      completion()
      return
    }

    let repeatedActions = applyRepeats(to: actions)
    let finalActions = applyLoops(to: repeatedActions)

    executeNextAction(in: finalActions, completion: completion)
  }
}

// MARK: - Internal

extension BlockAction {

  private func applyRepeats(to actions: [SequenceAction]) -> [SequenceAction] {
    guard let repeatCount = repeatCount, repeatCount > 0 else { return actions }
    return Array(repeating: actions, count: repeatCount + 1).flatMap { $0 }
  }

  private func applyLoops(to actions: [SequenceAction]) -> [SequenceAction] {
    guard let loopCount = loopCount, loopCount > 0 else { return actions }
    return Array(repeating: actions, count: loopCount).flatMap { $0 }
  }

  private func executeNextAction(in actions: [SequenceAction], completion: @escaping () -> Void) {
    var remainingActions = actions

    guard let nextAction = remainingActions.first else {
      completion()
      return
    }

    remainingActions.removeFirst()
    nextAction.execute {
      executeNextAction(in: remainingActions, completion: completion)
    }
  }
}
