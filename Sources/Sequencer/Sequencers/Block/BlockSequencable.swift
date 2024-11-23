//
//  BlockSequencable.swift
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

/**
 A protocol defining a sequence of block-based actions, including delays, animations, and repetitions.
 */
protocol BlockSequencable {

  /// Adds an instantaneous action to the sequence.
  /// - Parameter action: The block of code to be executed.
  func run(action: @escaping DefaultClosure)

  /// Adds the specified sequence action to the sequence. Ideal for custom actions.
  /// - Parameter action: The action to be executed.
  func perform(_ action: SequenceAction)

  /// Adds an animated action to the sequence.
  /// - Parameters:
  ///   - configuration: An optional `AnimationConfiguration` instance defining the animation style and duration.
  ///     If `nil`, the global configuration is used.
  ///   - action: The closure to execute within the animation.
  func animate(_ configuration: AnimationConfiguration?, action: @escaping DefaultClosure)

  /// Delays the execution of an action for a specified duration with an optional animation.
  /// - Parameters:
  ///   - seconds: Duration to wait before the action is executed.
  ///   - configuration: An optional `AnimationConfiguration` for animating the delay.
  ///     If `nil`, the global configuration is used.
  ///   - action: The block of code to be executed after the delay.
  func delayFor(
    _ seconds: CGFloat,
    animate configuration: AnimationConfiguration?,
    action: @escaping DefaultClosure
  )

  /// Delays the execution of an action for a specified duration without animation.
  /// - Parameters:
  ///   - seconds: Duration to wait before the action is executed.
  ///   - action: The block of code to be executed after the delay.
  func delayFor(_ seconds: CGFloat, action: @escaping DefaultClosure)

  /// Pauses the sequence for a specified duration.
  /// - Parameter seconds: Duration to pause in seconds.
  func pause(_ seconds: CGFloat)

  /// Repeats the last action in the sequence a specified number of times.
  /// - Parameter times: The number of times to repeat the last action in the sequence.
  func `repeat`(times: Int)

  /// Loops the sequence a specified number of times.
  /// - Parameter times: The number of times to repeat the entire sequence.
  func loop(times: Int)
}
