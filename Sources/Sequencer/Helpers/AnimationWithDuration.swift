//
//  AnimationWithDuration.swift
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
 A struct that encapsulates an animation type and its duration, providing  a convenient way to handle animations with specific timing and style options.
 */
public struct AnimationWithDuration {

  /// The SwiftUI `Animation` instance that defines the animation style and behavior.
  public let animation: Animation

  /// The duration of the animation in seconds.
  public let duration: Double

  /// A description of the animation type for debugging or logging purposes.
  public let verboseDescription: String

  // MARK: - Initialization

  /// Initializes a new `AnimationWithDuration` with a specified animation, duration, and description.
  ///
  /// - Parameters:
  ///   - animation: The SwiftUI `Animation` type (e.g., linear, easeIn) to apply.
  ///   - duration: The duration of the animation, in seconds.
  ///   - verboseDescription: A description of the animation type.
  private init(animation: Animation, duration: Double, verboseDescription: String) {
    self.animation = animation
    self.duration = duration
    self.verboseDescription = verboseDescription
  }
}

// MARK: - Convenience Methods

extension AnimationWithDuration {

  /// Creates a linear animation with a specified duration.
  ///
  /// - Parameter duration: The duration of the animation, in seconds.
  /// - Returns: An `AnimationWithDuration` instance with a linear animation.
  public static func linear(duration: Double) -> AnimationWithDuration {
    AnimationWithDuration(animation: .linear(duration: duration), duration: duration, verboseDescription: "Linear Animation")
  }

  /// Creates an ease-in animation with a specified duration.
  ///
  /// - Parameter duration: The duration of the animation, in seconds.
  /// - Returns: An `AnimationWithDuration` instance with an ease-in animation.
  public static func easeIn(duration: Double) -> AnimationWithDuration {
    AnimationWithDuration(animation: .easeIn(duration: duration), duration: duration, verboseDescription: "Ease In Animation")
  }

  /// Creates an ease-out animation with a specified duration.
  ///
  /// - Parameter duration: The duration of the animation, in seconds.
  /// - Returns: An `AnimationWithDuration` instance with an ease-out animation.
  public static func easeOut(duration: Double) -> AnimationWithDuration {
    AnimationWithDuration(animation: .easeOut(duration: duration), duration: duration, verboseDescription: "Ease Out Animation")
  }

  /// Creates an ease-in-ease-out animation with a specified duration.
  ///
  /// - Parameter duration: The duration of the animation, in seconds.
  /// - Returns: An `AnimationWithDuration` instance with an ease-in-ease-out animation.
  public static func easeInEaseOut(duration: Double) -> AnimationWithDuration {
    AnimationWithDuration(animation: .easeInOut(duration: duration), duration: duration, verboseDescription: "Ease In-Ease Out Animation")
  }

  /// Creates a spring animation with configurable response and damping parameters.
  ///
  /// - Parameters:
  ///   - response: The stiffness of the spring; higher values make it faster. Defaults to `0.5`.
  ///   - dampingFraction: Controls the "bounciness" of the spring; values closer to `1.0` reduce bounce. Defaults to `0.8`.
  ///   - blendDuration: The amount of blending between animations when transitioning. Defaults to `0.0`.
  /// - Returns: An `AnimationWithDuration` instance with a spring animation.
  public static func spring(response: Double = 0.5, dampingFraction: Double = 0.8, blendDuration: Double = 0.0) -> AnimationWithDuration {
    AnimationWithDuration(
      animation: .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration),
      duration: response,
      verboseDescription: "Spring Animation"
    )
  }

  /// Creates a bouncy animation with a specified duration.
  ///
  /// - Parameter duration: The duration of the animation, in seconds.
  /// - Returns: An `AnimationWithDuration` instance with a bouncy animation.
  public static func bouncy(duration: Double) -> AnimationWithDuration {
    AnimationWithDuration(animation: .bouncy(duration: duration), duration: duration, verboseDescription: "Bouncy Animation")
  }
}
