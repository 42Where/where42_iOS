//
//  NetworkMonitorView.swift
//  Where42
//
//  Created by 현동호 on 1/31/24.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")

    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }

    func startMonitoring() {
        networkMonitor.start(queue: workerQueue)
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied

            if path.usesInterfaceType(.wifi) {
                print("Using wifi")
            } else if path.usesInterfaceType(.cellular) {
                print("Using cellular")
            }
        }
    }
}

struct NetworkMonitorView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.30)
                .ignoresSafeArea(.all)
                .onTapGesture {}

            VStack(spacing: 20) {
                Text("네트워크 연결")
                    .font(.custom(Font.GmarketBold, size: 18))

                Text("네트워크가 감지되지 않습니다. 연결 후 다시 시도해주세요")
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)

                HStack {
                    Button {
                        networkMonitor.startMonitoring()
                    } label: {
                        Text("재시도")
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

#Preview {
    NetworkMonitorView()
        .environmentObject(NetworkMonitor())
}
