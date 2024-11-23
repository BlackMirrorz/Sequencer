//
//  AnimationDurationCalculable.swift
//  Sequencer
//
//  Created by Josh Robbins on 11/8/24.
//

/**
 A protocol for calculating the total adjusted duration of an animation based on duration, speed, and repeat count.

 This protocol provides a default implementation to adjust the duration according to specified speed
 and repeat count values, ensuring consistent behavior across types that conform to it.
 */
protocol DurationCalculable {

  /// The base duration of the animation in seconds.
  /// Represents the initial duration of the animation before any adjustments for speed or repeat count.
  var duration: Double { get }

  /// The speed factor for the animation.
  /// - Values greater than `1.0` will speed up the animation, while values between `0` and `1.0` slow it down.
  /// - A value of `1.0` means the animation runs at normal speed.
  /// - Defaults to `1.0` if zero or negative values are provided.
  var speed: Double { get }

  /// The number of times to repeat the animation after its initial playthrough.
  /// - If `nil`, the animation runs only once without repeats.
  /// - If `repeatCount = 2`, the animation plays three times in total: the initial playthrough plus two repeats.
  /// This aligns with expected behavior for repeat counts, representing additional repeats beyond the initial playback.
  var repeatCount: Int? { get }

  /**
   Calculates the total adjusted duration based on `duration`, `speed`, and `repeatCount`.

   This calculation considers:
   - **Speed Adjustment**: Divides the base duration by the speed factor to adjust for faster or slower animations.
   - **Repeat Count Adjustment**: Multiplies the adjusted duration by `(repeatCount + 1)` to include the initial playthrough.

   ## Discussion:
   - **Initial Animation Pass**: An animation repeats a specified number of times after playing once initially.
      - For instance, if `repeatCount = 2`, the animation plays **three times**: once initially, and then two additional repeats.
   - **Total Duration Calculation**:
      - For `repeatCount = 0`, the animation plays only once.
      - For `repeatCount = 2`, the animation plays three times: the initial playthrough plus two repeats.

   By adding 1 to the repeat count, we align with expected behavior, ensuring `repeatCount` reflects additional repeats beyond the initial play.

   - Returns: The total adjusted duration, considering speed and repeat count.
   */
  func calculateAdjustedDuration() -> Double
}

// MARK: - Default Implentation

extension DurationCalculable {

  func calculateAdjustedDuration() -> Double {

    let adjustedDuration = duration / (speed > 0 ? speed : 1.0)

    if let repeatCount = repeatCount {
      return adjustedDuration * Double(repeatCount + 1)
    } else {
      return adjustedDuration
    }
  }
}
