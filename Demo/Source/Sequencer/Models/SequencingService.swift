//
//  SequencingService.swift
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

import Sequencer
import SwiftUI

final class SequencingService: ObservableObject {

  let identifier = UUID()

  @Published var isAnimating = false
  @Published var scale: CGFloat = 1
  @Published var rotation: Angle = .degrees(0)
  @Published var offset: CGFloat = 0
  @Published var opacity: CGFloat = 1
  @Published var direction: CGFloat = -1
  @Published var shadowColor: Color = .clear
  @Published var isCentered = false

  private let sequencer = Sequencer()

  let title: String
  let character: AnimationCharacter
  let configuration: AnimationConfiguration

  // MARK: - Initialization

  /// Initializes a new instance of `SequencerViewModel` with specified parameters.
  /// - Parameters:
  ///   - title: The title to display for the animation view, describing the animation type.
  ///   - character: The character to display in the animation, represented by `AnimationCharacter`.
  ///   - configuration: The type of animation to apply to the character, specified by `AnimationConfiguration`.
  init(title: String, character: AnimationCharacter, configuration: AnimationConfiguration) {
    self.title = title
    self.character = character
    self.configuration = configuration
  }
}

// MARK: - Sequencer Logic

extension SequencingService {

  func run() {

    direction = 1
    shadowColor = Bool.random() ? .red : .white

    guard
      !isAnimating
    else {
      terminate()
      return
    }

    sequencer
      .setGlobalConfiguration(configuration)
      .runBlock {
        self.isAnimating = true
        $0.animate {
          self.isCentered = true
          self.opacity = 0.5
        }

        $0.animate { self.isCentered = false }
        $0.animate { self.opacity = 1 }
        $0.animate { self.offset = 100 }
        $0.animate { self.offset = 0 }
        $0.animate { self.rotation = .degrees(360) }
        $0.animate { self.scale = 0.5 }
        $0.animate { self.scale = 1.0 }
        $0.animate {
          self.direction = -1
          self.shadowColor = .clear
        }
      }.completion {
        self.isAnimating = false
      }
      .start()
  }

  func terminate() {
    isAnimating = false
    isCentered = false
    sequencer.cancel()
    scale = 1
    rotation = .degrees(0)
    opacity = 1
    offset = 0
    direction = -1
    shadowColor = .clear
  }
}
