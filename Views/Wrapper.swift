//
//  Wrapper.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import SwiftUI

struct Wrapper: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.currentUser != nil {
                HomeView()
                    .environmentObject(CarsManager(uid: authManager.currentUser?.uid))
                    .environmentObject(UsersManager(uid: authManager.currentUser?.uid))
            } else {
                AuthenticationView()
                    .environmentObject(CarsManager(uid: authManager.currentUser?.uid))
                    .environmentObject(UsersManager(uid: authManager.currentUser?.uid))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Wrapper_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
            .environmentObject(AuthManager())
    }
}
