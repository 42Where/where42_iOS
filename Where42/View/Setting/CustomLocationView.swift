//
//  CustomLocationView.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct CustomLocationView: View {
    private let defaultFloor = ["", "1층", "2층", "3층", "4층", "5층", "B1 / 옥상"]
    private let defaultLocation = [
        [],
        ["오픈 스튜디오", "오픈 라운지", "42LAB", "유튜브 스튜디오"],
        ["유튜브 스튜디오", "오아시스", "회의실A", "회의실B", "스톤테이블", "기타 학습공간"],
        ["오아시스", "다각형 책상A", "다각형 책상"],
        ["오아시스", "회의실A", "회의실B", "스톤테이블", "기타 학습공간"],
        ["오아시스", "좌식공간", "스톤 테이블", "기타 학습공간"],
        ["오픈 스튜디오", "탁구대", "야외정원", "기타 학습공간"]
    ]
    @State private var floor = 0
    @State private var customLocation = ""

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea(.all)
                .onTapGesture {}

            VStack {
                Text("수동 자리 설정")
                    .font(.custom(Font.GmarketBold, size: 18))
                    .padding(.bottom, 10)

                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        VStack(spacing: 10) {
                            Text("층 수 선택")
                                .font(.custom(Font.GmarketBold, size: 18))

                            Divider()
                                .overlay(.whereDeepNavy)

                            VStack(spacing: 20) {
                                ForEach(defaultFloor.indices, id: \.self) { index in
                                    if index != 0 {
                                        Button {
                                            withAnimation {
                                                self.floor = index
                                            }
                                        } label: {
                                            Text(defaultFloor[index])
                                        }
                                    }
                                }
                            }
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .foregroundStyle(.whereDeepNavy)
                            .padding(.horizontal, 15)
                        }
                        .frame(width: 140)
                        .padding(.vertical, 15)

                        Divider()
                            .overlay(.whereDeepNavy)

                        VStack(spacing: 10) {
                            Text("장소 선택")
                                .font(.custom(Font.GmarketBold, size: 18))

                            Divider()
                                .overlay(.whereDeepNavy)

                            VStack(spacing: 20) {
                                ForEach(defaultLocation[floor], id: \.self) { location in
                                    Button {
                                        customLocation = defaultFloor[floor] + " " + location
                                        print(customLocation)
                                    } label: {
                                        Text(location)
                                            .font(.custom(Font.GmarketMedium, size: 15))
                                            .foregroundStyle(.whereDeepNavy)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .font(.custom(Font.GmarketMedium, size: 15))
                        }
                        .frame(width: 140)
                        .padding(.vertical, 15)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.whereDeepNavy, lineWidth: 1)
                )

                HStack {
                    Spacer()

                    Button {} label: {
                        Text("취소")
                            .padding(.horizontal, 6)
                            .padding(4)
                            .foregroundStyle(.whereDeepNavy)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.whereDeepNavy, lineWidth: 1)
                            )
                    }

                    Button {} label: {
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
                .padding(.trailing, 10)
            }
            .frame(width: 300, height: 350)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    CustomLocationView()
}
