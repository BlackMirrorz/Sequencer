//
//  AnimationConfiguration.swift
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
public struct AnimationConfiguration: DurationCalculable {

  /// The SwiftUI `Animation` instance that defines the animation style and behavior.
  public let animation: Animation

  /// The duration of the animation in seconds.
  public var duration: Double = 0

  /// The speed of the animation
  public let speed: Double

  /// The number of times to repeat the animation
  public let repeatCount: Int?

  /// A description of the animation type for debugging or logging purposes.
  public let verboseDescription: String

  // MARK: - Initialization

  /// Initializes a new ` AnimationConfiguration` with a specified animation type, duration, speed, and options for autoreversing and repeat count.
  ///
  /// - Parameters:
  ///   - animation: The SwiftUI `Animation` type to apply (e.g., `.linear`, `.easeIn`, `.spring`).
  ///   - duration: The base duration of the animation, in seconds.
  ///   - speed: The speed factor for the animation, with a default value of `1.0`. Lower values slow down the animation, while higher values speed it up.
  ///   - repeatCount: The number of times the animation repeats.
  ///   - verboseDescription: A description of the animation type, useful for logging or debugging. Defaults to an empty string.
  public init(
    animation: Animation,
    duration: Double,
    speed: Double = 1.0,
    repeatCount: Int? = nil,
    verboseDescription: String = ""
  ) {
    self.animation = animation
    self.speed = speed
    self.repeatCount = repeatCount
    self.verboseDescription = """
    \(verboseDescription) | Duration: \(duration) s, Speed: \(self.speed), Repeat Count: \(self.repeatCount ?? 0)
    """
    self.duration = duration
    let adjustedDuration = calculateAdjustedDuration()
    self.duration = adjustedDuration
  }
}

// MARK: - Convenience Methods

extension AnimationConfiguration {

  /// Creates a linear animation with a specified duration.
  ///
  /// - Parameters:
  /// - duration: The duration of the animation, in seconds.
  /// - repeatCount: The number of times the animation repeats.
  /// - Returns: An `AnimationConfiguration` instance with a linear animation.
  public static func linear(duration: Double, speed: Double = 1.0, repeatCount: Int? = nil) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .linear(duration: duration),
      duration: duration,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Linear Animation"
    )
  }

  /// Creates an ease-in animation with a specified duration.
  ///
  /// - Parameters:
  /// - duration: The duration of the animation, in seconds.
  /// - repeatCount: The number of times the animation repeats.
  /// - Returns: An `AnimationConfiguration` instance with an ease-in animation.
  public static func easeIn(duration: Double, speed: Double = 1.0, repeatCount: Int? = nil) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .easeIn(duration: duration),
      duration: duration,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Ease In Animation"
    )
  }

  /// Creates an ease-out animation with a specified duration.
  ///
  /// - Parameters:
  /// - duration: The duration of the animation, in seconds.
  /// - repeatCount: The number of times the animation repeats.
  /// - Returns: An `AnimationConfiguration` instance with an ease-out animation.
  public static func easeOut(duration: Double, speed: Double = 1.0, repeatCount: Int? = nil) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .easeOut(duration: duration),
      duration: duration,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Ease Out Animation"
    )
  }

  /// Creates an ease-in-ease-out animation with a specified duration.
  ///
  /// - Parameters:
  /// - duration: The duration of the animation, in seconds.
  /// - repeatCount: The number of times the animation repeats.
  /// - Returns: An `AnimationConfiguration` instance with an ease-in-ease-out animation.
  public static func easeInEaseOut(duration: Double, speed: Double = 1.0, repeatCount: Int? = nil) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .easeInOut(duration: duration),
      duration: duration,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Ease In-Ease Out Animation"
    )
  }

  /// Creates a spring animation with configurable response and damping parameters.
  ///
  /// - Parameters:
  ///   - response: The stiffness of the spring; higher values make it faster. Defaults to `0.5`.
  ///   - dampingFraction: Controls the "bounciness" of the spring; values closer to `1.0` reduce bounce. Defaults to `0.8`.
  ///   - blendDuration: The amount of blending between animations when transitioning. Defaults to `0.0`.
  ///   - speed: The speed factor for the animation.
  ///   - repeatCount: The number of times to repeat the animation.
  /// - Returns: An `AnimationConfiguration` instance with a spring animation.
  public static func spring(
    response: Double = 0.5,
    dampingFraction: Double = 0.8,
    blendDuration: Double = 0.0,
    speed: Double = 1.0,
    repeatCount: Int? = nil
  ) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration),
      duration: response,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Spring Animation"
    )
  }

  /// Creates a bouncy animation with a specified duration.
  ///
  /// - Parameters:
  /// - duration: The duration of the animation, in seconds.
  /// - speed: The speed of the animation
  /// - repeatCount: The number of times the animation repeats.
  /// - Returns: An `AnimationConfiguration` instance with a bouncy animation.
  public static func bouncy(duration: Double, speed: Double = 1.0, repeatCount: Int? = nil) -> AnimationConfiguration {
    AnimationConfiguration(
      animation: .bouncy(duration: duration),
      duration: duration,
      speed: speed,
      repeatCount: repeatCount,
      verboseDescription: "Bouncy Animation"
    )
  }
}
