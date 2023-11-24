//
//  Font.swift
//  Where42
//
//  Created by 현동호 on 10/29/23.
//

import SwiftUI

struct GmarketSansTTF {
    let bold: String = "GmarketSansTTFBold"
    let light: String = "GmarketSansTTFLight"
    let medium: String = "GmarketSansTTFMedium"
}

extension Font {
    // Bold
    static let GmarketBold34: Font = .custom("GmarketSansTTFBold", size: 34)
    static let GmarketBold28: Font = .custom("GmarketSansTTFBold", size: 28)
    static let GmarketBold24: Font = .custom("GmarketSansTTFBold", size: 24)
    static let GmarketBold18: Font = .custom("GmarketSansTTFBold", size: 18)
    static let GmarketBold14: Font = .custom("GmarketSansTTFBold", size: 14)

    // Light
    static let GmarketLight34: Font = .custom("GmarketSansTTFLight", size: 34)
    static let GmarketLight18: Font = .custom("GmarketSansTTFLight", size: 18)
    static let GmarketLight14: Font = .custom("GmarketSansTTFLight", size: 14)

    // Medium
    static let GmarketMedium18: Font = .custom("GmarketSansTTFMedium", size: 18)
    static let GmarketMedium14: Font = .custom("GmarketSansTTFMedium", size: 14)

    // Custom
    static let GmarketBold: String = "GmarketSansTTFBold"
    static let GmarketLight: String = "GmarketSansTTFLight"
    static let GmarketMedium: String = "GmarketSansTTFMedium"
}
