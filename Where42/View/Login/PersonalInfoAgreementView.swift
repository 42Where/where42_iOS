//
//  PersonalInfoAgreementView.swift
//  Where42
//
//  Created by 현동호 on 12/7/23.
//

import SwiftUI

struct PersonalInfoAgreementView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.30)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(spacing: 20) {
                Text("개인정보 수집 및 이용 동의서(필수)")
                    .font(.custom(Font.GmarketBold, size: 20))

                Text("(재)이노베이션 아카데미는 『개인정보 보호법』 제15조 등 관련 법령에 따라 서비스 이용자의 개인정보보로를 매우 중시하며, 서비스 제공에 반드시 필요한 개인정보의 수집•이용을 위하여 귀하의 동의를 받고자 합니다.")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .foregroundStyle(.whereMediumNavy)
                    .multilineTextAlignment(.center)

                Text("개인정보의 수집 및 이용 목적")
                    .font(.custom(Font.GmarketBold, size: 17))
                Text("어디있니 현재 위치 확인 서비스 제공")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .foregroundStyle(.whereMediumNavy)

                Text("수집하는 개인정보 항목")
                    .font(.custom(Font.GmarketBold, size: 17))
                Text("인트라 로그인 아이디, 클러스터 출입 상태, 입실 시 현재 입실 한 클러스터, 출입카드 마지막 태그 시간")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .foregroundStyle(.whereMediumNavy)
                    .multilineTextAlignment(.center)

                Text("개인정보의 보유 및 이용기간")
                    .font(.custom(Font.GmarketBold, size: 17))
                Text("3년 - (보유기관 경과 및 보유목적 달성시 지체 없이 파기합니다)")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .foregroundStyle(.whereMediumNavy)
                    .multilineTextAlignment(.center)

                Text("동의 거부 권리 및 동의 거부에 따른 불이익 내용 또는 제한사항")
                    .font(.custom(Font.GmarketBold, size: 17))
                    .multilineTextAlignment(.center)
                Text("귀하는 개인정보 수집 및 이용에 대해 동의를 거부할 권리가 있습니다. 필수항목에 대한 동의 거부 시 어디있니 서비스 제공이 제한됨을 알려드립니다.")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .foregroundStyle(.whereMediumNavy)
                    .multilineTextAlignment(.center)

                HStack {
                    Spacer()

                    Button {} label: {
                        Text("거절")
                            .padding(.horizontal, 6)
                            .padding(4)
                            .foregroundStyle(.whereDeepNavy)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.whereDeepNavy, lineWidth: 1)
                            )
                    }

                    Spacer()

                    Button {} label: {
                        Text("동의")
                            .padding(.horizontal, 6)
                            .padding(4.5)
                            .foregroundStyle(.white)
                            .background(.whereDeepNavy)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }

                    Spacer()
                }
                .font(.custom(Font.GmarketMedium, size: 16))
            }
            .padding(30)
            .frame(width: 380)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    PersonalInfoAgreementView()
}
