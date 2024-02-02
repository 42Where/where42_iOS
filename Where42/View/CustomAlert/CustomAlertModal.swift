//
//  CustomAlertModal.swift
//  Where42
//
//  Created by 현동호 on 11/9/23.
//

import SwiftUI

struct CustomAlert: View {
    var title: String
    var message: String?
    @Binding var inputText: String
    var textFieldTitle: String?

    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() async -> Void)?

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.30)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    leftButtonAction?()
                }

            VStack(spacing: 20) {
                HStack {
                    Text(title)
                        .font(.custom(Font.GmarketBold, size: 18))

                    if message == nil {
                        Spacer()
                    }
                }

                if let message = message {
                    Text(message)
                        .font(.custom(Font.GmarketMedium, size: 15))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }

                if let textFieldTitle = textFieldTitle {
                    TextField(textFieldTitle, text: $inputText, axis: .vertical)
                        .font(.custom(Font.GmarketMedium, size: 16))
                        .padding(4)
                        .foregroundStyle(.whereDeepNavy)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.whereDeepNavy, lineWidth: 1)
                        )
                        .lineLimit(...5)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                HStack {
                    Spacer()

                    Button {
                        leftButtonAction?()
                    } label: {
                        Text("취소")
                            .padding(.horizontal, 6)
                            .padding(4)
                            .foregroundStyle(.whereDeepNavy)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.whereDeepNavy, lineWidth: 1)
                            )
                    }

                    Button {
                        Task {
                            await rightButtonAction?()
                        }

                    } label: {
                        Text("확인")
                            .padding(.horizontal, 6)
                            .padding(4.5)
                            .foregroundStyle(.white)
                            .background(.whereDeepNavy)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
                .font(.custom(Font.GmarketMedium, size: 15))
            }
            .padding(20)
            .frame(width: UIDevice.idiom == .phone ? 270 : 370)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

struct CustomBasicAlert: View {
    var title: String
    var buttonAction: (() -> Void)?

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
                .onTapGesture {
                    buttonAction?()
                }

            VStack(spacing: 20) {
                HStack {
                    Text(title)
                        .font(.custom(Font.GmarketBold, size: 15))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
            }
            .padding(20)
            .frame(width: UIDevice.idiom == .phone ? 270 : 370)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3))
        }
    }
}

#Preview {
    CustomAlert(title: "상태메시지 변경", inputText: .constant(""), textFieldTitle: "코멘트 입력 바람")
//    CustomAlert(title: "로그아웃", textFieldTitle: nil, message: "이 'Group1' 을(를) 삭제하시겠습니까?", inputText: .constant(""))
//    CustomBasicAlert(title: "현재 페이지를 로드할 수 없습니다")
}
