//
//  AuthManager.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import SwiftUI
import FirebaseAuth
import Foundation

class AuthManager: ObservableObject {
    @Published var currentUser: UserModel?
    private let auth = Auth.auth()
    
    init() {
        self.currentUser = nil
        self.setupAuthStateListener()
    }

    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            if let user = user {
                self.currentUser = self.userFromFirebaseUser(user)
            } else {
                self.currentUser = nil
            }
        }
    }
    
    private func userFromFirebaseUser(_ user: User?) -> UserModel? {
        guard let user = user else { return nil }
        return UserModel(uid: user.uid)
    }
    
    func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (UserModel?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(nil, error)
            } else if let user = result?.user {
                completion(self?.userFromFirebaseUser(user), nil)
            }
        }
    }
    
    func registerWithEmailAndPassword(email: String, password: String, completion: @escaping (UserModel?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(nil, error)
            } else if let user = result?.user{
                Task {
                    do {
                        let usersManager = UsersManager(uid: user.uid)
                        try await usersManager.createUserData()
                    } catch {
                        completion(nil, error)
                    }
                }
                completion(self?.userFromFirebaseUser(user), nil)
            }
        }
    }
    
    func deleteUserAuth() async {
        guard let uid = currentUser?.uid else { return }
        do{
            try await auth.currentUser!.delete()
            try await UsersManager(uid: uid).deleteUserData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let signOutError {
            completion(signOutError)
        }
    }
}
