//
//  RootView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 9/12/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    var body: some View {
        NavigationStack {
            if !showSignInView {
//                ProfileView(showSignInView: $showSignInView)
                ProductsView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView,
                         content: {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
    }
}

#Preview {
    RootView()
}
