//
//  SignInView.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToSignUp = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    formView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert("Ошибка", isPresented: .constant(errorMessage != nil), presenting: $errorMessage) { detail in
                        Button("OK", role: .cancel) { errorMessage = nil }
                    } message: { detail in
                        Text("Something went wrong")
                    }
        }

    var formView: some View {
            VStack(spacing: 20) {
                Image("car_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                
                Text("Вход в систему")
                    .font(.title2)
                    .foregroundColor(.primary)
                
                TextField("Введите электронную почту", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 20)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                   
                
                SecureField("Введите пароль", text: $password)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 20)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                
                Button("Войти") {
                    signIn()
                }
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(20)
                .foregroundColor(Color.white)
                .disabled(email.isEmpty || password.count < 8)
                
                Button("Нет аккаунта? Зарегистрируйтесь") {
                    navigateToSignUp = true
                }
                .buttonStyle(.plain)
                .font(.footnote)
                NavigationLink(destination: SignUpView(), isActive: $navigateToSignUp) {
                    EmptyView()
                }
            }
            .padding()
        }
    
    private func signIn() {
        guard !email.isEmpty, password.count >= 8 else { return }
        isLoading = true
        authManager.signInWithEmailAndPassword(email: email, password: password){ user, error in
            isLoading = false
            if let error = error{
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthManager())
    }
}
