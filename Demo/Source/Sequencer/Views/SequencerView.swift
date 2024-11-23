//
//  SequencerView.swift
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

struct SequencerView: View {

  @StateObject private var service: SequencingService

  // MARK: - Initialization

  /// Initializes a new instance of `SequencerView` with specified parameters.
  /// - Parameters:
  ///   - title: The title to display for the animation view, describing the animation type.
  ///   - character: The character to animate, represented by `AnimationCharacter`.
  ///   - configuration: The type of animation to apply to the character, specified by `AnimationConfiguration`.
  ///
  /// This initializer creates a `SequencingService` as a `StateObject` with the given title, character, and animation type,
  init(title: String, character: AnimationCharacter, configuration: AnimationConfiguration) {
    _service = StateObject(
      wrappedValue: SequencingService(
        title: title,
        character: character,
        configuration: configuration
      )
    )
  }

  // MARK: - Body

  var body: some View {
    VStack {
      title
      character
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .drawingGroup()
  }

  // MARK: - Views

  private var title: some View {
    Text(service.title)
      .font(service.isCentered ? .title : .headline)
      .foregroundStyle(.white)
      .padding(.bottom, 8)
      .frame(maxWidth: .infinity, alignment: service.isCentered ? .center : .leading)
  }

  private var character: some View {
    ZStack {
      Image(service.character.rawValue)
        .resizable()
        .frame(width: 80, height: 80)
        .aspectRatio(contentMode: .fit)
        .scaleEffect(service.scale)
        .scaleEffect(x: service.direction, y: 1)
        .rotationEffect(service.rotation)
        .opacity(service.opacity)
        .offset(x: service.offset)
        .onTapGesture {
          service.run()
        }.onDisappear {
          service.terminate()
        }
    }.frame(maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - Equatable

extension SequencerView: Equatable {

  static func == (lhs: SequencerView, rhs: SequencerView) -> Bool {
    lhs.service.identifier == rhs.service.identifier
  }
}

// MARK: - Preview

#Preview {
  ContentView()
}
