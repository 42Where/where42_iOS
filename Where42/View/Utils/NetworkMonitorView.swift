//
//  NetworkMonitorView.swift
//  Where42
//
//  Created by 현동호 on 1/31/24.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")

    @Published var isConnected = false
    @Published var ㅁㅁㅁ = ""

    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.ㅁㅁㅁ = path.debugDescription
                print(path.availableInterfaces)
                print(path.unsatisfiedReason)
                if path.usesInterfaceType(.wifi) {
                    print("Using wifi")
                } else if path.usesInterfaceType(.cellular) {
                    print("Using cellular")
                } else if path.usesInterfaceType(.wiredEthernet) {
                    print("Using wiredEthernet")
                } else if path.usesInterfaceType(.other) {
                    print("Using other")
                } else {
                    self.isConnected = false
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }

    func startMonitoring() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if path.usesInterfaceType(.wifi) {
                    print("Using wifi")
                } else if path.usesInterfaceType(.cellular) {
                    print("Using cellular")
                }
            }
        }
//        networkMonitor.start(queue: workerQueue)
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

                Text("네트워크가 감지되지 않습니다. 연결 후 다시 시도해 주세요")
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
