//
//  PassThroughWindow.swift
//  Where42
//
//  Created by 현동호 on 2/7/24.
//

import SwiftUI

class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }

        return rootViewController?.view == hitView ? nil : hitView
    }
}
