//
//  ContentView.swift
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

struct ContentView: View {

  @StateObject private var sequencer = Sequencer()
  @State private var opacity = 1.0

  // MARK: - Body

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      ScrollView {
        LazyVStack(spacing: 20) {
          header

          SequencerView(
            title: "Linear",
            character: .cat,
            configuration: .linear(duration: 0.5)
          )

          SequencerView(
            title: "Ease In",
            character: .dog,
            configuration: .easeIn(duration: 0.5)
          )

          SequencerView(
            title: "Ease Out",
            character: .koala,
            configuration: .easeOut(duration: 0.5)
          )

          SequencerView(
            title: "Ease In-Out",
            character: .pig,
            configuration: .easeInEaseOut(duration: 0.5)
          )

          SequencerView(
            title: "Spring",
            character: .bear,
            configuration: .spring(
              response: 0.5,
              dampingFraction: 0.8,
              blendDuration: 0
            )
          )
        }.padding(.horizontal, 16)
      }
      logo
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  // MARK: - ViewBuilders

  @ViewBuilder
  private var logo: some View {
    Color.black.overlay {
      Image("sequencerLogo")
        .resizable()
        .aspectRatio(contentMode: .fit)
    }.padding(.horizontal, 16)
      .opacity(opacity)
      .onAppear {
        sequencer
          .pause(2)
          .animate(.linear(duration: 2)) {
            opacity = 0
          }.start()
      }.id(1)
  }

  @ViewBuilder
  private var header: some View {
    VStack(spacing: 20) {
      Text("Sequencer")
        .font(.largeTitle)
        .foregroundStyle(.white)
        .bold()
        .padding()
        .frame(maxWidth: .infinity)
    }
  }
}

// MARK: - Preview

#Preview {
  ContentView()
}
