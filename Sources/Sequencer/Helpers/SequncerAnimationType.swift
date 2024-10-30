//
//  SequncerAnimationType.swift
//  Sequencer
//
//  Created by Josh Robbins on 10/30/24.
//

/// An enumeration representing different types of animations for use within the `Sequencer`.
/// Each case specifies a particular animation style along with its parameters, allowing for
/// precise control over animation duration, response, and damping.
///
/// The `animationWithDuration` computed property returns an `AnimationWithDuration` instance
/// based on the selected animation type, making it easy to configure animations within a sequence.
public enum SequencerAnimationType {

  /// A linear animation with a constant speed from start to finish.
  /// - Parameter duration: The total duration of the animation in seconds.
  case linear(duration: Double)

  /// An ease-in animation that starts slowly and accelerates.
  /// - Parameter duration: The total duration of the animation in seconds.
  case easeIn(duration: Double)

  /// An ease-out animation that starts quickly and decelerates.
  /// - Parameter duration: The total duration of the animation in seconds.
  case easeOut(duration: Double)

  /// An ease-in-ease-out animation that starts and ends slowly, with acceleration in between.
  /// - Parameter duration: The total duration of the animation in seconds.
  case easingInEaseOut(duration: Double)

  /// A spring animation that simulates a spring-like motion.
  /// - Parameters:
  ///   - response: Controls the stiffness of the spring. Higher values make it move faster.
  ///   - dampingFraction: Determines the amount of bounciness. Values closer to 1 reduce bounce.
  ///   - blendDuration: Adjusts the blending between animations when transitioning.
  case spring(response: Double, dampingFraction: Double, blendDuration: Double)

  /// A bouncy animation with a specified duration.
  /// - Parameter duration: The total duration of the animation in seconds.
  case bounce(duration: Double)

  /// A computed property that provides an `AnimationWithDuration` instance configured
  /// according to the animation type and its parameters.
  var animationWithDuration: AnimationWithDuration {
    switch self {
    case .linear(let duration):
      return AnimationWithDuration.linear(duration: duration)
    case .easeIn(let duration):
      return AnimationWithDuration.easeIn(duration: duration)
    case .easeOut(let duration):
      return AnimationWithDuration.easeOut(duration: duration)
    case .easingInEaseOut(let duration):
      return AnimationWithDuration.easeInEaseOut(duration: duration)
    case .spring(let response, let dampingFraction, let blendDuration):
      return AnimationWithDuration.spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
    case .bounce(let duration):
      return AnimationWithDuration.bouncy(duration: duration)
    }
  }
}
