//
//  RepeatAction.swift
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

/**
 Repeats an action based on the number of times desired
 */
struct RepeatAction: SequenceAction {
  let action: SequenceAction
  let times: Int

  var verboseDescription: String { "Repeating action \(times) times: \(action.verboseDescription)" }

  func execute(completion: @escaping DefaultClosure) {
    guard times > 0 else {
      completion()
      return
    }

    func executeRepeatedAction(currentIteration: Int) {
      guard currentIteration <= times else {
        completion()
        return
      }

      action.execute {
        executeRepeatedAction(currentIteration: currentIteration + 1)
      }
    }

    executeRepeatedAction(currentIteration: 0)
  }
}
