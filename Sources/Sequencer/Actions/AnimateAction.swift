//
//  AnimateAction.swift
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

/**
 Runs an Action with the desired AnimationConfiguration
 */
public struct AnimateAction: SequenceAction {
  let confguration: AnimationConfiguration
  let action: DefaultClosure

  public var verboseDescription: String {
    "Animation of type \(confguration.verboseDescription)"
  }

  // MARK: - Initialization

  /// Initializes a new `AnimateAction` with an animation and action to be performed.
  ///
  /// - Parameters:
  ///   - configuration: The `AnimationConfiguration` instance defining the animation style and duration.
  ///   - action: The closure to execute within the animation.
  public init(configuration: AnimationConfiguration, action: @escaping DefaultClosure) {
    self.confguration = configuration
    self.action = action
  }

  // MARK: - Execution

  public func execute(completion: @escaping DefaultClosure) {
    withAnimation(confguration.animation) {
      action()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + confguration.duration) {
      completion()
    }
  }
}
