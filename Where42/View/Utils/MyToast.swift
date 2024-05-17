//
//  MyToast.swift
//  Where42
//
//  Created by 현동호 on 2/1/24.
//

import SwiftUI

struct Toast: Equatable {
    var title: String
    var duration: Double = 3
}

struct MyToast: View {
    var title: String
    var onCancleTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red)

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.custom(Font.GmarketMedium, size: 14))
                }
                .foregroundStyle(.whereDeepNavy)

                Spacer(minLength: 1)

                Button {
                    onCancleTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
        .frame(minWidth: 350, maxWidth: 400)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 1)
        .padding(16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(
                    ZStack {
                        mainToastView()
                    }
                    .animation(.spring(), value: toast)
                )
                .onChange(of: toast) { _ in
                    showToast()
                }
        }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                MyToast(
                    title: toast.title
                ) {
                    dismissToast()
                }
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        if toast.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    MyToast(title: "오류 발생", onCancleTapped: {})
}
