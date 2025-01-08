//
//  OnFirstAppearViewModifier.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 8/1/25.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !didAppear {
                perform?()
                didAppear = true
            }
        }
    }
}

extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        return modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
