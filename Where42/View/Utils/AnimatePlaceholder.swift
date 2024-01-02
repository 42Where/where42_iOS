//
//  AnimatePlaceholder.swift
//  Where42
//
//  Created by 현동호 on 12/7/23.
//

import SwiftUI

struct AnimatePlaceholder: ViewModifier {
    @Binding var isLoading: Bool

    @State private var isAnimating: Bool = false

    private var center = (UIScreen.main.bounds.width / 2) + 110
    private let animation: Animation = .linear(duration: 1.5)

    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }

    func body(content: Content) -> some View {
        content
//            .overlay(.red)
            .overlay(animateView.mask(content))
    }

    var animateView: some View {
        ZStack {
            Color.black.opacity(isLoading ? 0.09 : 0.0)
            Color.white.mask {
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [.clear, .white.opacity(0.48), .clear]), startPoint: .top, endPoint: .bottom)
                    )
                    .scaleEffect(1.5)
                    .rotationEffect(.init(degrees: 70.0))
                    .offset(x: isAnimating ? center : -center)
            }
        }
        .animation(isLoading ? animation.repeatForever(autoreverses: false) : nil, value: isAnimating)
        .onAppear {
            guard isLoading else { return }
            isAnimating.toggle()
        }
        .onChange(of: isLoading) { _ in
            isAnimating.toggle()
        }
    }
}

extension View {
    func animatePlaceHolder(isLoading: Binding<Bool>) -> some View {
        modifier(AnimatePlaceholder(isLoading: isLoading))
    }
}
