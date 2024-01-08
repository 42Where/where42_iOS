//
//  SheetOrPopOver.swift
//  Where42
//
//  Created by 현동호 on 1/7/24.
//

import SwiftUI

extension View {
    @ViewBuilder func sheetOrPopOver<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        if UIDevice.idiom == .phone {
            self
                .sheet(isPresented: isPresented, content: content)
        } else if UIDevice.idiom == .pad {
            self
                .popover(isPresented: isPresented, content: content)
        }
    }
}
