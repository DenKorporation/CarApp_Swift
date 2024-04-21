//
//  AuthenticationView.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        NavigationView{
            SignInView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
