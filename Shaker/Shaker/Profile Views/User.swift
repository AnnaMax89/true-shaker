//
//  AuthModel.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-12-05.
//

import Foundation
import FirebaseCore
import FirebaseAuth

enum UserState {
  case unauthenticated
  case authenticating
  case authenticated
}

class UserClass:  ObservableObject{
    @Published var email: String = ""
    @Published var uid: String = ""
    @Published var password: String = ""
    @Published var isValid  = false
    @Published var user: User?
    @Published var userState: UserState = .unauthenticated
    
    var confirmPassword: String = ""
    var errorMessage = ""
    var displayName = ""
    
    init() {
        registerAuthStateHandler()
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
      if authStateHandler == nil {
          authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
              self.user = user
              self.email = user?.email ?? ""
              self.uid = user?.uid ?? "(no uid)"
              self.userState = user == nil ? .unauthenticated : .authenticated
//              print("User \(self.uid) signed in already")
          }
      } else {
          print("User is not signed in")
      }
    }
}

extension UserClass{
    func signInWithEmailPassword(){
        self.userState = .authenticating
        Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error in
            guard let authuser = authResult?.user else { return }
            if error == nil {
                self.email = authuser.email ?? "(unknown)"
                self.uid = authuser.uid
                self.userState = .authenticated
                print("User \(self.email) signed in succesfully")
            } else {
                print(error ?? "(unknow error)")
                self.userState = .unauthenticated
            }
        }
    }

    func signUpWithEmailPassword(){
        userState = .authenticating
        Auth.auth().createUser(withEmail: self.email, password: self.password) { createResult, error in
            guard let createduser = createResult?.user else { return }
            if error == nil {
                self.email = createduser.email ?? "(unknown)"
                self.uid = createduser.uid
                self.userState = .authenticated
                print("User \(self.email) created succesfully")
            } else {
                print(error ?? "(unknow error)")
                self.userState = .unauthenticated
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out succesfully")
            userState = .unauthenticated
        } catch {
            print(error)
        }
    }

    func deleteAccount() {
        
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                print("User deleted succesfully")
                self.userState = .unauthenticated
            }
        }
    }
    
    
}


