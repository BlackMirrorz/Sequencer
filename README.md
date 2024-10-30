
# Sequencer

Sequencer is a `Swift` library designed to manage the execution of blocks of code (`SequenceAction`), using an easy-to-use dot syntax style API to build complex chains, making it ideal for building step-based animations or workflows.

It has been designed to be easily extendable.

You can add custom actions, animations, or even new chaining methods by extending `Sequencer` or creating new `SequenceAction` types.

- **Supports**:  
  - Swift 5.9
  
- **Platforms**:  
  - macOS 10.15+  
  - iOS 16+  
  - tvOS 13+  
  - watchOS 7+

## Installation

To install the Sequencer package, add the following to your `Package.swift`:

https://github.com/BlackMirrorz/Sequencer

```swift
dependencies: [
    .package(url: "https://github.com/BlackMirrorz/Sequencer.git", from: "1.0.0")
]
```

Then, import `Sequencer` anywhere you'd like to use it:

```swift
import Sequencer
```

## Usage

### Creating a Sequencer Instance

To create a `Sequencer` instance, initialize it with optional logging enabled:

```swift
let sequencer = Sequencer(logsSteps: true)
```

### Default Actions

`Sequencer` provides several default actions that can be chained together:

- **run**: Executes a block of code immediately.
- **animate**: Executes an animation with a specified duration and style.
- **pause**: Pauses the sequence for a given duration.
- **delayFor**: Delays execution of a block of code for a specified duration.
- **perform**: Adds a custom `SequenceAction` to the sequence, allowing for complex or specific actions that implement the `SequenceAction` protocol.
- **repeat**: Repeats an action based on the number of iterations required.

#### Example Usage

```swift
Sequencer()
    .run { print("Starting sequence") }
    .animate(AnimationWithDuration.easeIn(duration: 0.5)) {
        // Perform animated changes here
    }
    .pause(1.0)
    .run { print("Sequence paused and resumed") }
    .start()
```

### Animation Actions

The `Sequencer` supports animations using `AnimationWithDuration`, a helper struct that combines the animation style and duration into a single parameter, making it easy to add animations to your sequences.

By default, `Sequencer` provides several animation types for convenience:

- **`linear`**: A linear animation over a specified duration. Use this for steady, consistent animations without acceleration or deceleration.
  
  ```swift
  sequencer.animate(AnimationWithDuration.linear(duration: 0.5)) {
      // Perform linear animated changes here
  }
  ```

- **`easeIn`**: An animation that starts slowly and accelerates. This is ideal for actions that need to build up momentum.

  ```swift
  sequencer.animate(AnimationWithDuration.easeIn(duration: 0.5)) {
      // Perform ease-in animated changes here
  }
  ```

- **`easeOut`**: An animation that decelerates towards the end, providing a smooth finish. Useful for actions that should end gradually.

  ```swift
  sequencer.animate(AnimationWithDuration.easeOut(duration: 0.5)) {
      // Perform ease-out animated changes here
  }
  ```

- **`easeInEaseOut`**: An animation that starts slowly, accelerates in the middle, and slows down at the end. Ideal for smooth, organic movements.

  ```swift
  sequencer.animate(AnimationWithDuration.easeInEaseOut(duration: 0.5)) {
      // Perform ease-in-ease-out animated changes here
  }
  ```

- **`spring`**: A spring-like animation with configurable response and damping. It has a natural, bouncing effect suitable for playful or elastic movements.

  ```swift
  sequencer.animate(AnimationWithDuration.spring(response: 0.5, dampingFraction: 0.8)) {
      // Perform spring animation changes here
  }
  ```

- **`bouncy`**: A bouncy animation with a specified duration that can be used for playful effects. It has a gentle bounce at the end.

  ```swift
  sequencer.animate(AnimationWithDuration.bouncy(duration: 0.5)) {
      // Perform bouncy animation changes here
  }
  ```

Each animation type has a corresponding `verboseDescription`, which is useful for debugging or logging purposes. These default types make it easy to add animations to your sequences with minimal setup.

### Reptition
The `repeat(times:)` function allows you to repeat the last action in the sequence a specified number of times. 

Example:

```swift
let sequencer = Sequencer(logsSteps: true)
sequencer
    .delayFor(2) { print("Action executed") }
    .repeat(times: 5) // Repeats the delayFor action 5 times
    .start()
```

## Extending Sequencer

### Adding Custom Actions

To add a custom action to the sequence, create a new struct that conforms to `SequenceAction`. Define what this action should do by implementing the `execute` method.

Example:

```swift
struct CustomLogAction: SequenceAction {
    let message: String
    
    var verboseDescription: String {
        "Custom log action with message: \(message)"
    }
    
    func execute(completion: @escaping () -> Void) {
        print(message)
        completion()
    }
}

// Using the custom action with `Sequencer`
let sequencer = Sequencer()
sequencer
    .perform(CustomLogAction(message: "Custom log entry"))
    .start()
```

### Adding Custom Animations

To create custom animations, define a new initializer in `AnimationWithDuration` or a custom struct encapsulating the animation’s behavior and duration.

Example:

```swift
extension AnimationWithDuration {
    static func customBounce(duration: Double) -> AnimationWithDuration {
        return AnimationWithDuration(animation: .interpolatingSpring(stiffness: 200, damping: 5), duration: duration, verboseDescription: "Custom Bounce Animation")
    }
}

// Using the custom animation in `Sequencer`
let sequencer = Sequencer()
sequencer
    .animate(AnimationWithDuration.customBounce(duration: 0.6)) {
        // Custom bounce animation effect
    }
    .start()
```

## Changelog
